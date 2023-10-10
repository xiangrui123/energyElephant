import 'package:flutter/material.dart';

class DropdownOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 主轴居中
          children: [
            Container(
              width: 200,  // 限制宽度
              child: ListTile(
                title: Text('Gas', textAlign: TextAlign.center),
                onTap: () => Navigator.pop(context, 'Gas'),
              ),
            ),
            Container(
              width: 200,  // 限制宽度
              child: ListTile(
                title: Text('Electric', textAlign: TextAlign.center),
                onTap: () => Navigator.pop(context, 'Electric'),
              ),
            ),
            Container(
              width: 200,  // 限制宽度
              child: ListTile(
                title: Text('Other', textAlign: TextAlign.center),
                onTap: () => Navigator.pop(context, 'Other'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
