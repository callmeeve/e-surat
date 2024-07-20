import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadCamera extends StatefulWidget {
  const UploadCamera({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadCameraState createState() => _UploadCameraState();
}

class _UploadCameraState extends State<UploadCamera> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    // Upload image to server
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_image != null) ...[
          Image.file(
            _image!,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              title: Text(
                'Upload',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.upload),
                onPressed: _uploadImage,
              ),
            ),
          ),
        ] else ...[
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: ListTile(
              title: Text(
                'Upload Foto',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: _getImage,
              ),
            ),
          ),
        ]
      ],
    );
  }
}
