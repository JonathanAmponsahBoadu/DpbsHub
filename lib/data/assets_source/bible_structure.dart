import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../local/database.dart';

/// Loads the bundled Bible skeleton (book names, chapter counts, jw.org slugs —
/// no verse text) and upserts it into the [Books] table on every launch.
/// Deliberately a refresh, not a one-time seed: this data (especially the
/// best-effort Twi names/slugs) gets corrected over time, and re-running it
/// is how those fixes reach an already-installed app without wiping your
/// study data — it only ever touches the reference Books table.
class BibleStructureSeeder {
  BibleStructureSeeder(this._db);

  final AppDatabase _db;

  Future<void> seedIfEmpty() async {
    final enJson = jsonDecode(
      await rootBundle.loadString('assets/bible/en_books.json'),
    ) as List<dynamic>;
    final twJson = jsonDecode(
      await rootBundle.loadString('assets/bible/tw_books.json'),
    ) as List<dynamic>;

    final twById = {
      for (final b in twJson) (b as Map<String, dynamic>)['id'] as int: b,
    };

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.books,
        enJson.map((raw) {
          final en = raw as Map<String, dynamic>;
          final tw = twById[en['id'] as int] ?? const <String, dynamic>{};
          return BooksCompanion.insert(
            id: Value(en['id'] as int),
            nameEn: en['name'] as String,
            nameTw: (tw['name'] as String?) ?? en['name'] as String,
            abbrEn: Value((en['abbr'] as String?) ?? en['name'] as String),
            abbrTw: Value((tw['abbr'] as String?) ?? (tw['name'] as String?) ?? en['name'] as String),
            testament: en['testament'] as String,
            chapterCount: en['chapterCount'] as int,
            slugEn: en['slug'] as String,
            slugTw: (tw['slug'] as String?) ?? '',
            slugEnVerified: Value((en['slugVerified'] as bool?) ?? false),
            slugTwVerified: Value((tw['slugVerified'] as bool?) ?? false),
          );
        }),
      );
    });
  }
}
