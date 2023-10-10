import 'package:flutter/material.dart';
import 'dart:io';
import '../ThemeProvider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'image_display_screen.dart'; // Assuming this is where AdditionalInfoForm is located

class PhotoReviewPage extends StatefulWidget {
  String imagePath;

  PhotoReviewPage({required this.imagePath});

  @override
  _PhotoReviewPageState createState() => _PhotoReviewPageState();
}

class _PhotoReviewPageState extends State<PhotoReviewPage> {
  @override
  void initState() {
    super.initState();
    _cropImage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Empty container since you don't want to show this page
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper().cropImage(
      sourcePath: widget.imagePath,
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 12),
      compressQuality: 100,
      maxWidth: 700,
      maxHeight: 700,
      compressFormat: ImageCompressFormat.png,
      cropStyle: CropStyle.rectangle,
      androidUiSettings: AndroidUiSettings(
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(),
    );

    if (croppedFile != null) {
      widget.imagePath = croppedFile.path;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdditionalInfoForm(imagePath: widget.imagePath),
        ),
      );
    } else {
      Navigator.pop(context); // Return to the previous page if the user cancels the cropping
    }
  }
}
