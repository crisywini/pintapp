import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final createOutfitDetector = _CustomGestureDetector(
      imageUrl: "",
      valueName: 'Crearse la pinta',
      onPressed: () => print('Crearse la pinta'),
      color: Colors.blue,
    );
    final addItemsDetector = _CustomGestureDetector(
      imageUrl: "",
      valueName: 'Añadir ropa',
      onPressed: () => print('Añadir ropa'),
      color: Colors.red,
    );
    final seeOutfits = _CustomGestureDetector(
      imageUrl: "",
      valueName: 'Ver las pintas',
      onPressed: () => print('Ver las pintas'),
      color: Colors.orange,
    );

    return Column(
      children: [
        createOutfitDetector,
        SizedBox(height: 20),
        addItemsDetector,
        SizedBox(height: 20),

        seeOutfits,
      ],
    );
  }
}

class _CustomGestureDetector extends StatelessWidget {
  final String imageUrl;

  final String valueName;

  final VoidCallback onPressed;

  final Color color;

  const _CustomGestureDetector({
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
        minimumSize: Size(400, 200),
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
