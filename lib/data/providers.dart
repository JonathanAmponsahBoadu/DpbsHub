import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../core/notifications/notification_service.dart';
import 'assets_source/bible_structure.dart';
import 'local/database.dart';
import 'repositories/bible_repository.dart';
import 'repositories/notes_repository.dart';
import 'repositories/quiz_repository.dart';
import 'repositories/reminders_repository.dart';
import 'repositories/talks_repository.dart';

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

final talksRepositoryProvider =
    Provider((ref) => TalksRepository(ref.watch(databaseProvider)));

final quizRepositoryProvider =
    Provider((ref) => QuizRepository(ref.watch(databaseProvider)));

final remindersRepositoryProvider =
    Provider((ref) => RemindersRepository(ref.watch(databaseProvider)));

/// Seeds default reminder settings, requests notification permissions, and
/// (re)schedules every enabled day. Fire-and-forget from the app shell — it
/// shouldn't block the splash screen behind a permission dialog.
final reminderSetupProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(remindersRepositoryProvider);
  await repo.seedIfEmpty();
  await NotificationService.instance.init();
  await NotificationService.instance.requestPermissions();
  await repo.rescheduleAll();
});

/// 'en' or 'tw' — the language you're currently studying/adding entries in.
final studyLanguageProvider = StateProvider<String>((ref) => 'en');

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
