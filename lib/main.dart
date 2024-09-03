import 'package:carcontrol_mobx/view/home/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HomeApplication());
}

class HomeApplication extends StatelessWidget {
  const HomeApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "HC-05 Controller",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 11),
          bodySmall: TextStyle(fontSize: 9),
        ),
      ),
      home: HomeView(),
    );
  }
}
