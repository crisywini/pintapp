import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/select_image_widget.dart';

class AddItemFormWidget extends StatelessWidget {
  const AddItemFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final saveFormCustomButton = CustomButtonGestureDetector(
      imageUrl: "",
      valueName: "Guardar",
      onPressed: () => print("Guardando item"),
      color: Colors.green,
    );
    return Column(
      children: [
        Expanded(child: _FormListViewWidget()),
        Padding(padding: EdgeInsets.all(40), child: saveFormCustomButton),
      ],
    );
  }
}

class _FormListViewWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomAddItemFormWidgetState();
}

class _CustomAddItemFormWidgetState extends State<_FormListViewWidget> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? _category;
  String _color = '';
  String _style = '';
  String _brand = '';
  String _season = '';

  @override
  Widget build(BuildContext context) {
    const List<String> categoryElements = ['Superior', 'Inferior', 'Calzado'];

    return Form(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Nombre",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.bubble_chart),
            ),
            onChanged: (value) => _name = value,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'Categoría',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            value: _category,
            items: categoryElements
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) => setState(() => _category = value),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Color",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cookie),
            ),
            onChanged: (value) => _color = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Estilo",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.shape_line),
            ),
            onChanged: (value) => _style = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Marca",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.branding_watermark),
            ),
            onChanged: (value) => _brand = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Temporada",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.energy_savings_leaf_sharp),
            ),
            onChanged: (value) => _season = value,
          ),
          SizedBox(height: 16),
          SelectImageWidget(),
        ],
      ),
    );
  }
}
