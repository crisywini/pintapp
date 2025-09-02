import 'package:flutter/material.dart';

class CustomButtonGestureDetector extends StatelessWidget {
  final String imageUrl;

  final String valueName;

  final VoidCallback onPressed;

  final Color color;

  const CustomButtonGestureDetector({
    super.key,
    required this.imageUrl,
    required this.valueName,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size(400, 50),
        elevation: 4,
      ),
      child: Text(
        valueName,
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Bebas Neue",
          fontSize: 30.0,
        ),
      ),
    );
  }
}
