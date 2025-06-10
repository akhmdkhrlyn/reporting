import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reporting/providers/task_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:reporting/widgets/splash_screen.dart';
import 'package:reporting/widgets/sign_in.dart';
import 'package:reporting/pages/home_screen.dart';
// ... import lainnya

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: _isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              if (snapshot.data == true) {
                return const HomeScreen();
              } else {
                return const SplashScreen();
              }
            }
          },
        ),
        routes: {
          '/sign_in': (context) => const SignInWidget(),
          // ... rute lainnya
        },
      ),
    );
  }
}
