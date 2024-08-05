import 'package:firebase/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SplashUser extends StatefulWidget {
  const SplashUser({super.key});

  @override
  State<SplashUser> createState() => _SplashUserState();
}

class _SplashUserState extends State<SplashUser> {
  @override
  void initState() {
    super.initState();
    carregarHome();
  }

  carregarHome() async {
    final prefs = await SharedPreferences.getInstance();
    var uuid = Uuid();
    var userId = prefs.getString('user_id');
    if (userId == null) {
      userId = uuid.v4();
      prefs.setString('user_id', userId);
    }
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
