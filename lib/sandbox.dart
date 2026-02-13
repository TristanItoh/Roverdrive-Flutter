import 'package:flutter/material.dart';

class Sandbox extends StatelessWidget {
  const Sandbox({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Sandbox',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
