import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/team_dao.dart';
import '../models/team.dart';
import '../dao/player_dao.dart';
import '../models/player.dart';
import '../dao/game_dao.dart';
import '../models/game.dart';

part 'database.g.dart'; // the generated code will be here

/// The application's database.
/// 
/// Contains the [TeamDao], [PlayerDao], and [GameDao].
@Database(version: 2, entities: [Team, Player, Game])
abstract class AppDatabase extends FloorDatabase {
  /// Provides access to the [TeamDao].
  TeamDao get teamDao;
  /// Provides access to the [PlayerDao].
  PlayerDao get playerDao;
  /// Provides access to the [GameDao].
  GameDao get gameDao;

  static AppDatabase? _instance;

  /// Singleton access to the database to prevent multiple opening attempts.
  static Future<AppDatabase> getDatabase() async {
    _instance ??= await $FloorAppDatabase.databaseBuilder('app_database_v2.db').build();
    return _instance!;
  }
}
