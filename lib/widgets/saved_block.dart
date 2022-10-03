import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/theme/box_shadow.dart';
import 'package:fleme/views/filter_view.dart';
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
    ThemeData theme = Theme.of(context);

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
              ? theme.backgroundColor
              : theme.backgroundColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(5),
          boxShadow: box_shadow(context),
          border: Border.all(
            color: theme.primaryColor,
            width: 1,
          ),
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
                            color: theme.errorColor,
                            boxShadow: box_shadow(context),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(Icons.delete, color: theme.backgroundColor),
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
                            color: theme.colorScheme.primary,
                            boxShadow: box_shadow(context),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          Icons.mode_edit,
                          color: theme.colorScheme.secondary,
                        ),
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
