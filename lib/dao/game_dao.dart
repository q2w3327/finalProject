import 'package:floor/floor.dart';
import '../models/game.dart';

/// Data Access Object for the [Game] entity.
/// 
/// Provides methods to perform CRUD operations on the games table.
@dao
abstract class GameDao {
  /// Retrieves all games from the database.
  @Query('SELECT * FROM Game')
  Future<List<Game>> findAllGames();

  /// Retrieves a specific game by its [id].
  @Query('SELECT * FROM Game WHERE id = :id')
  Future<Game?> findGameById(int id);

  /// Inserts a new game into the database.
  @insert
  Future<void> insertGame(Game game);

  /// Updates an existing game in the database.
  @update
  Future<void> updateGame(Game game);

  /// Deletes a game from the database.
  @delete
  Future<void> deleteGame(Game game);
}
