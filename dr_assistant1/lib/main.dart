import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/database_helper.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('darkMode') ?? false;
  runApp(MyApp(isDark: isDark));
}

class MyApp extends StatefulWidget {
  final bool isDark;
  const MyApp({super.key, required this.isDark});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDark;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDark;
  }

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
    SharedPreferences.getInstance().then((prefs) => prefs.setBool('darkMode', _isDark));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dr. Assistant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
          ),
        ),
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home: WelcomeScreen(onThemeToggle: _toggleTheme),
        );
    }
}
