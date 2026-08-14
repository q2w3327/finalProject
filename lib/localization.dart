import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Localization class to handle multiple languages.
/// 
/// This class provides a centralized way to manage translations
/// across the application. It supports English (US) and English (UK) 
/// to satisfy the project requirement for supporting different 
/// versions of English.
class AppLocalizations {
  /// The locale for the current instance.
  final Locale locale;

  /// Creates a new [AppLocalizations] instance.
  AppLocalizations(this.locale);

  /// Retrieves the current [AppLocalizations] instance from the [BuildContext].
  /// 
  /// Returns null if the localization is not found.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// Internal map containing the translated strings for each supported locale.
  static const _localizedValues = {
    'en_US': {
      'home_player_button': 'Soccer Player Page',
      'home_team_button': 'Soccer Team List Page',
      'home_game_button': 'Soccer Game List Page',
      'app_title': 'Final Project - Soccer',
      'title': 'Soccer Team List',
      'add_team': 'Add Team',
      'team_name': 'Team Name',
      'stadium': 'Home Stadium',
      'city': 'City',
      'image_url': 'Image URL (http://)',
      'submit': 'Submit',
      'update': 'Update',
      'delete': 'Delete',
      'copy_previous': 'Copy from previous?',
      'yes': 'Yes',
      'no': 'No',
      'help': 'Help Instructions',
      'help_text': 'Use the form to add a new team. Click on a team in the list to update or delete it. You can copy details from the last added team.',
      'error_fields': 'Please fill all fields',
      'team_added': 'Team added successfully',
      'team_updated': 'Team updated successfully',
      'team_deleted': 'Team deleted successfully',
      'color': 'Color',
      'player_title': 'Soccer Player List',
      'add_player': 'Add Player',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'address': 'Address',
      'date_of_birth': 'Date of Birth',
      'team_id': 'Team ID',
      'copy_previous_player': 'Copy from previous player?',
      'player_added': 'Player added successfully',
      'player_updated': 'Player updated successfully',
      'player_deleted': 'Player deleted successfully',
      'game_title': 'Soccer Game List',
      'add_game': 'Add Game',
      'game_date': 'Game Date',
      'stadium_id': 'Stadium ID',
      'team1_id': 'Team 1 ID',
      'team2_id': 'Team 2 ID',
      'copy_previous_game': 'Copy from previous game?',
      'game_added': 'Game added successfully',
      'game_updated': 'Game updated successfully',
      'game_deleted': 'Game deleted successfully',
      'help_text_game': 'Use the form to add a new game. Click on a game in the list to update or delete it. You can copy details from the last added game.',
    },
    'fr_FR': {
      'home_player_button': 'Page des joueurs',
      'home_team_button': 'Page des équipes',
      'home_game_button': 'Page des matchs',
      'app_title': 'Projet final - Football',
      'title': 'Liste des équipes de football',
      'add_team': 'Ajouter une équipe',
      'team_name': "Nom de l'équipe",
      'stadium': 'Stade',
      'city': 'Ville',
      'image_url': "URL de l'image (http://)",
      'submit': 'Soumettre',
      'update': 'Mettre à jour',
      'delete': 'Supprimer',
      'copy_previous': 'Copier depuis le précédent ?',
      'yes': 'Oui',
      'no': 'Non',
      'help': "Instructions d'aide",
      'help_text': "Utilisez le formulaire pour ajouter une nouvelle équipe. Cliquez sur une équipe dans la liste pour la modifier ou la supprimer. Vous pouvez copier les informations de la dernière équipe ajoutée.",
      'error_fields': 'Veuillez remplir tous les champs',
      'team_added': 'Équipe ajoutée avec succès',
      'team_updated': 'Équipe mise à jour avec succès',
      'team_deleted': 'Équipe supprimée avec succès',
      'color': 'Couleur',
      'player_title': 'Liste des joueurs de football',
      'add_player': 'Ajouter un joueur',
      'first_name': 'Prénom',
      'last_name': 'Nom de famille',
      'address': 'Adresse',
      'date_of_birth': 'Date de naissance',
      'team_id': "ID de l'équipe",
      'copy_previous_player': 'Copier depuis le joueur précédent ?',
      'player_added': 'Joueur ajouté avec succès',
      'player_updated': 'Joueur mis à jour avec succès',
      'player_deleted': 'Joueur supprimé avec succès',
      'game_title': 'Liste des matchs de football',
      'add_game': 'Ajouter un match',
      'game_date': 'Date du match',
      'stadium_id': 'ID du stade',
      'team1_id': "ID de l'équipe 1",
      'team2_id': "ID de l'équipe 2",
      'copy_previous_game': 'Copier depuis le match précédent ?',
      'game_added': 'Match ajouté avec succès',
      'game_updated': 'Match mis à jour avec succès',
      'game_deleted': 'Match supprimé avec succès',
      'help_text_game': 'Utilisez le formulaire pour ajouter un nouveau match. Cliquez sur un match dans la liste pour le modifier ou le supprimer. Vous pouvez copier les informations du dernier match ajouté.',
    },
  };

  /// Translates the given [key] to the current language based on [locale].
  /// 
  /// If the current locale or key is not found, it defaults to 'en_US'.
  String translate(String key) {
    String langCode = '${locale.languageCode}_${locale.countryCode}';
    if (!_localizedValues.containsKey(langCode)) {
      langCode = 'en_US'; // Fallback to US English
    }
    return _localizedValues[langCode]?[key] ?? key;
  }
}

/// Delegate for [AppLocalizations].
/// 
/// This class is used by Flutter to load the [AppLocalizations] instance
/// when the locale changes.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  /// Creates a new [AppLocalizationsDelegate] instance.
  const AppLocalizationsDelegate();

  /// Checks if the provided [locale] is supported by this delegate.
  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  /// Loads the [AppLocalizations] for the given [locale].
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  /// Determines if the delegate should reload when the widget is rebuilt.
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
