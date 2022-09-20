import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/utils/shadow_black.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:fleme/views/image_filter_view.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBlockEdit extends StatefulWidget {
  const TextBlockEdit(
      {super.key, required this.RecognizedId, required this.TextBlockId});
  final int RecognizedId;
  final int TextBlockId;

  @override
  State<TextBlockEdit> createState() => _TextBlockEditState();
}

class _TextBlockEditState extends State<TextBlockEdit> {
  @override
  Widget build(BuildContext context) {
    Recognizers recognizers = context.read<Recognizers>();
    Recognizer? recognizer = recognizers.getRecognizer(widget.RecognizedId);
    TextBlock? textBlock =
        recognizer!.getSavedTextBlockById(widget.TextBlockId);

    TextEditingController txtController = TextEditingController();
    txtController.text = recognizer.getSavedTextEditedId(widget.TextBlockId);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Text Editor",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(fontSize: 25))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.2, 0, width * 0.2, 0),
                          child: Text(
                              "Modifiez le contenu de votre bloc de texte",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12, letterSpacing: -0.5))),
                        )
                      ]),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(width * 0.1, 0, width * 0.1, 0),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    boxShadow: shadowBlack(),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white70,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: TextField(
                    controller: txtController,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    onChanged: (value) {
                      recognizer.editSavedTextEdited(widget.TextBlockId, value);
                    },
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(fontSize: 12, letterSpacing: -0.5)),
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await availableCameras().then((value) => Navigator.pop(context));
        },
        tooltip: 'Back',
        child: const Icon(Icons.arrow_back),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
