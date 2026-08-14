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

  PlayerDao? _playerDaoInstance;

  GameDao? _gameDaoInstance;

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
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Player` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `address` TEXT NOT NULL, `dateOfBirth` TEXT NOT NULL, `teamId` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Game` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` TEXT NOT NULL, `stadiumId` INTEGER NOT NULL, `team1Id` INTEGER NOT NULL, `team2Id` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TeamDao get teamDao {
    return _teamDaoInstance ??= _$TeamDao(database, changeListener);
  }

  @override
  PlayerDao get playerDao {
    return _playerDaoInstance ??= _$PlayerDao(database, changeListener);
  }

  @override
  GameDao get gameDao {
    return _gameDaoInstance ??= _$GameDao(database, changeListener);
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

class _$PlayerDao extends PlayerDao {
  _$PlayerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _playerInsertionAdapter = InsertionAdapter(
            database,
            'Player',
            (Player item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'dateOfBirth': item.dateOfBirth,
                  'teamId': item.teamId
                }),
        _playerUpdateAdapter = UpdateAdapter(
            database,
            'Player',
            ['id'],
            (Player item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'dateOfBirth': item.dateOfBirth,
                  'teamId': item.teamId
                }),
        _playerDeletionAdapter = DeletionAdapter(
            database,
            'Player',
            ['id'],
            (Player item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'address': item.address,
                  'dateOfBirth': item.dateOfBirth,
                  'teamId': item.teamId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Player> _playerInsertionAdapter;

  final UpdateAdapter<Player> _playerUpdateAdapter;

  final DeletionAdapter<Player> _playerDeletionAdapter;

  @override
  Future<List<Player>> findAllPlayers() async {
    return _queryAdapter.queryList('SELECT * FROM Player',
        mapper: (Map<String, Object?> row) => Player(
            id: row['id'] as int?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            dateOfBirth: row['dateOfBirth'] as String,
            teamId: row['teamId'] as int));
  }

  @override
  Future<Player?> findPlayerById(int id) async {
    return _queryAdapter.query('SELECT * FROM Player WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Player(
            id: row['id'] as int?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            address: row['address'] as String,
            dateOfBirth: row['dateOfBirth'] as String,
            teamId: row['teamId'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertPlayer(Player player) async {
    await _playerInsertionAdapter.insert(player, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePlayer(Player player) async {
    await _playerUpdateAdapter.update(player, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePlayer(Player player) async {
    await _playerDeletionAdapter.delete(player);
  }
}

class _$GameDao extends GameDao {
  _$GameDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _gameInsertionAdapter = InsertionAdapter(
            database,
            'Game',
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'stadiumId': item.stadiumId,
                  'team1Id': item.team1Id,
                  'team2Id': item.team2Id
                }),
        _gameUpdateAdapter = UpdateAdapter(
            database,
            'Game',
            ['id'],
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'stadiumId': item.stadiumId,
                  'team1Id': item.team1Id,
                  'team2Id': item.team2Id
                }),
        _gameDeletionAdapter = DeletionAdapter(
            database,
            'Game',
            ['id'],
            (Game item) => <String, Object?>{
                  'id': item.id,
                  'date': item.date,
                  'stadiumId': item.stadiumId,
                  'team1Id': item.team1Id,
                  'team2Id': item.team2Id
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Game> _gameInsertionAdapter;

  final UpdateAdapter<Game> _gameUpdateAdapter;

  final DeletionAdapter<Game> _gameDeletionAdapter;

  @override
  Future<List<Game>> findAllGames() async {
    return _queryAdapter.queryList('SELECT * FROM Game',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int?,
            date: row['date'] as String,
            stadiumId: row['stadiumId'] as int,
            team1Id: row['team1Id'] as int,
            team2Id: row['team2Id'] as int));
  }

  @override
  Future<Game?> findGameById(int id) async {
    return _queryAdapter.query('SELECT * FROM Game WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Game(
            id: row['id'] as int?,
            date: row['date'] as String,
            stadiumId: row['stadiumId'] as int,
            team1Id: row['team1Id'] as int,
            team2Id: row['team2Id'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertGame(Game game) async {
    await _gameInsertionAdapter.insert(game, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateGame(Game game) async {
    await _gameUpdateAdapter.update(game, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGame(Game game) async {
    await _gameDeletionAdapter.delete(game);
  }
}
