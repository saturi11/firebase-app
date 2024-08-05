// ignore_for_file: prefer_const_constructors

import 'package:firebase/pages/splash_screen/splash_user.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4A90E2),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF4A90E2),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF50E3C2),
          onSecondary: Color(0xFF000000),
        ),
        scaffoldBackgroundColor: Color(0xFFF0F2F5),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4A90E2),
          iconTheme: IconThemeData(
            color: Color(0xFFFFFFFF),
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4A90E2),
            foregroundColor: Color(0xFFFFFFFF),
            minimumSize: Size(double.infinity, 48.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFF333333),
            fontSize: 16.0,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14.0,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const SplashUser(),
    );
  }
}
