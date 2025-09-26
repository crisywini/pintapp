import 'dart:io';
import 'package:flutter/material.dart';

class ScrollableItemWidget extends StatefulWidget {
  final List<String> imagePaths;
  final Function(int)? onImageChanged;

  const ScrollableItemWidget({
    super.key,
    required this.imagePaths,
    this.onImageChanged,
  });

  @override
  State<StatefulWidget> createState() => _ScrollableItemWidgetState();
}

class _ScrollableItemWidgetState extends State<ScrollableItemWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.imagePaths.length,
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
        widget.onImageChanged?.call(index);
      },
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.file(
            File(widget.imagePaths[index]),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Error loading image',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
