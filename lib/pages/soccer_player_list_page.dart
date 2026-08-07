import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import '../database/database.dart';
import '../models/player.dart';
import '../dao/player_dao.dart';
import '../localization.dart';
import 'player_details_page.dart';

/// The main landing page for the Soccer Player List project.
///
/// Displays a list of soccer players and provides an interface
/// to add, update, and delete them.
///
/// Satisfies requirements:
/// 1. ListView of items
/// 2. TextField and button for insertion
/// 3. Database storage (Floor/SQLite)
/// 4. Master-Detail view (Phone vs Tablet)
/// 5. Snackbar and AlertDialog notifications
/// 6. EncryptedSharedPreferences for saving data
/// 7. ActionBar with instructions
/// 8. Localization support
class SoccerPlayerListPage extends StatefulWidget {
  /// Creates a new [SoccerPlayerListPage] instance.
  const SoccerPlayerListPage({super.key});

  @override
  State<SoccerPlayerListPage> createState() => _SoccerPlayerListPageState();
}

/// The state for [SoccerPlayerListPage].
class _SoccerPlayerListPageState extends State<SoccerPlayerListPage> {
  /// The database instance.
  late AppDatabase _database;

  /// The Data Access Object for players.
  late PlayerDao _playerDao;

  /// The list of players retrieved from the database.
  List<Player> _players = [];

  /// The currently selected player for updating or deleting.
  Player? _selectedPlayer;

  /// Whether the database has been initialized and players loaded.
  bool _isDatabaseLoaded = false;

  /// Controller for the first name field.
  final _firstNameController = TextEditingController();

  /// Controller for the last name field.
  final _lastNameController = TextEditingController();

  /// Controller for the address field.
  final _addressController = TextEditingController();

  /// Controller for the date of birth field.
  final _dobController = TextEditingController();

  /// Controller for the team ID field.
  final _teamIdController = TextEditingController();

