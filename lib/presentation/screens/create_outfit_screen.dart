import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/outfit_builder_widget.dart';

class CreateOutfitScreen extends StatelessWidget {
  const CreateOutfitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> topImages = [
      'https://picsum.photos/400/600?random=1',
      'https://picsum.photos/400/600?random=2',
      'https://picsum.photos/400/600?random=3',
    ];

    final List<String> pantsImages = [
      'https://picsum.photos/400/600?random=4',
      'https://picsum.photos/400/600?random=5',
      'https://picsum.photos/400/600?random=6',
    ];

    final List<String> shoeImages = [
      'https://picsum.photos/400/300?random=7',
      'https://picsum.photos/400/300?random=8',
      'https://picsum.photos/400/300?random=9',
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Crearse la Pinta')),
      body: OutfitBuilderWidget(
        topImages: topImages,
        pantsImages: pantsImages,
        shoeImages: shoeImages,
        onCreateOutfit: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Outfit created!')),
          );
        },
      ),
    );
  }
}
