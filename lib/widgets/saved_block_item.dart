import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/theme/box_shadow.dart';
import 'package:fleme/views/image_filter_view.dart';
import 'package:flutter/material.dart';
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
          color: !isTaped
              ? const Color.fromARGB(255, 239, 238, 238)
              : Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: box_shadow(context),
        ),
        child: Column(children: [
          Text(widget.text),
          if (!isExpanded)
            const Icon(
              Icons.add,
              size: 10,
            )
          else
            Column(children: [
              const Icon(
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
                        recognizer
                            .getBlockRecognizedById(widget.textBlockId)
                            ?.unsave();
                        recognizers.refreshRecognizers();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 126, 117),
                            boxShadow: box_shadow(context),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(Icons.delete),
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
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 129, 175, 255),
                            boxShadow: box_shadow(context),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(Icons.mode_edit, color: Colors.white),
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
