import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectImageWidget extends StatefulWidget {
  SelectImageWidget({super.key});

  @override
  State<StatefulWidget> createState() => _SelectImageWidgetState();
}

class _SelectImageWidgetState extends State<SelectImageWidget> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {_pickImage()},
      child: Container(
        height: 200,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: _imagePath == null
            ? Icon(Icons.add_a_photo)
            : Image.file(File(_imagePath!)),
      ),
    );
  }

  Future<void> _pickImage() async {
    final PermissionStatus cameraStatus = await Permission.camera.request();
    final PermissionStatus photosStatus = await Permission.photos.request();

    print('Camera status: $cameraStatus');
    print('Photos status: $photosStatus');

    if (cameraStatus.isGranted) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
        );
        if (image != null) {
          setState(() {
            _imagePath = image.path;
          });
        }
      } catch (e) {
        print('Error: $e');
        _showError('Error al tomar la foto: $e');
      }
    } else {
      _showPermissionDialog();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permiso requerido"),
        content: Text(
          'Para tomar fotos necesitamos acceso a la cámara. Ve a configuración y habilita el permiso',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Configuración'),
          ),
        ],
      ),
    );
  }
}
