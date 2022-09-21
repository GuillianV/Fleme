// ignore_for_file: unnecessary_this

import 'dart:io';
import 'package:fleme/models/providers/picture_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class Recognizerblock {
  int id;
  TextBlock _textBlock;
  String _defaultTextEdited;
  String _textEdited;
  bool _isSaved = false;
  bool _timed = false;

  Recognizerblock(
      this.id, this._textBlock, this._textEdited, this._defaultTextEdited);

  factory Recognizerblock.create(int id, TextBlock textBlock) {
    Recognizerblock recognizerblock =
        Recognizerblock(id, textBlock, textBlock.text, textBlock.text);
    return recognizerblock;
  }

  //Saved
  void save() {
    this._isSaved = true;
  }

  void unsave() {
    this._isSaved = false;
  }

  void toggleSave() {
    this._isSaved = !this._isSaved;
  }

  bool isSaved() {
    return this._isSaved;
  }

  //Time
  void busy() {
    this._timed = true;
  }

  void free() {
    this._timed = false;
  }

  void toggleTimed() {
    this._timed = !this._timed;
  }

  bool getTimed() {
    return this._timed;
  }

  //Default text
  String getDefaultTextEdited() {
    return this._defaultTextEdited;
  }

  //Text edited
  String getTextEdited() {
    return this._textEdited;
  }

  void setTextEdited(String newValue) {
    this._textEdited = newValue;
  }

  TextBlock getTextBlock() {
    return this._textBlock;
  }

  Rect getBoundingBox() {
    return this._textBlock.boundingBox;
  }
}
