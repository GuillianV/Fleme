import 'dart:convert';

import 'package:fleme/models/recognizeData.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:http/http.dart" as http;

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
      json["fullText"],
      true,
      json["creation"],
      json["url"],
    );
  }

  static Future<RecognizerNetwork?> post(Recognizer recognizer) async {
    RecognizerNetwork? recognizerFetched;

    String? url = dotenv.env['BACK_URL'];
    if (url == null) {
      throw Exception("Missing 'BACK_URL in .env");
    }

    String? port = dotenv.env['BACK_PORT'];
    if (url == null) {
      throw Exception("Missing 'BACK_PORT' in .env");
    }

    bool isBackSecured = port == '443';
    Uri uri;
    Map<String, dynamic> parsed = RecognizerData.create(recognizer).getParsed();

    if (isBackSecured) {
      uri = Uri.https(url, "/recognize", {"data": jsonEncode(parsed)});
    } else {
      uri = Uri.http("$url:$port", "/recognize", {"data": jsonEncode(parsed)});
    }

    try {
      recognizerFetched = await http.post(uri).then((result) {
        var decodeReesp = jsonDecode(result.body);
        return RecognizerNetwork.fromJson(decodeReesp);
      }).timeout(const Duration(seconds: 5));
    } catch (e) {
      print(e);
    } finally {
      return recognizerFetched;
    }
  }
}
