import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class TalkWithPoints {
  TalkWithPoints(this.talk, this.points);
  final Talk talk;
  final List<TalkPoint> points;
}

class TalksRepository {
  TalksRepository(this._db);
  final AppDatabase _db;
  static const _uuid = Uuid();

  Stream<List<Talk>> watchTalks() =>
      (_db.select(_db.talks)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Stream<List<TalkPoint>> watchPoints(String talkId) => (_db.select(_db.talkPoints)
        ..where((p) => p.talkId.equals(talkId))
        ..orderBy([(p) => OrderingTerm.asc(p.orderIndex)]))
      .watch();

  Future<Talk> createTalk({
    required String title,
    String? speaker,
    required DateTime date,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.talks).insert(TalksCompanion.insert(
          id: id,
          title: title,
          speaker: Value(speaker),
          date: date,
        ));
    return (_db.select(_db.talks)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> addPoint({
    required String talkId,
    required String pointText,
    String? linkedStudyEntryId,
  }) async {
    final existing = await (_db.select(_db.talkPoints)
          ..where((p) => p.talkId.equals(talkId)))
        .get();
    await _db.into(_db.talkPoints).insert(TalkPointsCompanion.insert(
          id: _uuid.v4(),
          talkId: talkId,
          orderIndex: existing.length,
          pointText: pointText,
          linkedStudyEntryId: Value(linkedStudyEntryId),
        ));
  }

  Future<void> deleteTalk(String id) =>
      (_db.delete(_db.talks)..where((t) => t.id.equals(id))).go();
}
