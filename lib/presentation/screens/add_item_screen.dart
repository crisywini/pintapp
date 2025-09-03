import 'package:flutter/material.dart';
import 'package:pintapp/presentation/widgets/add_item_form_widget.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Ropita')),
      body: AddItemFormWidget(),
    );
  }
}
