import 'package:floor/floor.dart';
import '../models/player.dart';

/// Data Access Object for the [Player] entity.
@dao
abstract class PlayerDao {
  /// Retrieves all players from the database.
  @Query('SELECT * FROM Player')
  Future<List<Player>> findAllPlayers();

  /// Retrieves a specific player by its [id].
  @Query('SELECT * FROM Player WHERE id = :id')
  Future<Player?> findPlayerById(int id);

  /// Inserts a new player into the database.
  @insert
  Future<void> insertPlayer(Player player);

  /// Updates an existing player in the database.
  @update
  Future<void> updatePlayer(Player player);

  /// Deletes a player from the database.
  @delete
  Future<void> deletePlayer(Player player);
}