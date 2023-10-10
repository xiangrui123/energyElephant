import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../DeviceProvider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';
import 'DropdownSearch_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../ThemeProvider.dart';
import 'ResultPage_screen.dart';

class AdditionalInfoForm extends StatefulWidget {
  final String? imagePath; // add imagePath
  AdditionalInfoForm({Key? key, this.imagePath}) : super(key: key);
  @override
  _AdditionalInfoFormState createState() => _AdditionalInfoFormState();
}

class _AdditionalInfoFormState extends State<AdditionalInfoForm> {
  final TextEditingController emailController = TextEditingController();
  final commentController = TextEditingController();
  String meterType = 'Electric';
  bool showEmailTooltip = false;
  bool showMeterTypeTooltip = false;
  bool showLoading = false;
  bool showSuccess = false;
  String? comment;

  _showSuccessDialog() async {
    setState(() {
      showLoading = true;
    });

    // Simulate network delay
    Timer(Duration(seconds: 2), () async {
      setState(() {
        showLoading = false;
        showSuccess = true;
      });

      // Reset after showing the success checkmark
      Timer(Duration(seconds: 2), () {
        setState(() {
          showSuccess = false;
        });
      });
      String appKey = Platform.isIOS ? 'MGEjeCQhaDY0dm4tMXA3c2RvZmJjcCpxZ2xkMGJkMXUhdjR6bjEmeHcjd2w4QHpwY2Y=' : 'JWQwJCkkOXZ6NGRiM3JlKzhea28oNjZrYj05MnQ0NG16ejZsOCgpbmt0Y2tfMEAxXmE=';
      String formattedDate = DateTime.now().toLocal().toString();
      String? location = await _getLocation();
      String? deviceKey = Provider.of<DeviceKeyProvider>(context, listen: false).deviceKey ?? '';
      String imagePath = widget.imagePath ?? ''; // Use an empty string as a default value
      print(widget.imagePath);
      // Call the uploadMeterPhoto method with date, location, and comment
      uploadMeterPhoto(
        emailController.text,
        appKey,
        deviceKey, // Replace with your device key
        imagePath,
        meterType,
        formattedDate,
        location,
        comment,
      );
    });
  }

  Future<String?> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return "${position.latitude}/${position.longitude}";
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyText1!.color!;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Meter details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Center(
                        child: Image.file(
                          File(widget.imagePath!),
                          width: MediaQuery.of(context).size.width, // Subtracting the horizontal padding
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // Semi-transparent text overlay
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            height: 40,
                            child: Center(
                              child: Text(
                                'Please ensure meter photo is readable',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                showEmailTooltip
                    ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,left: 20.0),
                      child: Text(
                     'Email address is required. Use the address associated with your Energy Elephant account',
                      style: TextStyle(color: textColor),
                    ),
                    )
                    : Container(),
                     showMeterTypeTooltip
                    ? Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0,left: 20.0),
                      child: Text(
                    'Please select a meter type.',
                    style: TextStyle(color: textColor),
                  ),
                )
                    : Container(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter your email address',
                        labelStyle: TextStyle(color: textColor),
                      ),
                      style: TextStyle(color: textColor),
                    ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select meter type',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DropdownOptionsPage()),
                          );
                          if (result != null) {
                            setState(() {
                              meterType = result;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: textColor,
                            border: Border.all(color: textColor==Colors.white?Colors.black:Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                meterType ?? 'Select Meter Type',
                                style: TextStyle(color: textColor==Colors.white?Colors.black:Colors.white),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Comment',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      SizedBox(height:10),
                      TextFormField(
                        controller: commentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          comment = value;
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: textColor==Colors.white?Colors.black:Colors.white),
                          border: OutlineInputBorder(),
                          hintText: 'Meter number or other details',  // 设置占位符文本
                          filled: true,
                          fillColor: textColor,
                        ),
                        style: TextStyle(color: textColor==Colors.white?Colors.black:Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left Button (Upload)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45, // Assuming you want to take up 45% of the screen width for each button
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showEmailTooltip = emailController.text.isEmpty;
                                  showMeterTypeTooltip = meterType == null;
                                  if (!showEmailTooltip && !showMeterTypeTooltip) {
                                    showSuccess = true; // Assuming you set showSuccess to true somewhere
                                    if (showSuccess) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResultPage(showSuccess: showSuccess),
                                        ),
                                      );
                                    }
                                  }
                                });
                              },
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF52CCBC),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                                minimumSize: Size(double.infinity, 70),
                              ),
                            ),
                          ),
                          // Right Button (Floating Action Button to go back)
                          FloatingActionButton(
                            onPressed: () {
                              Navigator.pop(context); // Return to the previous page
                            },
                            child: Icon(Icons.add_a_photo_outlined, color: Colors.white),
                            backgroundColor: Color(0xFF52CCBC), // Assuming you want a white background for the FloatingActionButton
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  String toDMS(double coord) {
    final int degrees = coord.floor();
    final double minutesDecimal = (coord - degrees) * 60;
    final int minutes = minutesDecimal.floor();
    final double secondsDecimal = (minutesDecimal - minutes) * 60;
    final int seconds = secondsDecimal.round();

    String degreesStr = degrees.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$degreesStr/$minutesStr/$secondsStr';
  }

  String toDMSWithHemisphere(double latitude, double longitude) {
    String latDMS = toDMS(latitude.abs());
    String lonDMS = toDMS(longitude.abs());

    String latH = latitude >= 0 ? "/N" : "/S"; // 在度数和半球方向之间添加斜杠
    String lonH = longitude >= 0 ? "E" : "W"; // 在度数和半球方向之间添加斜杠
    print('$latDMS$latH$lonDMS$lonH'); // 添加了分号
    return "$latDMS$latH$lonDMS$lonH";
  }



  void uploadMeterPhoto(
      String email,
      String appKey,
      String deviceKey,
      String imagePath,
      String? meterType,
      String formattedDate,
      String? location,
      String? comment,
      ) async {
    // Build API request URL
    String apiUrl = 'https://api.energyelephant.com/meter/photo/upload';
    String currentDate = DateTime.now().toLocal().toString(); // 2023-09-13 23:50:23.685290
    DateTime parsedDate = DateTime.parse(currentDate);
    String formattedDate = DateFormat('MM/dd/yyyy').format(parsedDate);
    // Create a MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // Attach the image as a MultipartFile, not as a base64 string
    final imageFile = File(imagePath);
    var file = await http.MultipartFile.fromPath('file_data', imageFile.path);
    List<String>? coords = location?.split("/");
    if (coords != null && coords.length == 2) {
      double latitude = double.parse(coords[0]);
      double longitude = double.parse(coords[1]);
      String dmsFormat = toDMSWithHemisphere(latitude, longitude);
      print(dmsFormat);

      // Add form fields
      request.fields['email'] = email;
      request.fields['app_key'] = appKey;
      request.fields['device_key'] = deviceKey;
      request.fields['meter_type'] = meterType ?? '';
      request.fields['date'] = formattedDate;
      request.fields['location'] = dmsFormat ?? '';
      request.fields['comment'] = comment ?? '';
      // Add file fields
      request.files.add(file);
      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          // Handle successful upload response
          print('Meter photo uploaded successfully');
        } else {
          // Handle failed upload response
          print(request.fields);
        }
      } catch (e) {
        // Handle upload errors
        print('Error uploading meter photo: $e');
      }
    }
  }
}