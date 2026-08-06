import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider/client_encrypt_shared_preferences.dart';
import '../database/database.dart';
import '../models/team.dart';
import '../dao/team_dao.dart';
import '../localization.dart';
import 'team_details_page.dart';

/// The main landing page for the Soccer Team List project.
/// 
/// Displays a list of soccer teams and provides an interface
/// to add, update, and delete them.
class SoccerTeamListPage extends StatefulWidget {
  /// Creates a new [SoccerTeamListPage] instance.
  const SoccerTeamListPage({super.key});

  @override
  State<SoccerTeamListPage> createState() => _SoccerTeamListPageState();
}

class _SoccerTeamListPageState extends State<SoccerTeamListPage> {
  late AppDatabase _database;
  late TeamDao _teamDao;
  List<Team> _teams = [];
  Team? _selectedTeam;
  bool _isDatabaseLoaded = false;

  final _nameController = TextEditingController();
  final _stadiumController = TextEditingController();
  final _cityController = TextEditingController();
  final _urlController = TextEditingController();

  final _prefs = EncryptSharedPreferences.instance;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _teamDao = _database.teamDao;
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final teams = await _teamDao.findAllTeams();
    setState(() {
      _teams = teams;
      _isDatabaseLoaded = true;
    });
  }

  void _onTeamSelected(Team team) {
    setState(() {
      _selectedTeam = team;
      _nameController.text = team.name;
      _stadiumController.text = team.homeStadium;
      _cityController.text = team.city;
      _urlController.text = team.pictureUrl;
    });

    // Check for tablet layout
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

  Future<void> _updateTeam(Team team) async {
    await _teamDao.updateTeam(team);
    _loadTeams();
    _showSnackbar(AppLocalizations.of(context)!.translate('team_updated'));
  }

  Future<void> _deleteTeam(Team team) async {
    await _teamDao.deleteTeam(team);
    _selectedTeam = null;
    _clearFields();
    _loadTeams();
    _showSnackbar(AppLocalizations.of(context)!.translate('team_deleted'));
  }

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

  void _clearFields() {
    setState(() {
      _selectedTeam = null;
      _nameController.clear();
      _stadiumController.clear();
      _cityController.clear();
      _urlController.clear();
    });
  }

  void _saveToPrefs() {
    _prefs.setString('last_name', _nameController.text);
    _prefs.setString('last_stadium', _stadiumController.text);
    _prefs.setString('last_city', _cityController.text);
    _prefs.setString('last_url', _urlController.text);
  }

  Future<void> _loadFromPrefs() async {
    final name = await _prefs.getString('last_name');
    final stadium = await _prefs.getString('last_stadium');
    final city = await _prefs.getString('last_city');
    final url = await _prefs.getString('last_url');

    if (name != null) {
      _showCopyDialog(name, stadium ?? '', city ?? '', url ?? '');
    }
  }

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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('title')),
        actions: [
          IconButton(onPressed: _showHelpDialog, icon: const Icon(Icons.help)),
        ],
      ),
      body: !_isDatabaseLoaded
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
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
      floatingActionButton: !isTablet ? FloatingActionButton(
        onPressed: _clearFields,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.translate('team_name'))),
          TextField(controller: _stadiumController, decoration: InputDecoration(labelText: l10n.translate('stadium'))),
          TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.translate('city'))),
          TextField(controller: _urlController, decoration: InputDecoration(labelText: l10n.translate('image_url'))),
          const SizedBox(height: 20),
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
