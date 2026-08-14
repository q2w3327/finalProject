import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import '../models/player.dart';
import '../localization.dart';

/// Page to display and edit details of a [Player] on phone screens,
/// or to add a new player when [player] is null.
///
/// This page is used in phone layouts to provide the "Detail" view
/// of the Master-Detail pattern, as well as the "add new player" flow.
class PlayerDetailsPage extends StatefulWidget {
  /// The player to display details for. Null means "add new player" mode.
  final Player? player;

  /// Optional data to pre-fill the form with when in "add new" mode,
  /// used for the "copy from previous player" feature.
  final Player? prefillData;

  /// Callback function when a new player is added.
  final Function(Player)? onAdd;

  /// Callback function when the player is updated.
  final Function(Player)? onUpdate;

  /// Callback function when the player is deleted.
  final Function(Player)? onDelete;

  /// Creates a new [PlayerDetailsPage] instance.
  const PlayerDetailsPage({
    super.key,
    this.player,
    this.prefillData,
    this.onAdd,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<PlayerDetailsPage> createState() => _PlayerDetailsPageState();
}

/// The state for [PlayerDetailsPage].
class _PlayerDetailsPageState extends State<PlayerDetailsPage> {
  /// Instance of [EncryptedSharedPreferences] to store draft data.
  late EncryptedSharedPreferences _prefs;

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

  /// Whether this page is in "add new" mode (true) or "edit existing" mode (false).
  bool get _isAddMode => widget.player == null;

  @override
  void initState() {
    super.initState();
    _prefs = EncryptedSharedPreferences.getInstance();

    // In edit mode, pre-populate with the existing player's data.
    // In add mode, pre-populate with prefillData if provided (copy-previous feature),
    // otherwise load from encrypted shared preferences if a draft exists.
    final source = widget.player ?? widget.prefillData;

    String initialFirstName = source?.firstName ?? '';
    String initialLastName = source?.lastName ?? '';
    String initialAddress = source?.address ?? '';
    String initialDob = source?.dateOfBirth ?? '';
    String initialTeamId = source?.teamId.toString() ?? '';

    if (_isAddMode && widget.prefillData == null) {
      initialFirstName = _prefs.getString('draft_firstName') ?? '';
      initialLastName = _prefs.getString('draft_lastName') ?? '';
      initialAddress = _prefs.getString('draft_address') ?? '';
      initialDob = _prefs.getString('draft_dob') ?? '';
      initialTeamId = _prefs.getString('draft_teamId') ?? '';
    }

    _firstNameController = TextEditingController(text: initialFirstName);
    _lastNameController = TextEditingController(text: initialLastName);
    _addressController = TextEditingController(text: initialAddress);
    _dobController = TextEditingController(text: initialDob);
    _teamIdController = TextEditingController(text: initialTeamId);

    // Add listeners to save changes to encrypted shared preferences as the user types.
    // Only save to draft if we are in "add new player" mode, to avoid overwriting 
    // the draft when simply viewing or editing an existing player.
    if (_isAddMode) {
      _firstNameController.addListener(() => _prefs.setString('draft_firstName', _firstNameController.text));
      _lastNameController.addListener(() => _prefs.setString('draft_lastName', _lastNameController.text));
      _addressController.addListener(() => _prefs.setString('draft_address', _addressController.text));
      _dobController.addListener(() => _prefs.setString('draft_dob', _dobController.text));
      _teamIdController.addListener(() => _prefs.setString('draft_teamId', _teamIdController.text));
    }
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

  /// Clears the draft data from [EncryptedSharedPreferences].
  void _clearDraft() {
    _prefs.setString('draft_firstName', '');
    _prefs.setString('draft_lastName', '');
    _prefs.setString('draft_address', '');
    _prefs.setString('draft_dob', '');
    _prefs.setString('draft_teamId', '');
  }

  /// Validates that all fields are filled and the team ID is a valid number.
  ///
  /// Shows an [AlertDialog] if validation fails.
  bool _validateFields() {
    final isValid = _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        int.tryParse(_teamIdController.text) != null;

    if (!isValid) {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(l10n.translate('error_fields')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // Show "Add Player" title when adding, or the player's name when editing.
        title: Text(_isAddMode
            ? l10n.translate('add_player')
            : '${widget.player!.firstName} ${widget.player!.lastName}'),
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
              // Show Submit button in add mode, or Update/Delete in edit mode.
              if (_isAddMode)
                ElevatedButton(
                  onPressed: () {
                    if (_validateFields()) {
                      final newPlayer = Player(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        address: _addressController.text,
                        dateOfBirth: _dobController.text,
                        teamId: int.tryParse(_teamIdController.text) ?? 0,
                      );
                      _clearDraft();
                      widget.onAdd?.call(newPlayer);
                    }
                  },
                  child: Text(l10n.translate('submit')),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_validateFields()) {
                          final updated = Player(
                            id: widget.player!.id,
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            address: _addressController.text,
                            dateOfBirth: _dobController.text,
                            teamId: int.tryParse(_teamIdController.text) ?? widget.player!.teamId,
                          );
                          _clearDraft();
                          widget.onUpdate?.call(updated);
                        }
                      },
                      child: Text(l10n.translate('update')),
                    ),
                    ElevatedButton(
                      onPressed: () => widget.onDelete?.call(widget.player!),
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