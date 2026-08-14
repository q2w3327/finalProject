import 'package:flutter/material.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import '../database/database.dart';
import '../models/game.dart';
import '../dao/game_dao.dart';
import '../localization.dart';
import 'game_details_page.dart';

/// The main landing page for the Soccer Game List project.
class SoccerGameListPage extends StatefulWidget {
  const SoccerGameListPage({super.key});

  @override
  State<SoccerGameListPage> createState() => _SoccerGameListPageState();
}

class _SoccerGameListPageState extends State<SoccerGameListPage> {
  late AppDatabase _database;
  late GameDao _gameDao;
  List<Game> _games = [];
  Game? _selectedGame;
  bool _isDatabaseLoaded = false;

  final _dateController = TextEditingController();
  final _stadiumIdController = TextEditingController();
  final _team1IdController = TextEditingController();
  final _team2IdController = TextEditingController();

  final _prefs = EncryptedSharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    _gameDao = _database.gameDao;
    _loadGames();
  }

  Future<void> _loadGames() async {
    final games = await _gameDao.findAllGames();
    setState(() {
      _games = games;
      _isDatabaseLoaded = true;
    });
  }

  void _onGameSelected(Game game) {
    setState(() {
      _selectedGame = game;
    });

    if (MediaQuery.of(context).size.width < 900) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(
            game: game,
            onUpdate: (updatedGame) {
              _updateGame(updatedGame);
              Navigator.pop(context);
            },
            onDelete: (deletedGame) {
              _deleteGame(deletedGame);
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      _dateController.text = game.date;
      _stadiumIdController.text = game.stadiumId.toString();
      _team1IdController.text = game.team1Id.toString();
      _team2IdController.text = game.team2Id.toString();
    }
  }

  Future<void> _addGame() async {
    if (_validateFields()) {
      final game = Game(
        date: _dateController.text.trim(),
        stadiumId: int.parse(_stadiumIdController.text.trim()),
        team1Id: int.parse(_team1IdController.text.trim()),
        team2Id: int.parse(_team2IdController.text.trim()),
      );
      await _gameDao.insertGame(game);
      _saveToPrefs();
      _clearFields();
      _loadGames();
      _showSnackbar(AppLocalizations.of(context)!.translate('game_added'));
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _updateGame(Game game) async {
    await _gameDao.updateGame(game);
    _loadGames();
    _showSnackbar(AppLocalizations.of(context)!.translate('game_updated'));
  }

  Future<void> _deleteGame(Game game) async {
    await _gameDao.deleteGame(game);
    _selectedGame = null;
    _clearFields();
    _loadGames();
    _showSnackbar(AppLocalizations.of(context)!.translate('game_deleted'));
  }

  bool _validateFields() {
    if (_dateController.text.isEmpty ||
        _stadiumIdController.text.isEmpty ||
        _team1IdController.text.isEmpty ||
        _team2IdController.text.isEmpty ||
        int.tryParse(_stadiumIdController.text) == null ||
        int.tryParse(_team1IdController.text) == null ||
        int.tryParse(_team2IdController.text) == null) {
      _showErrorDialog(AppLocalizations.of(context)!.translate('error_fields'));
      return false;
    }
    return true;
  }

  void _clearFields() {
    setState(() {
      _selectedGame = null;
      _dateController.clear();
      _stadiumIdController.clear();
      _team1IdController.clear();
      _team2IdController.clear();
    });
  }

  void _saveToPrefs() {
    _prefs.setString('last_game_date', _dateController.text);
    _prefs.setString('last_stadium_id', _stadiumIdController.text);
    _prefs.setString('last_team1_id', _team1IdController.text);
    _prefs.setString('last_team2_id', _team2IdController.text);
  }

  Future<void> _loadFromPrefs() async {
    final date = _prefs.getString('last_game_date');
    final stadiumId = _prefs.getString('last_stadium_id');
    final team1Id = _prefs.getString('last_team1_id');
    final team2Id = _prefs.getString('last_team2_id');

    if (date != null) {
      _showCopyDialog(date, stadiumId ?? '', team1Id ?? '', team2Id ?? '');
    }
  }

  void _showCopyDialog(String d, String s, String t1, String t2) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('copy_previous_game')),
        content: Text('$d (Stadium $s)'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.translate('no'))),
          TextButton(
            onPressed: () {
              setState(() {
                _dateController.text = d;
                _stadiumIdController.text = s;
                _team1IdController.text = t1;
                _team2IdController.text = t2;
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
        content: Text(AppLocalizations.of(context)!.translate('help_text_game')),
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
    final isTablet = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('game_title')),
        actions: [IconButton(onPressed: _showHelpDialog, icon: const Icon(Icons.help))],
      ),
      body: !_isDatabaseLoaded
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
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
                                title: Text(l10n.translate('add_game'), style: const TextStyle(fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: _loadFromPrefs,
                                  tooltip: l10n.translate('copy_previous_game'),
                                ),
                                children: [
                                  _buildForm(l10n),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _addGame,
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
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final game = _games[index];
                            return ListTile(
                              leading: const Icon(Icons.event),
                              title: Text(game.date),
                              subtitle: Text('Stadium: ${game.stadiumId}'),
                              selected: _selectedGame?.id == game.id,
                              onTap: () => _onGameSelected(game),
                            );
                          },
                          childCount: _games.length,
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
                          if (_selectedGame != null) ...[
                            _buildForm(l10n),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_validateFields()) {
                                      final updated = Game(
                                        id: _selectedGame!.id,
                                        date: _dateController.text.trim(),
                                        stadiumId: int.parse(_stadiumIdController.text.trim()),
                                        team1Id: int.parse(_team1IdController.text.trim()),
                                        team2Id: int.parse(_team2IdController.text.trim()),
                                      );
                                      _updateGame(updated);
                                    }
                                  },
                                  child: Text(l10n.translate('update')),
                                ),
                                ElevatedButton(
                                  onPressed: () => _deleteGame(_selectedGame!),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                  child: Text(l10n.translate('delete')),
                                ),
                              ],
                            ),
                          ] else
                            const Center(child: Text("Select a game to view details")),
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
          TextField(controller: _dateController, decoration: InputDecoration(labelText: l10n.translate('game_date'))),
          const SizedBox(height: 12),
          TextField(controller: _stadiumIdController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.translate('stadium_id'))),
          const SizedBox(height: 12),
          TextField(controller: _team1IdController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.translate('team1_id'))),
          const SizedBox(height: 12),
          TextField(controller: _team2IdController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.translate('team2_id'))),
        ],
      ),
    );
  }
}
