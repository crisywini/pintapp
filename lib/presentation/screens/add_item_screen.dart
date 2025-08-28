import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/select_image_widget.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Ropita')),
      body: _CustomAddItemFormWidget(),
    );
  }
}

class _CustomAddItemFormWidget extends StatelessWidget {
  const _CustomAddItemFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: "Nombre",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.bubble_chart),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Categoría",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Color",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.cookie),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Estilo",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.shape_line),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Marca",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.branding_watermark),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: "Temporada",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.energy_savings_leaf_sharp),
          ),
        ),
        SizedBox(height: 16),
        SelectImageWidget(),
      ],
    );
  }
}
