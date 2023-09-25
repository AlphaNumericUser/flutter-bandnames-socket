import 'package:flutter/material.dart';

import 'screens/screens.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home_screen',
      routes: {
        'home_screen' :(context) => const HomeScreen()
      },
    );
  }
}
