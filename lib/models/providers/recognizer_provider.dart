import 'dart:io';
import 'package:fleme/models/recognizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Recognizers with ChangeNotifier {
  List<Recognizer> _recognizers = new List.empty(growable: true);

  void addRecognizer(Recognizer recognizer) {
    this._recognizers.add(recognizer);
  }

  bool exists(int recognizerId) {
    if (_recognizers.length > 0 && _recognizers.length > recognizerId) {
      Recognizer? recognizerExist = _recognizers.elementAt(recognizerId);
      return recognizerExist != null ? true : false;
    }

    return false;
  }

  List<Recognizer> getRecognizers() {
    return this._recognizers;
  }

  Recognizer? getRecognizer(int recognizerId) {
    if (exists(recognizerId))
      return this._recognizers[recognizerId];
    else
      return null;
  }

  void refreshRecognizers() {
    notifyListeners();
  }

  bool removeRecognizer(Recognizer _recognizer) {
    if (_recognizers.remove(_recognizer)) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return true;
    }
  }

  bool removeRecognizerById(int recognizerId, {bool refresh = true}) {
    late Recognizer recognizerToDelete;
    if (_recognizers.length > recognizerId) {
      recognizerToDelete = _recognizers[recognizerId];
    } else
      return false;

    if (_recognizers.remove(recognizerToDelete)) {
      refresh ? this.refreshRecognizers() : null;
      return true;
    } else {
      refresh ? this.refreshRecognizers() : null;
      return true;
    }
  }
}
