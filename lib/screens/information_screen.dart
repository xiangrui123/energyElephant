import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../ThemeProvider.dart';

class InformationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    Color textColor = Theme.of(context).textTheme.bodyText1!.color!;
    bool isDarkMode = textColor == Colors.white?true:false;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
      ),
      body: Center(
        child: Transform.translate(
               offset: Offset(0, 100),
         child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 258, // 限制文本框的宽度
                child: Column(
                  children: [
                    Text(
                      'Your meter reading photograph will be uploaded to your Energyelephant account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16,color: textColor),
                    ),
                    SizedBox(height: 10), // 添加一些间距
                    Text(
                      'This helps US improve your utility data and eliminate estimate bills.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16,color: textColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 180, // 限制文本框的宽度
                child: Text(
                  'For more information:',
                  style: TextStyle(fontSize: 16,color: textColor),
                ),
              ),
              SizedBox(height:20),
              InkWell(
                onTap: () async {
                  const url = 'https://energyelephant.com/account/login';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print('Could not launch $url');
                  }
                },
                child: Container(
                  width: 190,
                  child: Text(
                    'EnergyElephant.com',
                    style: TextStyle(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: isDarkMode ? Colors.white : Color(0xFF64eac5),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center, // 文本居中
                  ),
                ),
              ),
              SizedBox(height: 70),
              InkWell(
                onTap: () {
                  Navigator.pop(context); // 返回上一个页面
                },
                child:Container(
                  child: Text(
                  'Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: textColor,// 使用主题的主要颜色，您可以根据需要更改
                  ),
                 ),
                ),
              ),
            ],
          ),
        ),
       ),
      ),
    );
  }
}