  /// The encrypted shared preferences instance.
  final _prefs = EncryptedSharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    // Initialize database when the page is first created.
    _initDatabase();
  }

  /// Initializes the Floor database and loads the players.
  Future<void> _initDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _playerDao = _database.playerDao;
    _loadPlayers();
  }

  /// Fetches all players from the database and updates the UI state.
  Future<void> _loadPlayers() async {
    final players = await _playerDao.findAllPlayers();
    setState(() {
      _players = players;
      _isDatabaseLoaded = true;
    });
  }

  /// Handles player selection from the ListView.
  ///
  /// In tablet mode, it populates the side form.
  /// In phone mode, it navigates to the [PlayerDetailsPage].
  void _onPlayerSelected(Player player) {
    setState(() {
      _selectedPlayer = player;
      _firstNameController.text = player.firstName;
      _lastNameController.text = player.lastName;
      _addressController.text = player.address;
      _dobController.text = player.dateOfBirth;
      _teamIdController.text = player.teamId.toString();
    });

    // Check for tablet layout (width < 600 means phone)
    if (MediaQuery.of(context).size.width < 600) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerDetailsPage(
            player: player,
            onUpdate: (updatedPlayer) {
              _updatePlayer(updatedPlayer);
              Navigator.pop(context);
            },
            onDelete: (deletedPlayer) {
              _deletePlayer(deletedPlayer);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  /// Adds a new player to the database.
  ///
  /// Validates fields first, then inserts, saves to prefs, clears the form,
  /// and reloads the list.
  Future<void> _addPlayer() async {
    if (_validateFields()) {
      final player = Player(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address: _addressController.text,
        dateOfBirth: _dobController.text,
        teamId: int.tryParse(_teamIdController.text) ?? 0,
      );
      await _playerDao.insertPlayer(player);
      _saveToPrefs();
      _clearFields();
      _loadPlayers();
      _showSnackbar(AppLocalizations.of(context)!.translate('player_added'));
    }
  }

  /// Updates an existing player's information in the database.
  Future<void> _updatePlayer(Player player) async {
    await _playerDao.updatePlayer(player);
    _loadPlayers();
    _showSnackbar(AppLocalizations.of(context)!.translate('player_updated'));
  }

  /// Deletes a player from the database and list.
  Future<void> _deletePlayer(Player player) async {
    await _playerDao.deletePlayer(player);
    _selectedPlayer = null;
    _clearFields();
    _loadPlayers();
    _showSnackbar(AppLocalizations.of(context)!.translate('player_deleted'));
  }

  /// Validates that all form fields are not empty and team ID is a valid number.
  ///
  /// Shows an [AlertDialog] if validation fails.
  bool _validateFields() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _teamIdController.text.isEmpty ||
        int.tryParse(_teamIdController.text) == null) {
      _showErrorDialog(AppLocalizations.of(context)!.translate('error_fields'));
      return false;
    }
    return true;
  }

  /// Clears all text fields and resets selection.
  void _clearFields() {
    setState(() {
      _selectedPlayer = null;
      _firstNameController.clear();
      _lastNameController.clear();
      _addressController.clear();
      _dobController.clear();
      _teamIdController.clear();
    });
  }

  /// Saves current field values to [EncryptedSharedPreferences].
  void _saveToPrefs() {
    _prefs.setString('last_first_name', _firstNameController.text);
    _prefs.setString('last_last_name', _lastNameController.text);
    _prefs.setString('last_address', _addressController.text);
    _prefs.setString('last_dob', _dobController.text);
    _prefs.setString('last_team_id', _teamIdController.text);
  }

  /// Attempts to load the previously saved player data from preferences.
  ///
  /// Shows a confirmation dialog to the user.
  Future<void> _loadFromPrefs() async {
    // Reset the form to blank "add" mode first.
    _clearFields();
    final firstName = _prefs.getString('last_first_name');
    final lastName = _prefs.getString('last_last_name');
    final address = _prefs.getString('last_address');
    final dob = _prefs.getString('last_dob');
    final teamId = _prefs.getString('last_team_id');

    if (firstName != null) {
      _showCopyDialog(firstName, lastName ?? '', address ?? '', dob ?? '', teamId ?? '');
    }
  }

  /// Shows an [AlertDialog] asking if the user wants to copy previous data.
  void _showCopyDialog(String fn, String ln, String addr, String dob, String tid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('copy_previous_player')),
        content: Text('$fn $ln'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('no')),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _firstNameController.text = fn;
                _lastNameController.text = ln;
                _addressController.text = addr;
                _dobController.text = dob;
                _teamIdController.text = tid;
              });
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.translate('yes')),
          ),
        ],
      ),
    );
  }

  /// Shows an error [AlertDialog] with the given [message].
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  /// Shows the help instructions [AlertDialog].
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('help')),
        content: Text(AppLocalizations.of(context)!.translate('help_text')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  /// Shows a [SnackBar] with the given [message].
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Determine if we are on a tablet/desktop layout
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('player_title')),
        actions: [
          // Help icon in the AppBar
          IconButton(onPressed: _showHelpDialog, icon: const Icon(Icons.help)),
        ],
      ),
      body: !_isDatabaseLoaded
          ? const Center(child: CircularProgressIndicator())
          : Row(
        children: [
          // The ListView side (Master)
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _loadFromPrefs,
                        child: Text(l10n.translate('add_player')),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _players.length,
                    itemBuilder: (context, index) {
                      final player = _players[index];
                      return ListTile(
                        title: Text('${player.firstName} ${player.lastName}'),
                        subtitle: Text(player.address),
                        selected: _selectedPlayer?.id == player.id,
                        onTap: () => _onPlayerSelected(player),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // The Details side (Detail) - only visible on tablet
          if (isTablet)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(l10n),
              ),
            ),
        ],
      ),
      // Floating button to clear form on phones
      floatingActionButton: !isTablet
          ? FloatingActionButton(
        onPressed: _clearFields,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  /// Builds the input form for adding/updating players.
  Widget _buildForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(controller: _firstNameController, decoration: InputDecoration(labelText: l10n.translate('first_name'))),
          TextField(controller: _lastNameController, decoration: InputDecoration(labelText: l10n.translate('last_name'))),
          TextField(controller: _addressController, decoration: InputDecoration(labelText: l10n.translate('address'))),
          TextField(controller: _dobController, decoration: InputDecoration(labelText: l10n.translate('date_of_birth'))),
          TextField(
            controller: _teamIdController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.translate('team_id')),
          ),
          const SizedBox(height: 20),
          // Show different buttons based on whether a player is selected
          if (_selectedPlayer == null)
            ElevatedButton(onPressed: _addPlayer, child: Text(l10n.translate('submit')))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_validateFields()) {
                      final updated = Player(
                        id: _selectedPlayer!.id,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        address: _addressController.text,
                        dateOfBirth: _dobController.text,
                        teamId: int.tryParse(_teamIdController.text) ?? _selectedPlayer!.teamId,
                      );
                      _updatePlayer(updated);
                    }
                  },
                  child: Text(l10n.translate('update')),
                ),
                ElevatedButton(
                  onPressed: () => _deletePlayer(_selectedPlayer!),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: Text(l10n.translate('delete')),
                ),
              ],
            ),
        ],
      ),
    );
  }
}