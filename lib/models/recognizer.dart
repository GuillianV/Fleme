import 'dart:io';
import 'package:fleme/models/recognizer_block.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Recognizer {
  String _filePath = "";
  List<Recognizerblock> _blockRecognized = new List.empty(growable: true);
  int widthImage = 0;
  int heightImage = 0;

  Recognizer(this._filePath);

  factory Recognizer.create(String filePath) {
    return Recognizer(filePath);
  }

  Future<void> setTextBlock() async {
    InputImage inputImage = InputImage.fromFilePath(getFilePath());
    String myDecryptedText = '';
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin, );
  
 

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

  bool _RecognizerblockExist(int id) {
    for (Recognizerblock block in _blockRecognized) {
      if (block.id == id) {
        return true;
      }
    }
    return false;
  }

  void addTextBlock(TextBlock textBlock) {
    this
        ._blockRecognized
        .add(Recognizerblock.create(_blockRecognized.length, textBlock));
  }

  void saveTextBlock(int recognizerblockId) {
    if (_RecognizerblockExist(recognizerblockId)) {
      _blockRecognized[recognizerblockId].save();
    }
  }

  void unsaveTextBlock(int recognizerblockId) {
    if (_RecognizerblockExist(recognizerblockId)) {
      _blockRecognized[recognizerblockId].unsave();
    }
  }

  List<Recognizerblock> getBlockRecognized() {
    return this._blockRecognized;
  }

  Recognizerblock? getBlockRecognizedById(int id) {
    if (_RecognizerblockExist(id))
      return this._blockRecognized[id];
    else
      return null;
  }

  List<Recognizerblock> getSavedTextBlock() {
    return _blockRecognized
        .where((blockRecognized) => blockRecognized.isSaved())
        .toList();
  }

  Recognizerblock getSavedTextBlockById(int recognizerblockId) {
    return _blockRecognized.firstWhere((blockRecognized) =>
        blockRecognized.isSaved() && recognizerblockId == blockRecognized.id);
  }

  String getFilePath() {
    return this._filePath;
  }

  Recognizerblock? findTextBlockByCoordonates(double x, double y) {
    for (Recognizerblock recognizerblock in this._blockRecognized) {
      Rect recognizerblockRect = recognizerblock.getBoundingBox();

      if (x > recognizerblockRect.left &&
          x < recognizerblockRect.right &&
          y > recognizerblockRect.top &&
          y < recognizerblockRect.bottom) {
        return recognizerblock;
      }
    }
    return null;
  }
}
