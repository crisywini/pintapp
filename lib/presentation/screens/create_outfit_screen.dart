import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/outfit_builder_widget.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/overlay_utils.dart';
import 'package:pintapp/config/helpers/local_get_items_helper.dart';
import 'package:pintapp/config/helpers/local_add_outfit_helper.dart';

class CreateOutfitScreen extends StatefulWidget {
  const CreateOutfitScreen({super.key});

  @override
  State<CreateOutfitScreen> createState() => _CreateOutfitScreenState();
}

class _CreateOutfitScreenState extends State<CreateOutfitScreen> {
  bool isOutfitSaved = false;
  bool isLoading = true;
  final LocalGetItemsHelper _itemsHelper = LocalGetItemsHelper();
  final LocalAddOutfitHelper _outfitHelper = LocalAddOutfitHelper();

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
      final imagePath = item['imagePath'] as String? ?? item['image_url'] as String? ?? '';
      return imagePath;
    }).toList();
  }

  Future<void> _handleOutfitCreation(Map<String, dynamic> outfitPayload) async {
    final outfitData = await _showOutfitNameDialog();

    if (outfitData == null || outfitData['name'] == null || outfitData['name'].trim().isEmpty) {
      return;
    }

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
        name: outfitData['name'].trim(),
        category: outfitData['category'],
        items: selectedItems,
      );

      print('Outfit saved successfully: $result');

      OverlayUtils.showSuccess(
        "Outfit '${outfitData['name']}' guardado exitosamente",
        context,
      );

      setState(() {
        isOutfitSaved = true;
      });
    } catch (e) {
      print('Error saving outfit: $e');
      OverlayUtils.showError(
        'Error guardando outfit: ${e.toString()}',
        context,
      );
    }
  }

  Future<Map<String, dynamic>?> _showOutfitNameDialog() async {
    final TextEditingController nameController = TextEditingController();
    final List<String> categories = ['Casual', 'Formal', 'Sport', 'Gym'];
    String selectedCategory = categories[0];

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Crear Outfit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Outfit',
                      hintText: 'Ingresa el nombre del outfit',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      }
                    },
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
                              Navigator.of(context).pop({
                                'name': name,
                                'category': selectedCategory.toLowerCase(),
                              });
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
