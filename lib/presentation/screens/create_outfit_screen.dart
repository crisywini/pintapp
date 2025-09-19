import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/outfit_builder_widget.dart';
import 'package:pintapp/config/helpers/get_items_helper.dart';
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

  void _handleOutfitCreation(Map<String, dynamic> outfitPayload) {
    print('Outfit payload to send to backend:');
    print(outfitPayload);

    setState(() {
      isOutfitSaved = true;
    });
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
