import 'package:flutter/material.dart';
import 'package:task_app/src/pages/add_task_page.dart';
import 'package:task_app/src/pages/task_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'task',
        routes: {
          'task': (context) => TaskPage(),
          'add_task': (context) => AddTaskPage(),
        });
  }
}
