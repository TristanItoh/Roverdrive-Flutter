import 'package:flutter/material.dart';

class Story extends StatelessWidget {
  const Story({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Story',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
