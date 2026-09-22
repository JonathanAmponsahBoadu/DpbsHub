import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';

import '../local/database.dart';

/// Mirrors your local study data to Firestore under `users/{uid}/...` so it
/// follows you to other devices. Conflict rule: last-write-wins by
/// [updatedAt] — whichever side (this device or the cloud copy) has the
/// newer timestamp for a given row wins, and the loser is overwritten to
/// match. Deletions are soft (an `isDeleted` flag), never a hard remove, so
/// a deletion made on one device reliably reaches the others instead of a
/// stale copy quietly reappearing on the next sync.
///
/// API keys are never part of this — they live only in the on-device secure
/// vault (see core/security/api_key_vault.dart) and are never written here.
class SyncService {
  SyncService(this._db, this._uid);
  final AppDatabase _db;
  final String _uid;

  CollectionReference<Map<String, dynamic>> _col(String name) =>
      FirebaseFirestore.instance.collection('users').doc(_uid).collection(name);

  /// Pulls remote changes down, merges by last-write-wins, then pushes the
  /// resulting local state back up so both sides end up identical. Safe to
  /// call repeatedly (e.g. on sign-in, on app resume, after each local edit).
  Future<void> syncNow() async {
    await _syncStudyEntries();
    await _syncTags();
    await _syncNotes();
    await _syncTalksAndPoints();
    await _syncQuizHistory();
    await _syncStudyLogs();
  }

  // --- study entries ---------------------------------------------------

  Future<void> _syncStudyEntries() async {
    final local = await _db.select(_db.studyEntries).get();
    final remoteSnap = await _col('studyEntries').get();
    final remote = {for (final d in remoteSnap.docs) d.id: d.data()};

    final batch = FirebaseFirestore.instance.batch();
    final localById = {for (final e in local) e.id: e};
    final allIds = {...localById.keys, ...remote.keys};

    for (final id in allIds) {
      final l = localById[id];
      final r = remote[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        // Local wins (or is the only copy) — push it up.
        if (l != null) batch.set(_col('studyEntries').doc(id), _entryToMap(l));
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        // Remote wins — upsert locally.
        await _db.into(_db.studyEntries).insertOnConflictUpdate(_entryFromMap(id, r));
      }
    }
    await batch.commit();
  }

  Map<String, dynamic> _entryToMap(StudyEntry e) => {
        'bookId': e.bookId,
        'chapter': e.chapter,
        'verseStart': e.verseStart,
        'verseEnd': e.verseEnd,
        'language': e.language,
        'verseText': e.verseText,
        'createdAt': Timestamp.fromDate(e.createdAt),
        'updatedAt': Timestamp.fromDate(e.updatedAt),
        'isDeleted': e.isDeleted,
      };

  StudyEntriesCompanion _entryFromMap(String id, Map<String, dynamic> m) => StudyEntriesCompanion(
        id: Value(id),
        bookId: Value(m['bookId'] as int),
        chapter: Value(m['chapter'] as int),
        verseStart: Value(m['verseStart'] as int),
        verseEnd: Value(m['verseEnd'] as int),
        language: Value(m['language'] as String),
        verseText: Value(m['verseText'] as String?),
        createdAt: Value((m['createdAt'] as Timestamp).toDate()),
        updatedAt: Value((m['updatedAt'] as Timestamp).toDate()),
        isDeleted: Value(m['isDeleted'] as bool? ?? false),
      );

  // --- tags --------------------------------------------------------------

  Future<void> _syncTags() async {
    final local = await _db.select(_db.tags).get();
    final remoteSnap = await _col('tags').get();
    final remote = {for (final d in remoteSnap.docs) d.id: d.data()};

    final batch = FirebaseFirestore.instance.batch();
    final localById = {for (final t in local) t.id: t};
    final allIds = {...localById.keys, ...remote.keys};

    for (final id in allIds) {
      final l = localById[id];
      final r = remote[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        if (l != null) {
          batch.set(_col('tags').doc(id), {
            'name': l.name,
            'colorHex': l.colorHex,
            'updatedAt': Timestamp.fromDate(l.updatedAt),
            'isDeleted': l.isDeleted,
          });
        }
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        await _db.into(_db.tags).insertOnConflictUpdate(TagsCompanion(
              id: Value(id),
              name: Value(r['name'] as String),
              colorHex: Value(r['colorHex'] as String? ?? 'FF6750A4'),
              updatedAt: Value((r['updatedAt'] as Timestamp).toDate()),
              isDeleted: Value(r['isDeleted'] as bool? ?? false),
            ));
      }
    }
    await batch.commit();
  }

  // --- notes (tag membership folded in as a plain id array) ---------------

