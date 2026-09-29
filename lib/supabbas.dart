import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Supabbas extends StatefulWidget {
  const Supabbas({super.key});

  @override
  State<Supabbas> createState() => _SupabbasState();
}

class _SupabbasState extends State<Supabbas> {
  bool isBusy = false;

  File? _imageFile;

  // Pick image
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  // Upload image
  Future<void> uploadImage() async {
    if (_imageFile == null) return;

    setState(() => isBusy = true);

    try {
      final fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final path = 'uploads/$fileName';

      await Supabase.instance.client.storage
          .from('images')
          .upload(path, _imageFile!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Supabase Image Upload'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Image Preview Card (CustomContainer)
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'No Image Selected',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 30),

            /// Pick Image Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Upload Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isBusy
                    ? null
                    : () {
                        uploadImage();
                      },
                icon: const Icon(Icons.cloud_upload),
                label: isBusy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
