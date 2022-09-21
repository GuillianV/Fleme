import 'dart:convert';
import 'dart:io';
import 'package:fleme/models/providers/picture_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import "package:http/http.dart" as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecognizerNetwork {
  String? url;
  String text;
  String? creation;
  bool isValid = false;

  RecognizerNetwork(this.text, this.isValid, this.creation, this.url);

  factory RecognizerNetwork.createSimple(String _text) {
    return RecognizerNetwork(_text, false, null, null);
  }

  factory RecognizerNetwork.fromJson(Map<String, dynamic> json) {
    return RecognizerNetwork(
      json["text"],
      true,
      json["creation"],
      json["url"],
    );
  }

  static Future<RecognizerNetwork> get(_url) async {
    String? url = dotenv.env['BACK_URL'] ?? "127.0.0.1";
    String? port = dotenv.env['BACK_PORT'] ?? "3000";
    var result = await http.get(Uri.parse("$url:$port/recognize/$_url"));
    var decodeReesp = jsonDecode(result.body);
    return RecognizerNetwork.fromJson(decodeReesp);
  }

  static Future<RecognizerNetwork> post(_text) async {
    String? url = dotenv.env['BACK_URL'] ?? "127.0.0.1";
    String? port = dotenv.env['BACK_PORT'] ?? "3000";
    late Uri uri;
    if (dotenv.env["BACK_SECURED"]! == 'false') {
      uri = Uri.http("$url:$port", "/recognize", {"text": _text});
    } else if (dotenv.env["BACK_SECURED"]! == 'true') {
      uri = Uri.https("$url", "/recognize", {"text": _text});
    }

    var result = await http.post(uri);
    var decodeReesp = jsonDecode(result.body);
    return RecognizerNetwork.fromJson(decodeReesp);
  }
}
