import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _locationController = TextEditingController();
  final _subtitleController = TextEditingController();
  String? imagePath;

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  void _submit() async {
    if (_nameController.text.isNotEmpty &&
        _brandController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _subtitleController.text.isNotEmpty) {
      final data = {
        'name': _nameController.text,
        'brand': _brandController.text,
        'location': _locationController.text,
        'subtitle': _subtitleController.text,
        'imagePath': imagePath,
        'date': DateTime.now().toString().split(' ')[0],
      };

      // Save to SQLite
      await DatabaseHelper.instance.insert(data);

      Navigator.pop(context, data); // ส่งกลับข้อมูลไปยัง Homepage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imagePath != null
                ? Image.file(File(imagePath!), height: 100)
                : const Icon(Icons.image, size: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: 'Subtitle'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
