import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: ElevatedButton(
            child: const Text("Logout"),
            onPressed: () {
              authService.signOut();
            },
          ),
        ),
      ),
    );
  }
}
