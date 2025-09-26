import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/outfit_grid_widget.dart';
import 'package:pintapp/config/helpers/local_get_all_outfits_helper.dart';

class SeeOutfitsScreen extends StatefulWidget {
  const SeeOutfitsScreen({super.key});

  @override
  State<SeeOutfitsScreen> createState() => _SeeOutfitsScreenState();
}

class _SeeOutfitsScreenState extends State<SeeOutfitsScreen> {
  String? selectedCategory;
  bool isLoading = true;
  List<Map<String, dynamic>> outfits = [];
  final LocalGetAllOutfitsHelper _outfitsHelper = LocalGetAllOutfitsHelper();

  final List<String> categories = ['All', 'Casual', 'Formal', 'Sport', 'Party'];

  @override
  void initState() {
    super.initState();
    _loadOutfits();
  }

  Future<void> _loadOutfits() async {
    setState(() {
      isLoading = true;
    });

    try {
      dynamic response;
      response = await _outfitsHelper.getAllOutfits();

      final List<Map<String, dynamic>> loadedOutfits = _extractOutfits(response);

      setState(() {
        outfits = loadedOutfits;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading outfits: $e');
      setState(() {
        outfits = [];
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _extractOutfits(dynamic response) {
    if (response is Map<String, dynamic> && response['success'] == false) {
      return [];
    }

    if (response is List) {
      return response.map((outfit) => _transformOutfit(outfit)).toList();
    }

    if (response is Map<String, dynamic> &&
        response.containsKey('outfits') &&
        response['outfits'] is List) {
      return List<Map<String, dynamic>>.from(
          response['outfits'].map((outfit) => _transformOutfit(outfit)));
    }

    return [];
  }

  Map<String, dynamic> _transformOutfit(dynamic outfit) {
    if (outfit is Map<String, dynamic>) {
      final String imageUrl = outfit['image_url'] ?? outfit['default_image_url'] ?? outfit['default_image'] ?? '';

      return {
        'id': outfit['id']?.toString() ?? '',
        'name': outfit['name'] ?? 'Outfit',
        'category': outfit['category'] ?? '',
        'image_url': imageUrl,
        'items': outfit['items'] ?? [],
        'pictures_urls': outfit['pictures_urls'] ?? [],
      };
    }
    return {
      'id': '',
      'name': 'Outfit',
      'category': '',
      'image_url': '',
      'items': [],
      'pictures_urls': [],
    };
  }

  List<Map<String, dynamic>> get filteredOutfits {
    if (selectedCategory == null || selectedCategory == 'All') {
      return outfits;
    }
    return outfits
        .where((outfit) => outfit['category'] == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver las Pintas'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected =
                    selectedCategory == category ||
                    (selectedCategory == null && category == 'All');

                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected
                            ? (category == 'All' ? null : category)
                            : null;
                      });
                      _loadOutfits();
                    },
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.white,
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : OutfitGridWidget(outfits: filteredOutfits),
          ),
        ],
      ),
    );
  }
}
