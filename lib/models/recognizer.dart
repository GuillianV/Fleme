import 'dart:io';
import 'package:fleme/models/providers/picture_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class Recognizer {
  String _filePath = "";
  List<TextBlock> _textBlock = new List.empty(growable: true);
  List<int> _savedTextBlockIds = new List.empty(growable: true);
  List<String> _savedTextEdited = new List.empty(growable: true);
  int widthImage = 0;
  int heightImage = 0;

  Recognizer(this._filePath);

  factory Recognizer.create(String filePath) {
    return Recognizer(filePath);
  }

  Future<void> setTextBlock() async {
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
      addSavedTextEdited(block.text);
    }
  }

  void addTextBlock(TextBlock textBlock) {
    this._textBlock.add(textBlock);
  }

  List<TextBlock> getTextBlock() {
    return this._textBlock;
  }

  void addSavedTextBlock(int textBlockId) {
    if (!this._savedTextBlockIds.contains(textBlockId)) {
      this._savedTextBlockIds.add(textBlockId);
    }
  }

  void removeSavedTextBlock(int textBlockId) {
    if (this._savedTextBlockIds.contains(textBlockId)) {
      this._savedTextBlockIds.remove(textBlockId);
    }
  }

  List<TextBlock> getSavedTextBlock() {
    List<TextBlock> savedTextBlock = new List.empty(growable: true);
    for (int id in this._savedTextBlockIds) {
      savedTextBlock.add(this._textBlock[id]);
    }
    return savedTextBlock;
  }

  TextBlock? getSavedTextBlockById(int textBlockId) {
    for (int id in this._savedTextBlockIds) {
      if (textBlockId == id) return this._textBlock[id];
    }
    return null;
  }

  void addSavedTextEdited(String textEdited) {
    this._savedTextEdited.add(textEdited);
  }

  List<String> getSavedTextEdited() {
    return this._savedTextEdited;
  }

  String getSavedTextEditedId(int id) {
    return this._savedTextEdited[id];
  }

  void editSavedTextEdited(int id, String textEdited) {
    this._savedTextEdited[id] = textEdited;
  }

  String getFilePath() {
    return this._filePath;
  }

  TextBlock? findTextBlockByCoordonates(double x, double y) {
    for (TextBlock textBlock in this._textBlock) {
      if (x > textBlock.boundingBox.left &&
          x < textBlock.boundingBox.right &&
          y > textBlock.boundingBox.top &&
          y < textBlock.boundingBox.bottom) {
        return textBlock;
      }
    }
    return null;
  }
}
