import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import '../database/database.dart';
import '../models/team.dart';
import '../dao/team_dao.dart';
import '../localization.dart';
import 'team_details_page.dart';

/// The main landing page for the Soccer Team List project.
/// 
/// Displays a list of soccer teams and provides an interface
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
class SoccerTeamListPage extends StatefulWidget {
  /// Creates a new [SoccerTeamListPage] instance.
  const SoccerTeamListPage({super.key});

  @override
  State<SoccerTeamListPage> createState() => _SoccerTeamListPageState();
}

/// The state for [SoccerTeamListPage].
class _SoccerTeamListPageState extends State<SoccerTeamListPage> {
  /// The database instance.
  late AppDatabase _database;

  /// The Data Access Object for teams.
  late TeamDao _teamDao;

  /// The list of teams retrieved from the database.
  List<Team> _teams = [];

  /// The currently selected team for updating or deleting.
  Team? _selectedTeam;

  /// Whether the database has been initialized and teams loaded.
  bool _isDatabaseLoaded = false;

  /// Controller for the team name field.
  final _nameController = TextEditingController();

  /// Controller for the home stadium field.
  final _stadiumController = TextEditingController();

  /// Controller for the city field.
  final _cityController = TextEditingController();

  /// Controller for the picture URL field.
  final _urlController = TextEditingController();

  /// The encrypted shared preferences instance.
  final _prefs = EncryptedSharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    // Initialize database when the page is first created.
    _initDatabase();
  }

  /// Initializes the Floor database and loads the teams.
  Future<void> _initDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _teamDao = _database.teamDao;
    _loadTeams();
  }

  /// Fetches all teams from the database and updates the UI state.
  Future<void> _loadTeams() async {
    final teams = await _teamDao.findAllTeams();
    setState(() {
      _teams = teams;
      _isDatabaseLoaded = true;
    });
  }

  /// Handles team selection from the ListView.
  /// 
  /// In tablet mode, it populates the side form.
  /// In phone mode, it navigates to the [TeamDetailsPage].
  void _onTeamSelected(Team team) {
    setState(() {
      _selectedTeam = team;
      _nameController.text = team.name;
      _stadiumController.text = team.homeStadium;
      _cityController.text = team.city;
      _urlController.text = team.pictureUrl;
    });

    // Check for tablet layout (width < 600 means phone)
    if (MediaQuery.of(context).size.width < 600) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamDetailsPage(
            team: team,
            onUpdate: (updatedTeam) {
              _updateTeam(updatedTeam);
              Navigator.pop(context);
            },
            onDelete: (deletedTeam) {
              _deleteTeam(deletedTeam);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }

  /// Adds a new team to the database.
  /// 
  /// Validates fields first, then inserts, saves to prefs, clears the form,
  /// and reloads the list.
  Future<void> _addTeam() async {
    if (_validateFields()) {
      final team = Team(
        name: _nameController.text,
        homeStadium: _stadiumController.text,
        city: _cityController.text,
        pictureUrl: _urlController.text,
      );
      await _teamDao.insertTeam(team);
      _saveToPrefs();
      _clearFields();
      _loadTeams();
      _showSnackbar(AppLocalizations.of(context)!.translate('team_added'));
    }
  }

  /// Updates an existing team's information in the database.
  Future<void> _updateTeam(Team team) async {
    await _teamDao.updateTeam(team);
    _loadTeams();
    _showSnackbar(AppLocalizations.of(context)!.translate('team_updated'));
  }

  /// Deletes a team from the database and list.
  Future<void> _deleteTeam(Team team) async {
    await _teamDao.deleteTeam(team);
    _selectedTeam = null;
    _clearFields();
    _loadTeams();
    _showSnackbar(AppLocalizations.of(context)!.translate('team_deleted'));
  }

  /// Validates that all form fields are not empty.
  /// 
  /// Shows an [AlertDialog] if validation fails.
  bool _validateFields() {
    if (_nameController.text.isEmpty ||
        _stadiumController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _urlController.text.isEmpty) {
      _showErrorDialog(AppLocalizations.of(context)!.translate('error_fields'));
      return false;
    }
    return true;
  }

  /// Clears all text fields and resets selection.
  void _clearFields() {
    setState(() {
      _selectedTeam = null;
      _nameController.clear();
      _stadiumController.clear();
      _cityController.clear();
      _urlController.clear();
    });
  }

  /// Saves current field values to [EncryptedSharedPreferences].
  void _saveToPrefs() {
    _prefs.setString('last_name', _nameController.text);
    _prefs.setString('last_stadium', _stadiumController.text);
    _prefs.setString('last_city', _cityController.text);
    _prefs.setString('last_url', _urlController.text);
  }

  /// Attempts to load the previously saved team data from preferences.
  /// 
  /// Shows a confirmation dialog to the user.
  Future<void> _loadFromPrefs() async {
    final name = _prefs.getString('last_name');
    final stadium = _prefs.getString('last_stadium');
    final city = _prefs.getString('last_city');
    final url = _prefs.getString('last_url');

    if (name != null) {
      _showCopyDialog(name, stadium ?? '', city ?? '', url ?? '');
    }
  }

  /// Shows an [AlertDialog] asking if the user wants to copy previous data.
  void _showCopyDialog(String n, String s, String c, String u) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('copy_previous')),
        content: Text('$n ($c)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('no')),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _nameController.text = n;
                _stadiumController.text = s;
                _cityController.text = c;
                _urlController.text = u;
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
        title: Text(l10n.translate('title')),
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
                              child: Text(l10n.translate('add_team')),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _teams.length,
                          itemBuilder: (context, index) {
                            final team = _teams[index];
                            return ListTile(
                              title: Text(team.name),
                              subtitle: Text(team.city),
                              selected: _selectedTeam?.id == team.id,
                              onTap: () => _onTeamSelected(team),
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
      floatingActionButton: !isTablet ? FloatingActionButton(
        onPressed: _clearFields,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  /// Builds the input form for adding/updating teams.
  Widget _buildForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.translate('team_name'))),
          TextField(controller: _stadiumController, decoration: InputDecoration(labelText: l10n.translate('stadium'))),
          TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.translate('city'))),
          TextField(controller: _urlController, decoration: InputDecoration(labelText: l10n.translate('image_url'))),
          const SizedBox(height: 20),
          // Show different buttons based on whether a team is selected
          if (_selectedTeam == null)
            ElevatedButton(onPressed: _addTeam, child: Text(l10n.translate('submit')))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_validateFields()) {
                      final updated = Team(
                        id: _selectedTeam!.id,
                        name: _nameController.text,
                        homeStadium: _stadiumController.text,
                        city: _cityController.text,
                        pictureUrl: _urlController.text,
                      );
                      _updateTeam(updated);
                    }
                  },
                  child: Text(l10n.translate('update')),
                ),
                ElevatedButton(
                  onPressed: () => _deleteTeam(_selectedTeam!),
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
