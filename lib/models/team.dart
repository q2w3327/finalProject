import 'package:floor/floor.dart';

/// Represents a soccer team in the application.
/// 
/// A team has a unique [id], a [name], a [homeStadium], 
/// a [city], and a [pictureUrl].
@entity
class Team {
  /// The unique identifier for the team.
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// The name of the soccer team.
  final String name;

  /// The name of the team's home stadium.
  final String homeStadium;

  /// The city where the team is based.
  final String city;

  /// The URL for the team's picture.
  final String pictureUrl;

  /// Creates a new [Team] instance.
  Team({
    this.id,
    required this.name,
    required this.homeStadium,
    required this.city,
    required this.pictureUrl,
  });
}
