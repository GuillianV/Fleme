import 'dart:io';
import 'package:fleme/models/providers/picture.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class Recognizer {
  String _filePath = "";
  List<TextBlock> _textBlock = new List.empty(growable: true);
  int widthImage = 0;
  int heightImage = 0;

  Recognizer(this._filePath);

  factory Recognizer.create(String filePath) {
    return Recognizer(filePath);
  }

  void setTextBlock() async {
    InputImage inputImage = InputImage.fromFilePath(getFilePath());
    String myDecryptedText = '';
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    File image =
        new File(getFilePath()); // Or any other way to get a File instance.
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());

    widthImage = decodedImage.width;
    heightImage = decodedImage.height;

    RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText?.blocks ?? []) {
      addTextBlock(block);
    }
  }

  void addTextBlock(TextBlock textBlock) {
    this._textBlock.add(textBlock);
  }

  List<TextBlock> getTextBlock() {
    return this._textBlock;
  }

  String getFilePath() {
    return this._filePath;
  }
}
