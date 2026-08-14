import 'package:flutter/material.dart';
import '../models/game.dart';
import '../localization.dart';

/// Page to display and edit details of a [Game] on phone screens.
class GameDetailsPage extends StatefulWidget {
  final Game game;
  final Function(Game) onUpdate;
  final Function(Game) onDelete;

  const GameDetailsPage({
    super.key,
    required this.game,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  late TextEditingController _dateController;
  late TextEditingController _stadiumIdController;
  late TextEditingController _team1IdController;
  late TextEditingController _team2IdController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.game.date);
    _stadiumIdController = TextEditingController(text: widget.game.stadiumId.toString());
    _team1IdController = TextEditingController(text: widget.game.team1Id.toString());
    _team2IdController = TextEditingController(text: widget.game.team2Id.toString());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _stadiumIdController.dispose();
    _team1IdController.dispose();
    _team2IdController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    if (_dateController.text.isEmpty ||
        _stadiumIdController.text.isEmpty ||
        _team1IdController.text.isEmpty ||
        _team2IdController.text.isEmpty ||
        int.tryParse(_stadiumIdController.text) == null ||
        int.tryParse(_team1IdController.text) == null ||
        int.tryParse(_team2IdController.text) == null) {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(l10n.translate('error_fields')),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('${l10n.translate('game_date')}: ${widget.game.date}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _dateController, decoration: InputDecoration(labelText: l10n.translate('game_date'))),
              TextField(controller: _stadiumIdController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.translate('stadium_id'))),
              TextField(controller: _team1IdController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.translate('team1_id'))),
              TextField(controller: _team2IdController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.translate('team2_id'))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_validateFields()) {
                        final updated = Game(
                          id: widget.game.id,
                          date: _dateController.text.trim(),
                          stadiumId: int.parse(_stadiumIdController.text.trim()),
                          team1Id: int.parse(_team1IdController.text.trim()),
                          team2Id: int.parse(_team2IdController.text.trim()),
                        );
                        widget.onUpdate(updated);
                      }
                    },
                    child: Text(l10n.translate('update')),
                  ),
                  ElevatedButton(
                    onPressed: () => widget.onDelete(widget.game),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
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
