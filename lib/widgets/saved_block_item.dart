import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/utils/shadow_black.dart';
import 'package:fleme/views/image_filter_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class SavedBlockItem extends StatefulWidget {
  const SavedBlockItem(
      {super.key,
      required this.recognizedId,
      required this.textBlockId,
      required this.text});

  final int recognizedId;
  final int textBlockId;
  final String text;

  @override
  State<SavedBlockItem> createState() => _SavedBlockItemState();
}

class _SavedBlockItemState extends State<SavedBlockItem> {
  bool isTaped = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTaped = !isTaped;
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: !isTaped ? Color.fromARGB(255, 239, 238, 238) : Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: shadowBlack(),
        ),
        child: Column(children: [
          Text(widget.text),
          if (!isExpanded)
            Icon(
              Icons.add,
              size: 10,
            )
          else
            Column(children: [
              Icon(
                Icons.remove,
                size: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Recognizers recognizers =
                          Provider.of<Recognizers>(context, listen: false);
                      Recognizer? recognizer =
                          recognizers.getRecognizer(widget.recognizedId);

                      if (recognizer != null) {
                        recognizer.removeSavedTextBlock(widget.textBlockId);
                        recognizers.refreshRecognizers();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.delete),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            boxShadow: shadowBlack(),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (recognizer != null) {
                        Navigator.pushNamed(context, "/textBlock_edit",
                            arguments: {
                              "recognizedId": widget.recognizedId,
                              "textBlockId": widget.textBlockId
                            });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.settings_ethernet_rounded,
                            color: Colors.white),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            boxShadow: shadowBlack(),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  )
                ],
              )
            ])
        ]),
      ),
    );
  }
}