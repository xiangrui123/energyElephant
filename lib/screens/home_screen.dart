import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import '../ThemeProvider.dart';
import 'package:unique_identifier/unique_identifier.dart'; // 引入 unique_identifier 插件
import '../DeviceProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'information_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = true; // 初始状态为白天模式

  @override
  void initState() {
    super.initState();
    // 在首次运行时注册设备并获取IMEI
    registerDevice();
  }

  Future<void> registerDevice() async {
    String deviceType = Platform.isIOS ? 'iphone' : 'android';
    String apiUrl = 'https://api.energyelephant.com/register/$deviceType';
    String imei = '';

    if (Platform.isIOS) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      var data = await deviceInfoPlugin.iosInfo;
      imei = data.identifierForVendor ?? '';
    } else if (Platform.isAndroid) {
      // 使用 unique_identifier 插件来获取 IMEI
      imei = (await UniqueIdentifier.serial) ?? '';
    }

    if (imei.isEmpty) {
      print('IMEI is empty. Unable to register device.');
      return;
    }

    // 创建一个MultipartRequest
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    // 添加表单字段
    request.fields['device_uuid'] = imei;

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // 处理响应
        final responseData = await response.stream.bytesToString();
        Map<String, dynamic> jsonMap = json.decode(responseData);
        String deviceKey = jsonMap['device_key'];
        context.read<DeviceKeyProvider>().setDeviceKey(deviceKey);
        print('Device registered with key: $deviceKey');
      } else {
        print('Failed to register device');
      }
    } catch (e) {
      print('Error registering device: $e');
    }
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode; // 首先切换夜间模式和白天模式
    });
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); // 更新主题
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    // final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Meter Reading App'),
        actions: <Widget>[
          // 添加切换主题的按钮
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: isDarkMode ? Colors.white: Colors.black,  // 如果是nightlight_round图标，则设置为黑色
            ),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0, -60),
              child: Image.asset(
                'images/home.png',
                width: 70,
                height: 70,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -60),
              child: Image.asset(
                isDarkMode ? 'images/data1.png' : 'images/data.png',
                width: 200,
                height: 60,
              ),
            ),
            SizedBox(height: 0),
            SizedBox(
              width: 200,
              height: 60, // 设置高度
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/camera');
                },
                child: Text(
                    'Take Photo',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 设置边框半径为30
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 60, // 设置高度
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/upload');
                },
                child: Text('Select from library',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 设置边框半径为30
                  ),
                ),
              ),
            ),
            SizedBox(height: 90), // 增加一些间距
            InkWell(
              onTap: () async {
                const url = 'https://energyelephant.com/account/login';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              },
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
            SizedBox(height: 40), // 增加一些间距
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InformationScreen()),
                );
              },
              child: Icon(
                Icons.info,
                color: isDarkMode ? Colors.white : Colors.black,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
