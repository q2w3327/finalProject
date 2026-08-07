import 'package:flutter/material.dart';
import '../models/player.dart';
import '../localization.dart';

/// Page to display and edit details of a [Player] on phone screens.
///
/// This page is used in phone layouts to provide the "Detail" view
/// of the Master-Detail pattern.
class PlayerDetailsPage extends StatefulWidget {
  /// The player to display details for.
  final Player player;

  /// Callback function when the player is updated.
  final Function(Player) onUpdate;

  /// Callback function when the player is deleted.
  final Function(Player) onDelete;

  /// Creates a new [PlayerDetailsPage] instance.
  const PlayerDetailsPage({
    super.key,
    required this.player,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<PlayerDetailsPage> createState() => _PlayerDetailsPageState();
}

/// The state for [PlayerDetailsPage].
class _PlayerDetailsPageState extends State<PlayerDetailsPage> {
  /// Controller for the first name field.
  late TextEditingController _firstNameController;

  /// Controller for the last name field.
  late TextEditingController _lastNameController;

  /// Controller for the address field.
  late TextEditingController _addressController;

  /// Controller for the date of birth field.
  late TextEditingController _dobController;

  /// Controller for the team ID field.
  late TextEditingController _teamIdController;

  @override
  void initState() {
    super.initState();
    // Pre-populate controllers with the player's current data.
    _firstNameController = TextEditingController(text: widget.player.firstName);
    _lastNameController = TextEditingController(text: widget.player.lastName);
    _addressController = TextEditingController(text: widget.player.address);
    _dobController = TextEditingController(text: widget.player.dateOfBirth);
    _teamIdController = TextEditingController(text: widget.player.teamId.toString());
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources.
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _teamIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // Show the player's full name in the title.
        title: Text('${widget.player.firstName} ${widget.player.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: l10n.translate('first_name')),
              ),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: l10n.translate('last_name')),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: l10n.translate('address')),
              ),
              TextField(
                controller: _dobController,
                decoration: InputDecoration(labelText: l10n.translate('date_of_birth')),
              ),
              TextField(
                controller: _teamIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.translate('team_id')),
              ),
              const SizedBox(height: 20),
              // Actions row for Update and Delete
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final updated = Player(
                        id: widget.player.id,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        address: _addressController.text,
                        dateOfBirth: _dobController.text,
                        teamId: int.tryParse(_teamIdController.text) ?? widget.player.teamId,
                      );
                      widget.onUpdate(updated);
                    },
                    child: Text(l10n.translate('update')),
                  ),
                  ElevatedButton(
                    onPressed: () => widget.onDelete(widget.player),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(l10n.translate('delete')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}