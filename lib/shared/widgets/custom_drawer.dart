// ignore_for_file: prefer_const_constructors

import 'package:firebase/pages/tarefas/tarefas_page.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Gabriel Saturi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            accountEmail: Text(
              'Gabriel@example.com',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.grey[600],
              child: Text(
                'GS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.teal, // Consistente com o tema do app
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined, color: Colors.teal),
            title: const Text(
              'Tarefas',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TarefasPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.teal),
            title: const Text(
              'Configurações',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.teal),
            title: const Text(
              'Sair',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
