import 'package:floor/floor.dart';

/// Represents a soccer game in the application.
/// 
/// A game has a unique [id], a [date], a [stadiumId], 
/// a [team1Id], and a [team2Id].
@entity
class Game {
  /// The unique identifier for the game.
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// The date of the game.
  final String date;

  /// The ID of the stadium where the game is played.
  final int stadiumId;

  /// The ID of the first team.
  final int team1Id;

  /// The ID of the second team.
  final int team2Id;

  /// Creates a new [Game] instance.
  Game({
    this.id,
    required this.date,
    required this.stadiumId,
    required this.team1Id,
    required this.team2Id,
  });
}
