import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: _isDark
            ? ThemeData.dark(useMaterial3: true)
            : ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: HomePage(
            isDark: _isDark,
            toggleTheme: _toggleTheme,
            ),
        );
    }
}
