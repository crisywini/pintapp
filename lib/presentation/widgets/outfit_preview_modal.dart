import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

class OutfitPreviewModal extends StatefulWidget {
  final Map<String, dynamic> outfit;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const OutfitPreviewModal({
    super.key,
    required this.outfit,
    this.onDelete,
    this.onUpdate,
  });

  @override
  State<OutfitPreviewModal> createState() => _OutfitPreviewModalState();
}

class _OutfitPreviewModalState extends State<OutfitPreviewModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeModal() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  Widget _buildOutfitImage() {
    final imageUrl = widget.outfit['image_url'] ?? '';
    final items = widget.outfit['items'] as List<dynamic>? ?? [];

    if (imageUrl.isNotEmpty && File(imageUrl).existsSync()) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.contain,
      );
    }

    // Fallback to first item image
    for (final item in items) {
      if (item is Map<String, dynamic>) {
        final itemImagePath = item['imagePath'] ?? item['image_url'] ?? '';
        if (itemImagePath.isNotEmpty && File(itemImagePath).existsSync()) {
          return Image.file(
            File(itemImagePath),
            fit: BoxFit.contain,
          );
        }
      }
    }

    // Placeholder if no image
    return Icon(
      Icons.checkroom,
      size: 100,
      color: Colors.white54,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.outfit['name'] ?? 'Outfit';
    final category = widget.outfit['category'] ?? '';

    return GestureDetector(
      onTap: _closeModal,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),

              // Content
              Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when tapping on content
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with title and menu button
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Bebas Neue",
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (category.isNotEmpty) ...[
                                        SizedBox(height: 4),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                // Three-dot menu button
                                IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: _toggleMenu,
                                ),
                              ],
                            ),
                          ),

                          // Image
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: _buildOutfitImage(),
                              ),
                            ),
                          ),

                          // Menu options (slide in from bottom)
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: _showMenu ? null : 0,
                            child: _showMenu
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        if (widget.onUpdate != null)
                                          ListTile(
                                            leading: Icon(Icons.edit, color: Colors.blue),
                                            title: Text(
                                              'Actualizar',
                                              style: TextStyle(
                                                fontFamily: "Bebas Neue",
                                                fontSize: 16,
                                              ),
                                            ),
                                            onTap: () {
                                              _closeModal();
                                              widget.onUpdate?.call();
                                            },
                                          ),
                                        if (widget.onDelete != null)
                                          ListTile(
                                            leading: Icon(Icons.delete, color: Colors.red),
                                            title: Text(
                                              'Eliminar',
                                              style: TextStyle(
                                                fontFamily: "Bebas Neue",
                                                fontSize: 16,
                                                color: Colors.red,
                                              ),
                                            ),
                                            onTap: () {
                                              _closeModal();
                                              _showDeleteConfirmation();
                                            },
                                          ),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Close button at top
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: _closeModal,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '¿Eliminar outfit?',
          style: TextStyle(
            fontFamily: "Bebas Neue",
            fontSize: 20,
          ),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${widget.outfit['name']}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(
              'Eliminar',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
