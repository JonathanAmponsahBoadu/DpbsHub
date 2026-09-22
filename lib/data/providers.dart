import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/ai/ai_service.dart';
import '../core/auth/auth_service.dart';
import '../core/notifications/inactivity_nudge_service.dart';
import '../core/notifications/notification_service.dart';
import '../core/security/api_key_vault.dart';
import 'assets_source/bible_structure.dart';
import 'local/database.dart';
import 'repositories/attachments_repository.dart';
import 'repositories/bible_repository.dart';
import 'repositories/notes_repository.dart';
import 'repositories/quiz_repository.dart';
import 'repositories/reminders_repository.dart';
import 'repositories/study_log_repository.dart';
import 'repositories/talks_repository.dart';
import 'services/study_activity_service.dart';
import 'sync/sync_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Seeds the Bible skeleton on first run; the app shell awaits this once.
final bibleSeedProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(databaseProvider);
  await BibleStructureSeeder(db).seedIfEmpty();
});

final bibleRepositoryProvider =
    Provider((ref) => BibleRepository(ref.watch(databaseProvider)));

final notesRepositoryProvider =
    Provider((ref) => NotesRepository(ref.watch(databaseProvider)));

final attachmentsRepositoryProvider =
    Provider((ref) => AttachmentsRepository(ref.watch(databaseProvider)));

final talksRepositoryProvider =
    Provider((ref) => TalksRepository(ref.watch(databaseProvider)));

final quizRepositoryProvider = Provider(
  (ref) => QuizRepository(ref.watch(databaseProvider), ref.watch(aiServiceProvider)),
);

final remindersRepositoryProvider =
    Provider((ref) => RemindersRepository(ref.watch(databaseProvider)));

final studyLogRepositoryProvider =
    Provider((ref) => StudyLogRepository(ref.watch(databaseProvider)));

final inactivityNudgeServiceProvider = Provider((ref) => InactivityNudgeService.instance);

/// Reacts to "you studied" and to app startup: recomputes your streak,
/// refreshes the home-screen widget, and rebuilds every reminder/nudge.
final studyActivityServiceProvider = Provider(
  (ref) => StudyActivityService(
    ref.watch(databaseProvider),
    ref.watch(remindersRepositoryProvider),
  ),
);

/// Seeds default reminder settings, requests notification permissions, then
/// builds the whole reminder/nudge/widget state from your real activity.
/// Fire-and-forget from the app shell — it shouldn't block the splash
/// screen behind a permission dialog.
final reminderSetupProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(remindersRepositoryProvider);
  await repo.seedIfEmpty();
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();
  await ref.read(studyActivityServiceProvider).refreshAll();
});

final apiKeyVaultProvider = Provider((ref) => ApiKeyVault.instance);

final aiServiceProvider = Provider((ref) => AiService(ref.watch(apiKeyVaultProvider)));

final authServiceProvider = Provider((ref) => AuthService.instance);

/// Returns a zero-arg function that runs one full sync pass for whoever's
/// currently signed in. Throws if nobody is signed in — callers only ever
/// invoke this from UI that's already gated on being signed in.
final syncNowProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) {
      throw StateError('Sign in before syncing.');
    }
    final sync = SyncService(ref.read(databaseProvider), user.uid);
    await sync.syncNow();
  };
});

/// 'en' or 'tw' — the language you're currently studying/adding entries in.
final studyLanguageProvider = StateProvider<String>((ref) => 'en');

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
