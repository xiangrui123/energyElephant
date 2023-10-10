import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF52CCBC),
    backgroundColor: Color(0xFFF5F6FB),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.black), // 这里设置您想要的颜色
      bodyText2: TextStyle(color: Colors.white), // 这里设置您想要的颜色
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF52CCBC),
        onPrimary: Colors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF52CCBC),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF52CCBC),
    backgroundColor: Colors.black,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white), // 这里设置您想要的颜色
      bodyText2: TextStyle(color: Colors.black), // 这里设置您想要的颜色
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF52CCBC),
        onPrimary: Colors.white,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
      ),
    ),
  );
}
