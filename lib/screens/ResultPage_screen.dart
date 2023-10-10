import 'package:flutter/material.dart';
import 'dart:io';
import '../ThemeProvider.dart';

class ResultPage extends StatelessWidget {
  final bool showSuccess;

  ResultPage({required this.showSuccess});

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).textTheme.bodyText1!.color!;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showSuccess
                ? Text(
              "Success!",
              style: TextStyle(color: textColor),
            )
                : Text(
              "Server Error!",
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 20), // Add some spacing between the text and the button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to the previous page
              },
              child: Text("Finish"),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF52CCBC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
