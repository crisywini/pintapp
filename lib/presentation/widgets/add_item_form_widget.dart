import 'package:flutter/material.dart';
import 'package:pintapp/infrastructure/models/add_item_request.dart';
import 'package:pintapp/presentation/widgets/button_gesture_detector_widget.dart';
import 'package:pintapp/presentation/widgets/select_image_widget.dart';

class AddItemFormWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _formListKey = GlobalKey<_CustomAddItemFormWidgetState>();

  AddItemFormWidget({super.key});

  void _saveForm(BuildContext context) {
    bool isFormValid = _formKey.currentState?.validate() ?? false;
    bool hasImage = _formListKey.currentState?.imagePath != null;
    if (isFormValid) {
      if (hasImage) {
        var request = AddItemRequest(
          name: _formListKey.currentState!._name!,
          category: _formListKey.currentState!._category!,
          color: _formListKey.currentState!._color!,
          style: _formListKey.currentState!._style!,
          brand: _formListKey.currentState!._brand!,
          season: _formListKey.currentState!._season!,
          imagePath: _formListKey.currentState!.imagePath!,
        );

        _formKey.currentState?.reset();
        _formListKey.currentState!.imagePath = null;
      } else {
        _showOverlayError('Selecciona una imagen', context);
      }
    }
  }

  void _showOverlayError(String message, BuildContext context) {
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
              color: Colors.red,
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
                Icon(Icons.error, color: Colors.white),
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
      valueName: "Guardar",
      onPressed: () => _saveForm(context),
      color: Colors.green,
    );

    return Column(
      children: [
        Expanded(
          child: _FormListViewWidget(key: _formListKey, formKey: _formKey),
        ),
        Padding(padding: EdgeInsets.all(40), child: saveFormCustomButton),
      ],
    );
  }
}

class _FormListViewWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback? onValidationRequired;

  const _FormListViewWidget({
    Key? key,
    required this.formKey,
    this.onValidationRequired,
  });

  @override
  State<StatefulWidget> createState() => _CustomAddItemFormWidgetState();
}

class _CustomAddItemFormWidgetState extends State<_FormListViewWidget> {
  String? _name;
  String? _category;
  String? _color;
  String? _style;
  String? _brand;
  String? _season;
  String? imagePath;

  void _onImageSelected(String? imagePath) {
    setState(() {
      this.imagePath = imagePath;
      print('Imagen seleccionada');
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<String> categoryElements = ['Superior', 'Inferior', 'Calzado'];

    return Form(
      key: widget.formKey,
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
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Nombre es requerido';
              return null;
            },
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
            validator: (value) {
              if (value?.isEmpty ?? true) return "La categoría es requerida";
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Color",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cookie),
            ),
            onChanged: (value) => _color = value,
            validator: (value) {
              if (value?.isEmpty ?? true) return "El color es requerido";
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Estilo",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.shape_line),
            ),
            onChanged: (value) => _style = value,
            validator: (value) {
              if (value?.isEmpty ?? true) return "El estilo es requerido";
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Marca",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.branding_watermark),
            ),
            onChanged: (value) => _brand = value,
            validator: (value) {
              if (value?.isEmpty ?? true) return "La marca es requerida";
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Temporada",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.energy_savings_leaf_sharp),
            ),
            onChanged: (value) => _season = value,
            validator: (value) {
              if (value?.isEmpty ?? true) return "La temporada es requerida";
              return null;
            },
          ),
          SizedBox(height: 16),
          SelectImageWidget(onImageSelected: _onImageSelected),
        ],
      ),
    );
  }
}