  Future<void> _syncNotes() async {
    final local = await _db.select(_db.studyNotes).get();
    final localLinks = await _db.select(_db.noteTagLinks).get();
    final tagsByNote = <String, List<String>>{};
    for (final link in localLinks) {
      (tagsByNote[link.noteId] ??= []).add(link.tagId);
    }

    final remoteSnap = await _col('notes').get();
    final remote = {for (final d in remoteSnap.docs) d.id: d.data()};

    final batch = FirebaseFirestore.instance.batch();
    final localById = {for (final n in local) n.id: n};
    final allIds = {...localById.keys, ...remote.keys};

    for (final id in allIds) {
      final l = localById[id];
      final r = remote[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        if (l != null) {
          batch.set(_col('notes').doc(id), {
            'noteText': l.noteText,
            'source': l.source,
            'studyEntryId': l.studyEntryId,
            'tagIds': tagsByNote[id] ?? const <String>[],
            'createdAt': Timestamp.fromDate(l.createdAt),
            'updatedAt': Timestamp.fromDate(l.updatedAt),
            'isDeleted': l.isDeleted,
          });
        }
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        await _db.into(_db.studyNotes).insertOnConflictUpdate(StudyNotesCompanion(
              id: Value(id),
              noteText: Value(r['noteText'] as String),
              source: Value(r['source'] as String),
              studyEntryId: Value(r['studyEntryId'] as String?),
              createdAt: Value((r['createdAt'] as Timestamp).toDate()),
              updatedAt: Value((r['updatedAt'] as Timestamp).toDate()),
              isDeleted: Value(r['isDeleted'] as bool? ?? false),
            ));
        // Remote is the source of truth for this note's tags right now —
        // rebuild the local link rows to match exactly.
        await (_db.delete(_db.noteTagLinks)..where((l) => l.noteId.equals(id))).go();
        final remoteTagIds = (r['tagIds'] as List<dynamic>? ?? const []).cast<String>();
        for (final tagId in remoteTagIds) {
          await _db.into(_db.noteTagLinks).insert(
                NoteTagLinksCompanion.insert(noteId: id, tagId: tagId),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }
    }
    await batch.commit();
  }

  // --- talks + outline points ---------------------------------------------

  Future<void> _syncTalksAndPoints() async {
    final localTalks = await _db.select(_db.talks).get();
    final remoteTalksSnap = await _col('talks').get();
    final remoteTalks = {for (final d in remoteTalksSnap.docs) d.id: d.data()};

    final talksBatch = FirebaseFirestore.instance.batch();
    final localTalkById = {for (final t in localTalks) t.id: t};
    final allTalkIds = {...localTalkById.keys, ...remoteTalks.keys};

    for (final id in allTalkIds) {
      final l = localTalkById[id];
      final r = remoteTalks[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        if (l != null) {
          talksBatch.set(_col('talks').doc(id), {
            'title': l.title,
            'speaker': l.speaker,
            'date': Timestamp.fromDate(l.date),
            'updatedAt': Timestamp.fromDate(l.updatedAt),
            'isDeleted': l.isDeleted,
          });
        }
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        await _db.into(_db.talks).insertOnConflictUpdate(TalksCompanion(
              id: Value(id),
              title: Value(r['title'] as String),
              speaker: Value(r['speaker'] as String?),
              date: Value((r['date'] as Timestamp).toDate()),
              updatedAt: Value((r['updatedAt'] as Timestamp).toDate()),
              isDeleted: Value(r['isDeleted'] as bool? ?? false),
            ));
      }
    }
    await talksBatch.commit();

    final localPoints = await _db.select(_db.talkPoints).get();
    final remotePointsSnap = await _col('talkPoints').get();
    final remotePoints = {for (final d in remotePointsSnap.docs) d.id: d.data()};

    final pointsBatch = FirebaseFirestore.instance.batch();
    final localPointById = {for (final p in localPoints) p.id: p};
    final allPointIds = {...localPointById.keys, ...remotePoints.keys};

    for (final id in allPointIds) {
      final l = localPointById[id];
      final r = remotePoints[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        if (l != null) {
          pointsBatch.set(_col('talkPoints').doc(id), {
            'talkId': l.talkId,
            'orderIndex': l.orderIndex,
            'pointText': l.pointText,
            'linkedStudyEntryId': l.linkedStudyEntryId,
            'updatedAt': Timestamp.fromDate(l.updatedAt),
            'isDeleted': l.isDeleted,
          });
        }
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        await _db.into(_db.talkPoints).insertOnConflictUpdate(TalkPointsCompanion(
              id: Value(id),
              talkId: Value(r['talkId'] as String),
              orderIndex: Value(r['orderIndex'] as int),
              pointText: Value(r['pointText'] as String),
              linkedStudyEntryId: Value(r['linkedStudyEntryId'] as String?),
              updatedAt: Value((r['updatedAt'] as Timestamp).toDate()),
              isDeleted: Value(r['isDeleted'] as bool? ?? false),
            ));
      }
    }
    await pointsBatch.commit();
  }

  // --- "other study" check-ins (count toward the streak on every device) --

  Future<void> _syncStudyLogs() async {
    final local = await _db.select(_db.studyLogs).get();
    final remoteSnap = await _col('studyLogs').get();
    final remote = {for (final d in remoteSnap.docs) d.id: d.data()};

    final batch = FirebaseFirestore.instance.batch();
    final localById = {for (final l in local) l.id: l};
    final allIds = {...localById.keys, ...remote.keys};

    for (final id in allIds) {
      final l = localById[id];
      final r = remote[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        if (l != null) {
          batch.set(_col('studyLogs').doc(id), {
            'kind': l.kind,
            'note': l.note,
            'createdAt': Timestamp.fromDate(l.createdAt),
            'updatedAt': Timestamp.fromDate(l.updatedAt),
            'isDeleted': l.isDeleted,
          });
        }
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        await _db.into(_db.studyLogs).insertOnConflictUpdate(StudyLogsCompanion(
              id: Value(id),
              kind: Value(r['kind'] as String),
              note: Value(r['note'] as String?),
              createdAt: Value((r['createdAt'] as Timestamp).toDate()),
              updatedAt: Value((r['updatedAt'] as Timestamp).toDate()),
              isDeleted: Value(r['isDeleted'] as bool? ?? false),
            ));
      }
    }
    await batch.commit();
  }

  // --- quiz history (push-mostly: your own record of what you've done) ----

  Future<void> _syncQuizHistory() async {
    final localSessions = await _db.select(_db.quizSessions).get();
    final remoteSessionsSnap = await _col('quizSessions').get();
    final remoteSessions = {for (final d in remoteSessionsSnap.docs) d.id: d.data()};

    final sessionsBatch = FirebaseFirestore.instance.batch();
    final localSessionById = {for (final s in localSessions) s.id: s};
    final allSessionIds = {...localSessionById.keys, ...remoteSessions.keys};

    for (final id in allSessionIds) {
      final l = localSessionById[id];
      final r = remoteSessions[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        if (l != null) {
          sessionsBatch.set(_col('quizSessions').doc(id), {
            'scopeType': l.scopeType,
            'scopeRefJson': l.scopeRefJson,
            'quizType': l.quizType,
            'startedAt': Timestamp.fromDate(l.startedAt),
            'finishedAt': l.finishedAt == null ? null : Timestamp.fromDate(l.finishedAt!),
            'score': l.score,
            'totalQuestions': l.totalQuestions,
            'updatedAt': Timestamp.fromDate(l.updatedAt),
          });
        }
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        final finishedAtTs = r['finishedAt'] as Timestamp?;
        await _db.into(_db.quizSessions).insertOnConflictUpdate(QuizSessionsCompanion(
              id: Value(id),
              scopeType: Value(r['scopeType'] as String),
              scopeRefJson: Value(r['scopeRefJson'] as String),
              quizType: Value(r['quizType'] as String),
              startedAt: Value((r['startedAt'] as Timestamp).toDate()),
              finishedAt: Value(finishedAtTs?.toDate()),
              score: Value(r['score'] as int? ?? 0),
              totalQuestions: Value(r['totalQuestions'] as int? ?? 0),
              updatedAt: Value((r['updatedAt'] as Timestamp).toDate()),
            ));
      }
    }
    await sessionsBatch.commit();

    final localAttempts = await _db.select(_db.quizAttempts).get();
    final remoteAttemptsSnap = await _col('quizAttempts').get();
    final remoteAttempts = {for (final d in remoteAttemptsSnap.docs) d.id: d.data()};

    final attemptsBatch = FirebaseFirestore.instance.batch();
    final localAttemptById = {for (final a in localAttempts) a.id: a};
    final allAttemptIds = {...localAttemptById.keys, ...remoteAttempts.keys};

    for (final id in allAttemptIds) {
      final l = localAttemptById[id];
      final r = remoteAttempts[id];
      final localTime = l?.updatedAt;
      final remoteTime = (r?['updatedAt'] as Timestamp?)?.toDate();

      if (r == null || (localTime != null && (remoteTime == null || localTime.isAfter(remoteTime)))) {
        if (l != null) {
          attemptsBatch.set(_col('quizAttempts').doc(id), {
            'sessionId': l.sessionId,
            'promptText': l.promptText,
            'correctAnswer': l.correctAnswer,
            'userAnswer': l.userAnswer,
            'isCorrect': l.isCorrect,
            'updatedAt': Timestamp.fromDate(l.updatedAt),
          });
        }
      } else if (l == null || (remoteTime != null && remoteTime.isAfter(localTime!))) {
        await _db.into(_db.quizAttempts).insertOnConflictUpdate(QuizAttemptsCompanion(
              id: Value(id),
              sessionId: Value(r['sessionId'] as String),
              promptText: Value(r['promptText'] as String),
              correctAnswer: Value(r['correctAnswer'] as String),
              userAnswer: Value(r['userAnswer'] as String?),
              isCorrect: Value(r['isCorrect'] as bool? ?? false),
              updatedAt: Value((r['updatedAt'] as Timestamp).toDate()),
            ));
      }
    }
    await attemptsBatch.commit();
  }
}
