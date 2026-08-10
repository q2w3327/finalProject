import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'localization.dart';
import 'pages/soccer_team_list_page.dart';
import 'pages/soccer_player_list_page.dart';

/// The entry point of the application.
/// 
/// Initializes the Flutter bindings and the [EncryptedSharedPreferences]
/// with a secret key before running the app.
void main() async {
  // Ensure that plugin services are initialized so that `EncryptedSharedPreferences` 
  // can be used before `runApp`.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the encrypted preferences with a secret key for security.
  await EncryptedSharedPreferences.initialize("secret_key_123456");
  
  runApp(const MyApp());
}

/// The root widget of the application.
/// 
/// Manages the global [Locale] and sets up the [MaterialApp] with 
/// localization and theme.
class MyApp extends StatefulWidget {
  /// Creates a new [MyApp] instance.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

/// The state for [MyApp].
class _MyAppState extends State<MyApp> {
  /// The current locale of the application. Defaults to US English.
  Locale _locale = const Locale('en', 'US');

  /// Updates the application's locale.
  /// 
  /// This method is called by child widgets to switch the language.
  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Final Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Set the current locale.
      locale: _locale,
      // Define localization delegates to handle translations.
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // List the supported locales for the app.
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      // The initial page shown to the user.
      home: MainLandingPage(onChangeLanguage: changeLanguage),
    );
  }
}

/// The landing page of the entire application.
/// 
/// Contains buttons to navigate to the four different project topics.
class MainLandingPage extends StatelessWidget {
  /// Callback function to change the application language.
  final Function(Locale) onChangeLanguage;

  /// Creates a new [MainLandingPage] instance.
  const MainLandingPage({super.key, required this.onChangeLanguage});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('app_title')),
        actions: [
          // Language selector in the AppBar.
          PopupMenuButton<Locale>(
            onSelected: onChangeLanguage,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('en', 'US'),
                child: Text('English (US)'),
              ),
              const PopupMenuItem(
                value: Locale('fr', 'FR'),
                child: Text('Français'),
              ),
            ],
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Button for the Soccer Player Page.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SoccerPlayerListPage()),
                );
              },
              child: Text(l10n.translate('home_player_button')),
            ),
            const SizedBox(height: 10),
            // Button to navigate to the Soccer Team List Page.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SoccerTeamListPage()),
                );
              },
              child: Text(l10n.translate('home_team_button')),
            ),
            const SizedBox(height: 10),
            // Button for the Soccer Game List Page (Placeholder).
            ElevatedButton(
              onPressed: () {},
              child: Text(l10n.translate('home_game_button')),
            ),
          ],
        ),
      ),
    );
  }
}
