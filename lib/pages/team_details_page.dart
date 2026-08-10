import 'package:flutter/material.dart';
import '../models/team.dart';
import '../localization.dart';

/// Page to display and edit details of a [Team] on phone screens.
class TeamDetailsPage extends StatefulWidget {
  final Team team;
  final Function(Team) onUpdate;
  final Function(Team) onDelete;

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
      appBar: AppBar(title: Text(widget.team.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Enhanced Image loading with fallback for bad URLs
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: widget.team.pictureUrl.startsWith('http')
                    ? Image.network(
                        widget.team.pictureUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              Text("Invalid Image URL", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      )
                    : const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
              ),
              const SizedBox(height: 16),
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
