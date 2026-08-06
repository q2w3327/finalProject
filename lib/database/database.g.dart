// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TeamDao? _teamDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Team` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `homeStadium` TEXT NOT NULL, `city` TEXT NOT NULL, `pictureUrl` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TeamDao get teamDao {
    return _teamDaoInstance ??= _$TeamDao(database, changeListener);
  }
}

class _$TeamDao extends TeamDao {
  _$TeamDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _teamInsertionAdapter = InsertionAdapter(
            database,
            'Team',
            (Team item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'homeStadium': item.homeStadium,
                  'city': item.city,
                  'pictureUrl': item.pictureUrl
                }),
        _teamUpdateAdapter = UpdateAdapter(
            database,
            'Team',
            ['id'],
            (Team item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'homeStadium': item.homeStadium,
                  'city': item.city,
                  'pictureUrl': item.pictureUrl
                }),
        _teamDeletionAdapter = DeletionAdapter(
            database,
            'Team',
            ['id'],
            (Team item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'homeStadium': item.homeStadium,
                  'city': item.city,
                  'pictureUrl': item.pictureUrl
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Team> _teamInsertionAdapter;

  final UpdateAdapter<Team> _teamUpdateAdapter;

  final DeletionAdapter<Team> _teamDeletionAdapter;

  @override
  Future<List<Team>> findAllTeams() async {
    return _queryAdapter.queryList('SELECT * FROM Team',
        mapper: (Map<String, Object?> row) => Team(
            id: row['id'] as int?,
            name: row['name'] as String,
            homeStadium: row['homeStadium'] as String,
            city: row['city'] as String,
            pictureUrl: row['pictureUrl'] as String));
  }

  @override
  Future<Team?> findTeamById(int id) async {
    return _queryAdapter.query('SELECT * FROM Team WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Team(
            id: row['id'] as int?,
            name: row['name'] as String,
            homeStadium: row['homeStadium'] as String,
            city: row['city'] as String,
            pictureUrl: row['pictureUrl'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertTeam(Team team) async {
    await _teamInsertionAdapter.insert(team, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTeam(Team team) async {
    await _teamUpdateAdapter.update(team, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTeam(Team team) async {
    await _teamDeletionAdapter.delete(team);
  }
}
