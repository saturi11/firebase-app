import 'package:firebase/shared/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            drawer: CustomDrawer(),
            appBar: AppBar(
              title: const Text('Home Page'),
            ),
            body: Container()));
  }
}
