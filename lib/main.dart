import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reporting/providers/task_provider.dart';

import 'package:reporting/widgets/splash_screen.dart';
import 'package:reporting/widgets/sign_in.dart';
import 'package:reporting/widgets/sign_up.dart';
import 'package:reporting/widgets/forgot_password.dart';

import 'package:reporting/pages/home_screen.dart';
import 'package:reporting/pages/task_screen.dart';
import 'package:reporting/pages/add_task_screen.dart';
import 'package:reporting/pages/graphic_screen.dart';
import 'package:reporting/pages/checklist_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/sign_in': (context) => const SignInWidget(),
          '/sign_up': (context) => const SignupWidget(),
          '/home': (context) => const HomeScreen(),
          '/task': (context) => const TaskScreen(),
          '/add': (context) => const AddTaskScreen(),
          '/graphic': (context) => const GraphicScreen(),
          '/checklist': (context) => const ChecklistScreen(),
          '/forgot_password': (context) => const ForgotPassword(),
        },
      ),
    );
  }
}
