import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/product_provider.dart';
import 'providers/customer_provider.dart';
import 'providers/reports_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SmartPosApp());
}

class SmartPosApp extends StatelessWidget {
  const SmartPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => ReportsProvider()),
      ],
      child: MaterialApp(
        title: 'Smart POS',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final user = snapshot.data;
            if (user == null) return const LoginScreen();
            // start sync service for signed in user
            SyncService().start();
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
