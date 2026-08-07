import 'package:floor/floor.dart';

/// Represents a soccer player.
@entity
class Player {
  /// Unique identifier for the player.
  @PrimaryKey(autoGenerate: true)
  final int? id;

  /// Player's first name.
  final String firstName;

  /// Player's last name.
  final String lastName;

  /// Player's home address.
  final String address;

  /// Player's date of birth, stored as an ISO 8601 string (e.g. "2005-03-21").
  final String dateOfBirth;

  /// ID of the team this player belongs to.
  final int teamId;

  Player({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.dateOfBirth,
    required this.teamId,
  });
}