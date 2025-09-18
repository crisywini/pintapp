import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/scrollable_item_widget.dart';

class OutfitBuilderWidget extends StatefulWidget {
  final List<String> topImages;
  final List<String> pantsImages;
  final List<String> shoeImages;
  final Function(Map<String, dynamic>)? onCreateOutfit;

  const OutfitBuilderWidget({
    super.key,
    required this.topImages,
    required this.pantsImages,
    required this.shoeImages,
    this.onCreateOutfit,
  });

  @override
  State<OutfitBuilderWidget> createState() => _OutfitBuilderWidgetState();
}

class _OutfitBuilderWidgetState extends State<OutfitBuilderWidget> {
  int selectedTopIndex = 0;
  int selectedPantsIndex = 0;
  int selectedShoeIndex = 0;

  void _handleSaveOutfit() {
    final outfitPayload = {
      'top': {
        'index': selectedTopIndex,
        'imageUrl': widget.topImages[selectedTopIndex],
      },
      'pants': {
        'index': selectedPantsIndex,
        'imageUrl': widget.pantsImages[selectedPantsIndex],
      },
      'shoes': {
        'index': selectedShoeIndex,
        'imageUrl': widget.shoeImages[selectedShoeIndex],
      },
    };

    _showOverlaySuccess("Pinta guardada", context);
    widget.onCreateOutfit?.call(outfitPayload);
    _resetSelection();
  }

  void _resetSelection() {
    setState(() {
      selectedTopIndex = 0;
      selectedPantsIndex = 0;
      selectedShoeIndex = 0;
    });
  }

  void _showOverlaySuccess(String message, BuildContext context) {
    _showOverlay(message, context, Colors.green, Icons.check_circle);
  }

  void _showOverlay(
    String message,
    BuildContext context,
    Color color,
    IconData icon,
  ) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saveFormCustomButton = CustomButtonGestureDetector(
      imageUrl: "",
      valueName: "Guardar",
      onPressed: _handleSaveOutfit,
      color: Colors.green,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 250,
            child: ScrollableItemWidget(
              imagePaths: widget.topImages,
              onImageChanged: (index) {
                setState(() {
                  selectedTopIndex = index;
                });
              },
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: ScrollableItemWidget(
              imagePaths: widget.pantsImages,
              onImageChanged: (index) {
                setState(() {
                  selectedPantsIndex = index;
                });
              },
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ScrollableItemWidget(
              imagePaths: widget.shoeImages,
              onImageChanged: (index) {
                setState(() {
                  selectedShoeIndex = index;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(children: [Expanded(child: saveFormCustomButton)]),
          ),
        ],
      ),
    );
  }
}
