import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/outfit_grid_widget.dart';

class SeeOutfitsScreen extends StatefulWidget {
  const SeeOutfitsScreen({super.key});

  @override
  State<SeeOutfitsScreen> createState() => _SeeOutfitsScreenState();
}

class _SeeOutfitsScreenState extends State<SeeOutfitsScreen> {
  String? selectedCategory;
  bool isLoading = true;
  List<Map<String, dynamic>> outfits = [];

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

    await Future.delayed(Duration(milliseconds: 500));

    final mockOutfits = [
      {
        'id': '1',
        'name': 'Casual Look',
        'category': 'Casual',
        'image_url': 'https://picsum.photos/300/400?random=1',
      },
      {
        'id': '2',
        'name': 'Formal Attire',
        'category': 'Formal',
        'image_url': 'https://picsum.photos/300/400?random=2',
      },
      {
        'id': '3',
        'name': 'Sport Outfit',
        'category': 'Sport',
        'image_url': 'https://picsum.photos/300/400?random=3',
      },
      {
        'id': '4',
        'name': 'Party Style',
        'category': 'Party',
        'image_url': 'https://picsum.photos/300/400?random=4',
      },
      {
        'id': '5',
        'name': 'Weekend Casual',
        'category': 'Casual',
        'image_url': 'https://picsum.photos/300/400?random=5',
      },
      {
        'id': '6',
        'name': 'Business Formal',
        'category': 'Formal',
        'image_url': 'https://picsum.photos/300/400?random=6',
      },
    ];

    setState(() {
      outfits = mockOutfits;
      isLoading = false;
    });
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
      appBar: AppBar(title: Text('Ver las Pintas')),
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
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected
                            ? (category == 'All' ? null : category)
                            : null;
                      });
                    },
                    selectedColor: Colors.orange.withOpacity(0.3),
                    checkmarkColor: Colors.orange,
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
