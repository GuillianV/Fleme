import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Picture with ChangeNotifier {
  String _filePath = "";

  void saveFilePath(String newFilePath) {
    _filePath = newFilePath;
    notifyListeners();
  }

  String getFilePath() {
    return _filePath;
  }
}
