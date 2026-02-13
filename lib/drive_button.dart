import 'package:flutter/material.dart';

class DriveButton extends StatelessWidget {
  final double buttonTop;
  final double buttonRight;

  const DriveButton({
    Key? key,
    this.buttonTop = 4.0,
    this.buttonRight = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: buttonTop,
      right: buttonRight,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/drive');
        },
        child: Container(
          width: 64, // 16 * 4 (assuming 1 unit = 4 pixels, adjust as needed)
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF878787),
            border: Border.all(
              color: const Color(0xFF3C3C3C),
              width: 6,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'D',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}