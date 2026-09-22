import 'package:drift/drift.dart';

class Tags extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get colorHex => text().withDefault(const Constant('FF6750A4'))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
