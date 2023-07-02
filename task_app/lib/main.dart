import 'package:flutter/material.dart';
import 'package:task_app/src/pages/task_details_page.dart';
import 'package:task_app/src/pages/task_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
        ],
        title: 'Material App',
        initialRoute: 'task',
        routes: {
          'task': (context) => TaskPage(),
          'add_task': (context) => TaskDetailsPage(),
        });
  }
}
