import 'package:drift/drift.dart';

/// Structural skeleton of the 66 Bible books — seeded once at first launch from
/// assets/bible/{en,tw}_books.json. Holds NO verse text (that would require
/// bundling/redistributing NWT copyrighted content, which we deliberately avoid).
///
/// [slugEnVerified] / [slugTwVerified] mark whether the jw.org URL slug for this
/// book was confirmed against the live site; unverified ones fall back to the
/// book-index page in the link builder (see core/constants/bible_urls.dart).
class Books extends Table {
  IntColumn get id => integer()(); // canonical 1-66 Bible book order
  TextColumn get nameEn => text()();
  TextColumn get nameTw => text()();
  TextColumn get abbrEn => text().withDefault(const Constant(''))();
  TextColumn get abbrTw => text().withDefault(const Constant(''))();
  TextColumn get testament => text()(); // 'hebrew' | 'greek'
  IntColumn get chapterCount => integer()();
  TextColumn get slugEn => text()();
  TextColumn get slugTw => text()();
  BoolColumn get slugEnVerified => boolean().withDefault(const Constant(false))();
  BoolColumn get slugTwVerified => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
