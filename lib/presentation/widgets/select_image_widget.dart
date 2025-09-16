import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageWidget extends StatefulWidget {
  final Function(String?) onImageSelected;

  const SelectImageWidget({Key? key, required this.onImageSelected})
    : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectImageWidgetState();
}

class _SelectImageWidgetState extends State<SelectImageWidget> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('Tomar foto'),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('Seleccionar de la galería'),
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              isDestructiveAction: true,
              child: Text('Cancelar'),
            ),
          ),
        );
      },
      child: Container(
        height: 600,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: _imagePath == null
            ? Icon(Icons.add_a_photo)
            : Image.file(File(_imagePath!)),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _imagePath = image.path;
        });
        widget.onImageSelected(image.path);
      }
    } catch (e) {
      _showError('Error al tomar la foto: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
