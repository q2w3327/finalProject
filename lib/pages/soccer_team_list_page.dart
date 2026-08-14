import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import '../database/database.dart';
import '../models/team.dart';
import '../dao/team_dao.dart';
import '../localization.dart';
import 'team_details_page.dart';

/// The main landing page for the Soccer Team List project.
class SoccerTeamListPage extends StatefulWidget {
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

  final _prefs = EncryptedSharedPreferences.getInstance();

  // Used for reloading teams after modifications.
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
    });

    // Check if we are in "Mobile Mode" (width < 900)
    if (MediaQuery.of(context).size.width < 900) {
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
    } else {
      // Tablet Mode: Populate side form
      _nameController.text = team.name;
      _stadiumController.text = team.homeStadium;
      _cityController.text = team.city;
      _urlController.text = team.pictureUrl;
    }
  }

  Future<void> _addTeam() async {
    if (_validateFields()) {
      final team = Team(
        name: _nameController.text.trim(),
        homeStadium: _stadiumController.text.trim(),
        city: _cityController.text.trim(),
        pictureUrl: _urlController.text.trim(),
      );
      await _teamDao.insertTeam(team);
      _saveToPrefs();
      _clearFields();
      _loadTeams();
      _showSnackbar(AppLocalizations.of(context)!.translate('team_added'));
      FocusScope.of(context).unfocus();
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
    final name = _prefs.getString('last_name');
    final stadium = _prefs.getString('last_stadium');
    final city = _prefs.getString('last_city');
    final url = _prefs.getString('last_url');

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
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.translate('no'))),
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
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('help')),
        content: Text(AppLocalizations.of(context)!.translate('help_text')),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Increased threshold to 900 to ensure phone landscape stays in "mobile mode"
    final isTablet = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('title')),
        actions: [IconButton(onPressed: _showHelpDialog, icon: const Icon(Icons.help))],
      ),
      body: !_isDatabaseLoaded
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Form at the top, inside SliverToBoxAdapter so it scrolls with the list
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionTile(
                                shape: const RoundedRectangleBorder(side: BorderSide.none),
                                collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                                initiallyExpanded: true,
                                title: Text(l10n.translate('add_team'), style: const TextStyle(fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: _loadFromPrefs,
                                  tooltip: l10n.translate('copy_previous'),
                                ),
                                children: [
                                  _buildForm(l10n),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _addTeam,
                                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                                    child: Text(l10n.translate('submit')),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // The List portion
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final team = _teams[index];
                            return ListTile(
                              leading: const Icon(Icons.group),
                              title: Text(team.name),
                              subtitle: Text(team.city),
                              selected: _selectedTeam?.id == team.id,
                              onTap: () => _onTeamSelected(team),
                            );
                          },
                          childCount: _teams.length,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isTablet)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(l10n.translate('update'), style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 10),
                          if (_selectedTeam != null) ...[
                            _buildForm(l10n),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_validateFields()) {
                                      final updated = Team(
                                        id: _selectedTeam!.id,
                                        name: _nameController.text.trim(),
                                        homeStadium: _stadiumController.text.trim(),
                                        city: _cityController.text.trim(),
                                        pictureUrl: _urlController.text.trim(),
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
                          ] else
                            const Center(child: Text("Select a team to view details")),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.translate('team_name'))),
          const SizedBox(height: 12),
          TextField(controller: _stadiumController, decoration: InputDecoration(labelText: l10n.translate('stadium'))),
          const SizedBox(height: 12),
          TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.translate('city'))),
          const SizedBox(height: 12),
          TextField(controller: _urlController, decoration: InputDecoration(labelText: l10n.translate('image_url'))),
        ],
      ),
    );
  }
}
