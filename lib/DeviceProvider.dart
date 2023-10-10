import 'package:flutter/material.dart';

class DeviceKeyProvider extends ChangeNotifier {
  String? deviceKey;

  void setDeviceKey(String? key) {
    deviceKey = key;
    notifyListeners();
  }
}
