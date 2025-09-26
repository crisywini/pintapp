import 'package:flutter/material.dart';
import 'package:pintapp/config/helpers/local_add_item_helper.dart';
import 'package:pintapp/infrastructure/models/add_item_request.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/overlay_utils.dart';
import 'package:pintapp/presentation/widgets/select_image_widget.dart';

class AddItemFormWidget extends StatefulWidget {
  const AddItemFormWidget({super.key});
  @override
  State<StatefulWidget> createState() => _AddItemFormWidgetState();
}

class _AddItemFormWidgetState extends State<AddItemFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _addItemHelper = LocalAddItemHelper();
  final _selectImageKey = GlobalKey<SelectImageWidgetState>();

  String? _category;
  String? _imagePath;
  bool _isLoading = false;

  final Map<String, String> _categoryMapping = {
    'Superior': 'shirts',
    'Pantalones': 'pants',
    'Zapatos': 'shoes',
  };

  void _onImageSelected(String? imagePath) {
    setState(() {
      _imagePath = imagePath;
      print('Image selected: $_imagePath');
    });
  }

  void _saveForm(BuildContext context) async {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    bool hasImage = _imagePath != null && _imagePath!.isNotEmpty;
    if (isFormValid) {
      if (hasImage) {
        try {
          var request = AddItemRequest(
            category: _categoryMapping[_category!]!,
            imagePath: _imagePath!,
          );
          final response = await _addItemHelper.postAddItem(request);
          if (response != null) {
            _formKey.currentState?.reset();
            _selectImageKey.currentState?.resetImage();
            setState(() {
              _imagePath = null;
              _category = null;
              _isLoading = false;
            });
          }
          OverlayUtils.showSuccess('Item guardado correctamente', context);
        } catch (e) {
          print('Error adding the item ${e.toString()}');
          OverlayUtils.showError('Error al guardar el item', context);
        }
      } else {
        OverlayUtils.showError('Selecciona una imagen', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveFormCustomButton = CustomButtonGestureDetector(
      imageUrl: "",
      valueName: _isLoading ? "Guardando..." : "Guardar",
      onPressed: () => _saveForm(context),
      color: _isLoading ? Colors.grey : Colors.green,
    );

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                SelectImageWidget(
                  key: _selectImageKey,
                  onImageSelected: _onImageSelected,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  value: _category,
                  items: _categoryMapping.keys
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return "La categoría es requerida";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.all(40), child: saveFormCustomButton),
      ],
    );
  }
}
