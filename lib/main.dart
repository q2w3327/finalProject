import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'localization.dart';
import 'pages/soccer_team_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EncryptedSharedPreferences.initialize("secret_key_123456");
  runApp(const MyApp());
}

/// The root widget of the application.
class MyApp extends StatefulWidget {
  /// Creates a new [MyApp] instance.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');

  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('en', 'GB'),
      ],
      home: MainLandingPage(onChangeLanguage: changeLanguage),
    );
  }
}

/// The landing page of the entire application.
/// 
/// Contains buttons to navigate to the four different project topics.
class MainLandingPage extends StatelessWidget {
  /// Callback to change the application language.
  final Function(Locale) onChangeLanguage;

  /// Creates a new [MainLandingPage] instance.
  const MainLandingPage({super.key, required this.onChangeLanguage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Final Project - Soccer'),
        actions: [
          PopupMenuButton<Locale>(
            onSelected: onChangeLanguage,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: Locale('en', 'US'),
                child: Text('English (US)'),
              ),
              const PopupMenuItem(
                value: Locale('en', 'GB'),
                child: Text('English (UK)'),
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
            ElevatedButton(
              onPressed: () {},
              child: const Text('Soccer Player Page'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SoccerTeamListPage()),
                );
              },
              child: const Text('Soccer Team List Page'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Soccer Game List Page'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Stadium List Page'),
            ),
          ],
        ),
      ),
    );
  }
}
