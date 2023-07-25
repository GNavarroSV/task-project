import 'package:flutter/material.dart';
import 'package:task_app/src/blocs/provider.dart';
import 'package:task_app/src/pages/login_page.dart';
import 'package:task_app/src/pages/task_details_page.dart';
import 'package:task_app/src/pages/task_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:task_app/src/preferences/preferences.dart';

void main() async {
  final prefs = UserPreferences();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
        ],
        title: 'TaskFlow App',
        initialRoute: 'login',
        routes: {
          'login': (context) => LoginPage(),
          'task': (context) => TaskPage(),
          'add_task': (context) => TaskDetailsPage(),
        },
        theme: ThemeData(primarySwatch: Colors.green),
      ),
    );
  }
}
