import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get gameId => text()();
  TextColumn get category => text()();
  IntColumn get level => integer()();
  IntColumn get score => integer()();
  RealColumn get performance => real()();
  IntColumn get durationMs => integer()();
  DateTimeColumn get playedAt => dateTime().withDefault(currentDateAndTime)();
}

class GameLevels extends Table {
  TextColumn get gameId => text()();
  IntColumn get level => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {gameId};
}

@DriftDatabase(tables: [Sessions, GameLevels])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'brain_trainer'));

  @override
  int get schemaVersion => 1;

  Future<int> levelFor(String gameId) async {
    final row = await (select(gameLevels)
          ..where((t) => t.gameId.equals(gameId)))
        .getSingleOrNull();
    return row?.level ?? 1;
  }

  Future<void> setLevel(String gameId, int level) {
    return into(gameLevels).insertOnConflictUpdate(
      GameLevelsCompanion(gameId: Value(gameId), level: Value(level)),
    );
  }

  Future<void> addSession({
    required String gameId,
    required String category,
    required int level,
    required int score,
    required double performance,
    required int durationMs,
  }) {
    return into(sessions).insert(
      SessionsCompanion.insert(
        gameId: gameId,
        category: category,
        level: level,
        score: score,
        performance: performance,
        durationMs: durationMs,
      ),
    );
  }

  Future<int?> bestScore(String gameId) {
    final best = sessions.score.max();
    final query = selectOnly(sessions)
      ..addColumns([best])
      ..where(sessions.gameId.equals(gameId));
    return query.map((row) => row.read(best)).getSingle();
  }
}
