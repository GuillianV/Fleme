import 'dart:convert';

import 'package:fleme/models/recognizer.dart';
import 'package:fleme/models/recognizer_block.dart';

class RecognizerData {
  String? fullText;
  List<Recognizerblock> recognizerBlocks = new List.empty(growable: true);

  RecognizerData(this.fullText, this.recognizerBlocks);

  factory RecognizerData.create(Recognizer recognizer) {
    String text = "";
    recognizer.getSavedTextBlock().forEach((element) {
      text += "${element.getTextEdited()}\n";
    });
    return RecognizerData(text, recognizer.getSavedTextBlock());
  }

  Map<String,dynamic> getParsed() {
     List<Map<String,dynamic>> item = recognizerBlocks.map((e) => 
      { 
        "id":e.id,
        "text":e.getTextEdited(),
      }).toList();
      
    return {"fullText": fullText,"recognizerBlocks": item };
  }
}
