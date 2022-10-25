import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DragProvider with ChangeNotifier {
  bool _isDragging = false;

  void toggleDrag(bool isDragging) {
    _isDragging = isDragging;
    notifyListeners();
  }

  bool getDrag() {
    return _isDragging;
  }
}
