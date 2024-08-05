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
        primaryColor: Color(0xFF3F51B5), // Azul escuro (Material Design)
        colorScheme: ColorScheme.light(
          primary: Color(0xFF3F51B5), // Azul escuro (Material Design)
          onPrimary: Color(0xFFFFFFFF), // Branco
          secondary: Color(0xFF00BCD4), // Azul claro (Material Design)
          onSecondary: Color(0xFFFFFFFF), // Branco
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // Cinza claro
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF3F51B5), // Azul escuro (Material Design)
          iconTheme: IconThemeData(
            color: Color(0xFFFFFFFF), // Branco
          ),
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFFFF), // Branco
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3F51B5), // Azul escuro (Material Design)
            foregroundColor: Color(0xFFFFFFFF), // Branco
            minimumSize: Size(double.infinity, 48.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFF333333), // Cinza escuro
            fontSize: 16.0,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF666666), // Cinza médio
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
