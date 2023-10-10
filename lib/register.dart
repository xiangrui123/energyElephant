import 'package:flutter/material.dart';
import 'main.dart';
import 'screens/camera_screen.dart';
import 'screens/upload_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerDevice() async {
    // 获取用户输入的电子邮件和密码
    String email = emailController.text;
    String password = passwordController.text;

    // 构建API请求URL
    String apiUrl = 'https://api.energyelephant.com/register/'; // 请将设备类型添加到URL

    // 构建请求体
    Map<String, String> requestBody = {
      'device_uuid': 'your_device_uuid_here', // 替换为实际设备UUID
    };

    // 发送POST请求
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response!=null) {
        // 如果请求成功，解析响应数据
        final responseData = json.decode(response.body);
        String deviceKey = responseData['device_key'];

        // 注册成功后，可以导航到'/home'页面或其他页面
        print('Registered with Email: $email, Password: $password, Device Key: $deviceKey');
        Navigator.pushNamed(context, '/home');
      } else {
        // 如果请求失败，抛出异常或执行适当的错误处理
        print('Failed to register');
        // 在这里可以显示错误消息或采取适当的措施
      }
    } catch (e) {
      print('Error: $e');
      // 处理异常，例如网络连接问题
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EnergyElephant'),
        backgroundColor: Color(0xff559f4c),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 0.0), // 设置顶部外边距
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(0, -62),
                child: Image.asset(
                  'images/img.png',
                  width: 300,
                  height: 100,
                ),
              ),

               Transform.translate(
                offset: Offset(0, -52),
                 child: Text(
                'Let’s give you sustainability super-powers!',
                style: TextStyle(color: Colors.purple), // 更改标题颜色为紫色
                ),
               ),
                 SizedBox(height: 6),
                 TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email address',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Create password',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: registerDevice,
                child: Text('Create Account'),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF64eac5),
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // 在此处添加登录逻辑
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Already have an account? Login here'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xffddeff1),
    );
  }
}

