import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/full_screen_image_view.dart';

class OutfitGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> outfits;

  const OutfitGridWidget({super.key, required this.outfits});

  int _getCrossAxisCount(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;

    if (orientation == Orientation.landscape) {
      return width > 1200 ? 3 : 2;
    } else {
      return width > 600 ? 2 : 2;
    }
  }

  void _openFullScreenImage(
    BuildContext context,
    String imageUrl,
    String outfitName,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImageView(imageUrl: imageUrl, title: outfitName),
      ),
    );
  }

  Widget _buildOutfitImage(Map<String, dynamic> outfit) {
    final imageUrl = outfit['image_url'] ?? '';
    final items = outfit['items'] as List<dynamic>? ?? [];

    // Try to show composite image first
    if (imageUrl.isNotEmpty) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // If composite image fails, try to show first item image
          return _buildFallbackImage(items);
        },
      );
    }

    // If no composite image, show fallback
    return _buildFallbackImage(items);
  }

  Widget _buildFallbackImage(List<dynamic> items) {
    // Try to find the first item with a valid image path
    for (final item in items) {
      if (item is Map<String, dynamic>) {
        final itemImagePath = item['imagePath'] ?? item['image_url'] ?? '';
        if (itemImagePath.isNotEmpty) {
          return Image.file(
            File(itemImagePath),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderImage();
            },
          );
        }
      }
    }

    // If no valid images found, show placeholder
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checkroom,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'Imagen no disponible',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checkroom, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay outfits disponibles',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontFamily: "Bebas Neue",
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.4,
        ),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          final imageUrl = outfit['image_url'] ?? '';
          final name = outfit['name'] ?? 'Outfit';
          final category = outfit['category'] ?? '';

          return GestureDetector(
            onTap: () => _openFullScreenImage(context, imageUrl, name),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: _buildOutfitImage(outfit),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: "Bebas Neue",
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (category.isNotEmpty) ...[
                          SizedBox(height: 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.black,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
