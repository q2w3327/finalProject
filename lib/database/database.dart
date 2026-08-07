import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/team_dao.dart';
import '../models/team.dart';
import '../dao/player_dao.dart';
import '../models/player.dart';

part 'database.g.dart'; // the generated code will be here

/// The application's database.
/// 
/// Contains the [TeamDao] to manage soccer team data.
@Database(version: 1, entities: [Team, Player])
abstract class AppDatabase extends FloorDatabase {
  /// Provides access to the [TeamDao].
  TeamDao get teamDao;
  /// Provides access to the [PlayerDao].
  PlayerDao get playerDao;
}
