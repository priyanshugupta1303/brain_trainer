// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _performanceMeta =
      const VerificationMeta('performance');
  @override
  late final GeneratedColumn<double> performance = GeneratedColumn<double>(
      'performance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _durationMsMeta =
      const VerificationMeta('durationMs');
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
      'duration_ms', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _playedAtMeta =
      const VerificationMeta('playedAt');
  @override
  late final GeneratedColumn<DateTime> playedAt = GeneratedColumn<DateTime>(
      'played_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, gameId, category, level, score, performance, durationMs, playedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('performance')) {
      context.handle(
          _performanceMeta,
          performance.isAcceptableOrUnknown(
              data['performance']!, _performanceMeta));
    } else if (isInserting) {
      context.missing(_performanceMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
          _durationMsMeta,
          durationMs.isAcceptableOrUnknown(
              data['duration_ms']!, _durationMsMeta));
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('played_at')) {
      context.handle(_playedAtMeta,
          playedAt.isAcceptableOrUnknown(data['played_at']!, _playedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
      performance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}performance'])!,
      durationMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_ms'])!,
      playedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}played_at'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final String gameId;
  final String category;
  final int level;
  final int score;
  final double performance;
  final int durationMs;
  final DateTime playedAt;
  const Session(
      {required this.id,
      required this.gameId,
      required this.category,
      required this.level,
      required this.score,
      required this.performance,
      required this.durationMs,
      required this.playedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game_id'] = Variable<String>(gameId);
    map['category'] = Variable<String>(category);
    map['level'] = Variable<int>(level);
    map['score'] = Variable<int>(score);
    map['performance'] = Variable<double>(performance);
    map['duration_ms'] = Variable<int>(durationMs);
    map['played_at'] = Variable<DateTime>(playedAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      gameId: Value(gameId),
      category: Value(category),
      level: Value(level),
      score: Value(score),
      performance: Value(performance),
      durationMs: Value(durationMs),
      playedAt: Value(playedAt),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      gameId: serializer.fromJson<String>(json['gameId']),
      category: serializer.fromJson<String>(json['category']),
      level: serializer.fromJson<int>(json['level']),
      score: serializer.fromJson<int>(json['score']),
      performance: serializer.fromJson<double>(json['performance']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      playedAt: serializer.fromJson<DateTime>(json['playedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gameId': serializer.toJson<String>(gameId),
      'category': serializer.toJson<String>(category),
      'level': serializer.toJson<int>(level),
      'score': serializer.toJson<int>(score),
      'performance': serializer.toJson<double>(performance),
      'durationMs': serializer.toJson<int>(durationMs),
      'playedAt': serializer.toJson<DateTime>(playedAt),
    };
  }

  Session copyWith(
          {int? id,
          String? gameId,
          String? category,
          int? level,
          int? score,
          double? performance,
          int? durationMs,
          DateTime? playedAt}) =>
      Session(
        id: id ?? this.id,
        gameId: gameId ?? this.gameId,
        category: category ?? this.category,
        level: level ?? this.level,
        score: score ?? this.score,
        performance: performance ?? this.performance,
        durationMs: durationMs ?? this.durationMs,
        playedAt: playedAt ?? this.playedAt,
      );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      category: data.category.present ? data.category.value : this.category,
      level: data.level.present ? data.level.value : this.level,
      score: data.score.present ? data.score.value : this.score,
      performance:
          data.performance.present ? data.performance.value : this.performance,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
      playedAt: data.playedAt.present ? data.playedAt.value : this.playedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('category: $category, ')
          ..write('level: $level, ')
          ..write('score: $score, ')
          ..write('performance: $performance, ')
          ..write('durationMs: $durationMs, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, gameId, category, level, score, performance, durationMs, playedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.gameId == this.gameId &&
          other.category == this.category &&
          other.level == this.level &&
          other.score == this.score &&
          other.performance == this.performance &&
          other.durationMs == this.durationMs &&
          other.playedAt == this.playedAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<String> gameId;
  final Value<String> category;
  final Value<int> level;
  final Value<int> score;
  final Value<double> performance;
  final Value<int> durationMs;
  final Value<DateTime> playedAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.gameId = const Value.absent(),
    this.category = const Value.absent(),
    this.level = const Value.absent(),
    this.score = const Value.absent(),
    this.performance = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.playedAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required String gameId,
    required String category,
    required int level,
    required int score,
    required double performance,
    required int durationMs,
    this.playedAt = const Value.absent(),
  })  : gameId = Value(gameId),
        category = Value(category),
        level = Value(level),
        score = Value(score),
        performance = Value(performance),
        durationMs = Value(durationMs);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? gameId,
    Expression<String>? category,
    Expression<int>? level,
    Expression<int>? score,
    Expression<double>? performance,
    Expression<int>? durationMs,
    Expression<DateTime>? playedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gameId != null) 'game_id': gameId,
      if (category != null) 'category': category,
      if (level != null) 'level': level,
      if (score != null) 'score': score,
      if (performance != null) 'performance': performance,
      if (durationMs != null) 'duration_ms': durationMs,
      if (playedAt != null) 'played_at': playedAt,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? gameId,
      Value<String>? category,
      Value<int>? level,
      Value<int>? score,
      Value<double>? performance,
      Value<int>? durationMs,
      Value<DateTime>? playedAt}) {
    return SessionsCompanion(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      category: category ?? this.category,
      level: level ?? this.level,
      score: score ?? this.score,
      performance: performance ?? this.performance,
      durationMs: durationMs ?? this.durationMs,
      playedAt: playedAt ?? this.playedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (performance.present) {
      map['performance'] = Variable<double>(performance.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (playedAt.present) {
      map['played_at'] = Variable<DateTime>(playedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('gameId: $gameId, ')
          ..write('category: $category, ')
          ..write('level: $level, ')
          ..write('score: $score, ')
          ..write('performance: $performance, ')
          ..write('durationMs: $durationMs, ')
          ..write('playedAt: $playedAt')
          ..write(')'))
        .toString();
  }
}

class $GameLevelsTable extends GameLevels
    with TableInfo<$GameLevelsTable, GameLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
      'game_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
      'level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [gameId, level];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_levels';
  @override
  VerificationContext validateIntegrity(Insertable<GameLevel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(_gameIdMeta,
          gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta));
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
          _levelMeta, level.isAcceptableOrUnknown(data['level']!, _levelMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId};
  @override
  GameLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameLevel(
      gameId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}game_id'])!,
      level: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!,
    );
  }

  @override
  $GameLevelsTable createAlias(String alias) {
    return $GameLevelsTable(attachedDatabase, alias);
  }
}

class GameLevel extends DataClass implements Insertable<GameLevel> {
  final String gameId;
  final int level;
  const GameLevel({required this.gameId, required this.level});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<String>(gameId);
    map['level'] = Variable<int>(level);
    return map;
  }

  GameLevelsCompanion toCompanion(bool nullToAbsent) {
    return GameLevelsCompanion(
      gameId: Value(gameId),
      level: Value(level),
    );
  }

  factory GameLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameLevel(
      gameId: serializer.fromJson<String>(json['gameId']),
      level: serializer.fromJson<int>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<String>(gameId),
      'level': serializer.toJson<int>(level),
    };
  }

  GameLevel copyWith({String? gameId, int? level}) => GameLevel(
        gameId: gameId ?? this.gameId,
        level: level ?? this.level,
      );
  GameLevel copyWithCompanion(GameLevelsCompanion data) {
    return GameLevel(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameLevel(')
          ..write('gameId: $gameId, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameLevel &&
          other.gameId == this.gameId &&
          other.level == this.level);
}

class GameLevelsCompanion extends UpdateCompanion<GameLevel> {
  final Value<String> gameId;
  final Value<int> level;
  final Value<int> rowid;
  const GameLevelsCompanion({
    this.gameId = const Value.absent(),
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameLevelsCompanion.insert({
    required String gameId,
    this.level = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId);
  static Insertable<GameLevel> custom({
    Expression<String>? gameId,
    Expression<int>? level,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (level != null) 'level': level,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameLevelsCompanion copyWith(
      {Value<String>? gameId, Value<int>? level, Value<int>? rowid}) {
    return GameLevelsCompanion(
      gameId: gameId ?? this.gameId,
      level: level ?? this.level,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameLevelsCompanion(')
          ..write('gameId: $gameId, ')
          ..write('level: $level, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $GameLevelsTable gameLevels = $GameLevelsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sessions, gameLevels];
}

typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  required String gameId,
  required String category,
  required int level,
  required int score,
  required double performance,
  required int durationMs,
  Value<DateTime> playedAt,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<String> gameId,
  Value<String> category,
  Value<int> level,
  Value<int> score,
  Value<double> performance,
  Value<int> durationMs,
  Value<DateTime> playedAt,
});

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get performance => $composableBuilder(
      column: $table.performance, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnFilters(column));
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get score => $composableBuilder(
      column: $table.score, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get performance => $composableBuilder(
      column: $table.performance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get playedAt => $composableBuilder(
      column: $table.playedAt, builder: (column) => ColumnOrderings(column));
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<double> get performance => $composableBuilder(
      column: $table.performance, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
      column: $table.durationMs, builder: (column) => column);

  GeneratedColumn<DateTime> get playedAt =>
      $composableBuilder(column: $table.playedAt, builder: (column) => column);
}

class $$SessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()> {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> gameId = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> score = const Value.absent(),
            Value<double> performance = const Value.absent(),
            Value<int> durationMs = const Value.absent(),
            Value<DateTime> playedAt = const Value.absent(),
          }) =>
              SessionsCompanion(
            id: id,
            gameId: gameId,
            category: category,
            level: level,
            score: score,
            performance: performance,
            durationMs: durationMs,
            playedAt: playedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String gameId,
            required String category,
            required int level,
            required int score,
            required double performance,
            required int durationMs,
            Value<DateTime> playedAt = const Value.absent(),
          }) =>
              SessionsCompanion.insert(
            id: id,
            gameId: gameId,
            category: category,
            level: level,
            score: score,
            performance: performance,
            durationMs: durationMs,
            playedAt: playedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SessionsTable, Session>(table),
                    BaseReferences<_$AppDatabase, $SessionsTable, Session>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionsTable,
    Session,
    $$SessionsTableFilterComposer,
    $$SessionsTableOrderingComposer,
    $$SessionsTableAnnotationComposer,
    $$SessionsTableCreateCompanionBuilder,
    $$SessionsTableUpdateCompanionBuilder,
    (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
    Session,
    PrefetchHooks Function()>;
typedef $$GameLevelsTableCreateCompanionBuilder = GameLevelsCompanion Function({
  required String gameId,
  Value<int> level,
  Value<int> rowid,
});
typedef $$GameLevelsTableUpdateCompanionBuilder = GameLevelsCompanion Function({
  Value<String> gameId,
  Value<int> level,
  Value<int> rowid,
});

class $$GameLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $GameLevelsTable> {
  $$GameLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnFilters(column));
}

class $$GameLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameLevelsTable> {
  $$GameLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
      column: $table.gameId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get level => $composableBuilder(
      column: $table.level, builder: (column) => ColumnOrderings(column));
}

class $$GameLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameLevelsTable> {
  $$GameLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);
}

class $$GameLevelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GameLevelsTable,
    GameLevel,
    $$GameLevelsTableFilterComposer,
    $$GameLevelsTableOrderingComposer,
    $$GameLevelsTableAnnotationComposer,
    $$GameLevelsTableCreateCompanionBuilder,
    $$GameLevelsTableUpdateCompanionBuilder,
    (GameLevel, BaseReferences<_$AppDatabase, $GameLevelsTable, GameLevel>),
    GameLevel,
    PrefetchHooks Function()> {
  $$GameLevelsTableTableManager(_$AppDatabase db, $GameLevelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> gameId = const Value.absent(),
            Value<int> level = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GameLevelsCompanion(
            gameId: gameId,
            level: level,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String gameId,
            Value<int> level = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GameLevelsCompanion.insert(
            gameId: gameId,
            level: level,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$GameLevelsTable, GameLevel>(table),
                    BaseReferences<_$AppDatabase, $GameLevelsTable, GameLevel>(
                        db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GameLevelsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GameLevelsTable,
    GameLevel,
    $$GameLevelsTableFilterComposer,
    $$GameLevelsTableOrderingComposer,
    $$GameLevelsTableAnnotationComposer,
    $$GameLevelsTableCreateCompanionBuilder,
    $$GameLevelsTableUpdateCompanionBuilder,
    (GameLevel, BaseReferences<_$AppDatabase, $GameLevelsTable, GameLevel>),
    GameLevel,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$GameLevelsTableTableManager get gameLevels =>
      $$GameLevelsTableTableManager(_db, _db.gameLevels);
}
