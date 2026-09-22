import 'package:drift/drift.dart';

/// One completed (or in-progress) quiz run. [scopeType]/[scopeRefJson] describe
/// what you were quizzed on (a book, a set of chapters, a tag, a talk, ...) so
/// history and stats screens can group by scope later.
class QuizSessions extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get scopeType => text()(); // book|books|chapter|chapters|verseRange|tag|talk
  TextColumn get scopeRefJson => text()(); // e.g. {"bookIds":[43]} or {"tagId":"..."}
  TextColumn get quizType =>
      text()(); // referenceRecall|textRecall|talkRecall|lesson|trivia
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();
  IntColumn get score => integer().withDefault(const Constant(0))();
  IntColumn get totalQuestions => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

class QuizAttempts extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get sessionId => text().references(QuizSessions, #id)();
  TextColumn get promptText => text()();
  TextColumn get correctAnswer => text()();
  TextColumn get userAnswer => text().nullable()();
  BoolColumn get isCorrect => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}
