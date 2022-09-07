import 'dart:io';
import 'package:fleme/models/recognizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Recognizers with ChangeNotifier {
  List<Recognizer> recognizer = new List.empty(growable: true);

  void addRecognizer(Recognizer recognizer) {
    this.recognizer.add(recognizer);
  }

  List<Recognizer> getRecognizers() {
    return this.recognizer;
  }
}
