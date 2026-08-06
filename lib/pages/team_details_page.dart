import 'package:flutter/material.dart';
import '../models/team.dart';
import '../localization.dart';

/// Page to display and edit details of a [Team] on phone screens.
class TeamDetailsPage extends StatefulWidget {
  /// The team to display details for.
  final Team team;

  /// Callback when the team is updated.
  final Function(Team) onUpdate;

  /// Callback when the team is deleted.
  final Function(Team) onDelete;

  /// Creates a new [TeamDetailsPage] instance.
  const TeamDetailsPage({
    super.key,
    required this.team,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _stadiumController;
  late TextEditingController _cityController;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team.name);
    _stadiumController = TextEditingController(text: widget.team.homeStadium);
    _cityController = TextEditingController(text: widget.team.city);
    _urlController = TextEditingController(text: widget.team.pictureUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stadiumController.dispose();
    _cityController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.team.pictureUrl.startsWith('http'))
                Image.network(
                  widget.team.pictureUrl,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                ),
              TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.translate('team_name'))),
              TextField(controller: _stadiumController, decoration: InputDecoration(labelText: l10n.translate('stadium'))),
              TextField(controller: _cityController, decoration: InputDecoration(labelText: l10n.translate('city'))),
              TextField(controller: _urlController, decoration: InputDecoration(labelText: l10n.translate('image_url'))),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final updated = Team(
                        id: widget.team.id,
                        name: _nameController.text,
                        homeStadium: _stadiumController.text,
                        city: _cityController.text,
                        pictureUrl: _urlController.text,
                      );
                      widget.onUpdate(updated);
                    },
                    child: Text(l10n.translate('update')),
                  ),
                  ElevatedButton(
                    onPressed: () => widget.onDelete(widget.team),
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
