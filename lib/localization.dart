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
    },
    'en_GB': {
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
      'color': 'Colour',
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
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  /// Loads the [AppLocalizations] for the given [locale].
  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  /// Determines if the delegate should reload when the widget is rebuilt.
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
