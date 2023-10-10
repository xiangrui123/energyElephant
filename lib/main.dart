import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/upload_screen.dart';
import 'package:provider/provider.dart';
import 'ThemeProvider.dart'; // 假设您有一个ThemeProvider来管理主题
import 'register.dart'; // 假设您有一个register.dart文件来定义RegisterApp
import 'DeviceProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceKeyProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // 添加其他提供者
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // 使用ThemeProvider来获取当前主题
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Meter Reading',
      theme: themeProvider.isDarkMode ? themeProvider.darkTheme : themeProvider.lightTheme,
      initialRoute: '/home', // 设置初始路由为'/register'
      routes: {
        // '/register': (context) => RegisterScreen(), // 注册页面的路由
        '/home': (context) => HomeScreen(),
        '/camera': (context) => CameraScreen(),
        '/upload': (context) => LibraryScreen(),
      },
    );
  }
}
