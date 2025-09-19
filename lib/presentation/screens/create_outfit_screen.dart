import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/outfit_builder_widget.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/overlay_utils.dart';
import 'package:pintapp/config/helpers/get_items_helper.dart';
import 'package:pintapp/config/helpers/add_outfit_helper.dart';
import 'package:pintapp/config/constants.dart';

class CreateOutfitScreen extends StatefulWidget {
  const CreateOutfitScreen({super.key});

  @override
  State<CreateOutfitScreen> createState() => _CreateOutfitScreenState();
}

class _CreateOutfitScreenState extends State<CreateOutfitScreen> {
  bool isOutfitSaved = false;
  bool isLoading = true;
  final GetItemsHelper _itemsHelper = GetItemsHelper();
  final AddOutfitHelper _outfitHelper = AddOutfitHelper();

  List<Map<String, dynamic>> topItems = [];
  List<Map<String, dynamic>> pantsItems = [];
  List<Map<String, dynamic>> shoeItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final results = await Future.wait([
        _itemsHelper.getItemsByCategory('shirts'),
        _itemsHelper.getItemsByCategory('pants'),
        _itemsHelper.getItemsByCategory('shoes'),
      ]);

      setState(() {
        topItems = _extractItems(results[0]);
        pantsItems = _extractItems(results[1]);
        shoeItems = _extractItems(results[2]);
        isLoading = false;
      });
    } catch (e) {
      print('Error loading items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _extractItems(dynamic response) {
    if (response is Map<String, dynamic> && response['success'] == false) {
      return [];
    }

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }

    if (response is Map<String, dynamic> &&
        response.containsKey('items') &&
        response['items'] is List) {
      return List<Map<String, dynamic>>.from(response['items']);
    }

    return [];
  }

  List<String> _extractImageUrls(List<Map<String, dynamic>> items) {
    return items.map((item) {
      final imageUrl = item['image_url'] as String? ?? '';
      if (imageUrl.startsWith('images/')) {
        return '${APIConstants.baseUrl}$imageUrl';
      }
      return imageUrl;
    }).toList();
  }

  Future<void> _handleOutfitCreation(Map<String, dynamic> outfitPayload) async {
    final outfitName = await _showOutfitNameDialog();

    if (outfitName == null || outfitName.trim().isEmpty) {
      return;
    }

    // Show loading overlay
    final loadingOverlay = OverlayUtils.showLoading(
      "Guardando pinta...",
      context,
    );

    try {
      final topIndex = outfitPayload['top']['index'] as int;
      final pantsIndex = outfitPayload['pants']['index'] as int;
      final shoeIndex = outfitPayload['shoes']['index'] as int;

      final selectedItems = [
        topItems[topIndex],
        pantsItems[pantsIndex],
        shoeItems[shoeIndex],
      ];

      final result = await _outfitHelper.postAddOutfit(
        name: outfitName.trim(),
        category: 'casual',
        items: selectedItems,
      );

      // Remove loading overlay
      loadingOverlay.remove();

      print('Outfit saved successfully: $result');

      OverlayUtils.showSuccess(
        "Outfit '$outfitName' guardado exitosamente",
        context,
      );

      setState(() {
        isOutfitSaved = true;
      });
    } catch (e) {
      // Remove loading overlay
      loadingOverlay.remove();

      print('Error saving outfit: $e');
      OverlayUtils.showError(
        'Error guardando outfit: ${e.toString()}',
        context,
      );
    }
  }

  Future<String?> _showOutfitNameDialog() async {
    final TextEditingController nameController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nombre del Outfit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Ingresa el nombre del outfit',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButtonGestureDetector(
                      imageUrl: "",
                      valueName: "Cancelar",
                      onPressed: () => Navigator.of(context).pop(null),
                      color: const Color.fromARGB(255, 144, 39, 32),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomButtonGestureDetector(
                      imageUrl: "",
                      valueName: "Guardar",
                      onPressed: () {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          Navigator.of(context).pop(name);
                        }
                      },
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Crearse la Pinta')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final topImages = _extractImageUrls(topItems);
    final pantsImages = _extractImageUrls(pantsItems);
    final shoeImages = _extractImageUrls(shoeItems);

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
