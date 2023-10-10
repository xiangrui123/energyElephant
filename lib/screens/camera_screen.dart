import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'photoReview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  String? imagePath;
  bool? isShow = true;
  final TextEditingController emailController = TextEditingController();
  String? meterType;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeController();
  }

  Future<void> _initializeController() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    return await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (imagePath != null) {
              // 如果 imagePath 不为 null，立即导航到 PhotoReviewPage
              Future.microtask(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoReviewPage(imagePath: imagePath!),
                  ),
                );
              });
            }
            return Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: CameraPreview(_controller),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();
              setState(() {
                imagePath = image.path;
              });
            } catch (e) {
              print("Error taking picture: $e");
            }
          },
          child: Icon(Icons.add_a_photo_outlined, color: Colors.white), // Changed icon color to white for better visibility
          backgroundColor: Color(0xFF52CCBC), // Set the background color of the button
        ),
    );
  }
}
