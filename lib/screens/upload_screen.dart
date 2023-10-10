import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'photoReview_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  File? _image;
  final TextEditingController emailController = TextEditingController(); // Added this to match the first code's structure
  String? meterType; // Added this to match the first code's structure

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getImage(); // Page rendering is complete, directly call getImage
    });
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    if (_image != null) {
      // If _image is not null, navigate to ImageDisplayScreen immediately
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoReviewPage(imagePath: _image!.path),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Image Picker'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo, color: Colors.white), // Matched the icon and color with the first code
      ),
    );
  }
}
