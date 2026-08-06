import 'package:floor/floor.dart';
import '../models/team.dart';

/// Data Access Object for the [Team] entity.
/// 
/// Provides methods to perform CRUD operations on the teams table.
@dao
abstract class TeamDao {
  /// Retrieves all teams from the database.
  @Query('SELECT * FROM Team')
  Future<List<Team>> findAllTeams();

  /// Retrieves a specific team by its [id].
  @Query('SELECT * FROM Team WHERE id = :id')
  Future<Team?> findTeamById(int id);

  /// Inserts a new team into the database.
  @insert
  Future<void> insertTeam(Team team);

  /// Updates an existing team in the database.
  @update
  Future<void> updateTeam(Team team);

  /// Deletes a team from the database.
  @delete
  Future<void> deleteTeam(Team team);
}
