import 'dart:io';
import 'package:fleme/models/recognizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Recognizers with ChangeNotifier {
  List<Recognizer> recognizers = new List.empty(growable: true);

  void addRecognizer(Recognizer recognizer) {
    this.recognizers.add(recognizer);
  }

  List<Recognizer> getRecognizers() {
    return this.recognizers;
  }

  void refreshRecognizers() {
    notifyListeners();
  }

  bool removeRecognizer(Recognizer _recognizer) {
    if (recognizers.remove(_recognizer)) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return true;
    }
  }

  bool removeRecognizerById(int recognizerId) {
    late Recognizer recognizerToDelete;
    if (recognizers.length > recognizerId) {
      recognizerToDelete = recognizers[recognizerId];
    } else
      return false;

    if (recognizers.remove(recognizerToDelete)) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return true;
    }
  }
}
