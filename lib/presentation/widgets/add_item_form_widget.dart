import 'package:flutter/material.dart';
import 'package:pintapp/config/helpers/add_item_helper.dart';
import 'package:pintapp/infrastructure/models/add_item_request.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/select_image_widget.dart';

class AddItemFormWidget extends StatefulWidget {
  const AddItemFormWidget({super.key});
  @override
  State<StatefulWidget> createState() => _AddItemFormWidgetState();
}

class _AddItemFormWidgetState extends State<AddItemFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _addItemHelper = AddItemHelper();
  final _selectImageKey = GlobalKey<SelectImageWidgetState>();

  String? _category;
  String? _imagePath;
  bool _isLoading = false;

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
            category: _category!,
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
          _showOverlaySuccess('Item guardado correctamente', context);
        } catch (e) {
          print('Error adding the item ${e.toString()}');
          _showOverlayError('Error al guardar el item', context);
        }
      } else {
        _showOverlayError('Selecciona una imagen', context);
      }
    }
  }

  void _showOverlayError(String message, BuildContext context) {
    _showOverlay(message, context, Colors.red, Icons.error);
  }

  void _showOverlaySuccess(String message, BuildContext context) {
    _showOverlay(message, context, Colors.green, Icons.check_circle);
  }

  void _showOverlay(
    String message,
    BuildContext context,
    Color color,
    IconData icon,
  ) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
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
                  items: ['Superior', 'Inferior', 'Calzado']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return "La categoría es requerida";
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
