import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/scrollable_item_widget.dart';

class OutfitBuilderWidget extends StatelessWidget {
  final List<String> topImages;
  final List<String> pantsImages;
  final List<String> shoeImages;
  final VoidCallback? onCreateOutfit;

  const OutfitBuilderWidget({
    super.key,
    required this.topImages,
    required this.pantsImages,
    required this.shoeImages,
    this.onCreateOutfit,
  });

  @override
  Widget build(BuildContext context) {
    final saveFormCustomButton = CustomButtonGestureDetector(
      imageUrl: "",
      valueName: "Guardar",
      onPressed: () => print("Save outfit"),
      color: Colors.green,
    );
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: ScrollableItemWidget(imagePaths: topImages),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: ScrollableItemWidget(imagePaths: pantsImages),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ScrollableItemWidget(imagePaths: shoeImages),
          ),

          Padding(padding: EdgeInsets.all(40), child: saveFormCustomButton),
        ],
      ),
    );
  }
}
