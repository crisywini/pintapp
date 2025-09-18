import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/outfit_builder_widget.dart';

class CreateOutfitScreen extends StatefulWidget {
  const CreateOutfitScreen({super.key});

  @override
  State<CreateOutfitScreen> createState() => _CreateOutfitScreenState();
}

class _CreateOutfitScreenState extends State<CreateOutfitScreen> {
  bool isOutfitSaved = false;

  void _handleOutfitCreation(Map<String, dynamic> outfitPayload) {
    print('Outfit payload to send to backend:');
    print(outfitPayload);

    setState(() {
      isOutfitSaved = true;
    });
  }

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
        onCreateOutfit: _handleOutfitCreation,
      ),
    );
  }
}
