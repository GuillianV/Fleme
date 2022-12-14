import 'package:fleme/models/providers/drag_provider.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/models/recognizer_block.dart';
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
  bool isBeingAccepted = false;
  bool isBeingAcceptedBottom = false;
  bool isSelfDragging = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DragProvider dragProvider =
        Provider.of<DragProvider>(context, listen: false);
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isTaped = !isTaped;
            isExpanded = !isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5),
          width: width,
          decoration: BoxDecoration(
            color: !isTaped
                ? (isSelfDragging
                    ? theme.colorScheme.primary
                    : theme.backgroundColor)
                : (isSelfDragging
                    ? theme.colorScheme.primary
                    : theme.backgroundColor),
            borderRadius: BorderRadius.circular(5),
            boxShadow: box_shadow(context),
            border: Border.all(
              color: theme.primaryColor,
              width: 1,
            ),
          ),
          child: Column(children: [
            Consumer<DragProvider>(
              builder: (context, value, child) {
                return DragTarget<Recognizerblock>(
                  onWillAccept: (data) {
                    setState(() {
                      isBeingAccepted = true;
                    });
                    return true;
                  },
                  onLeave: (data) {
                    setState(() {
                      isBeingAccepted = false;
                    });
                  },
                  onAccept: (data) {
                    setState(() {
                      if (!isSelfDragging) {
                        data.unsave();
                        Recognizerblock? localRecognizerBlock = recognizer!
                            .getBlockRecognizedById(widget.textBlockId);
                        if (localRecognizerBlock != null) {
                          data.unsave();
                          localRecognizerBlock.setTextEdited(
                              "${data.getTextEdited()} \n ${localRecognizerBlock.getTextEdited()}");
                          localRecognizerBlock.save();
                          Provider.of<Recognizers>(context, listen: false)
                              .refreshRecognizers();
                        }
                      }
                      isBeingAccepted = false;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    if (value.getDrag() && !isSelfDragging) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        height: 20,
                        child: Center(
                          child: Divider(
                            indent: isBeingAccepted ? 20 : 70,
                            endIndent: isBeingAccepted ? 20 : 70,
                            color: theme.primaryColor,
                            thickness: isBeingAccepted ? 3 : 1,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: 20,
                      );
                    }
                  },
                );
              },
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyText2,
                    ),
                  ),
                  Draggable<Recognizerblock>(
                    onDragStarted: () {
                      isSelfDragging = true;
                      dragProvider.toggleDrag(true);
                    },
                    onDragCompleted: () {
                      isSelfDragging = false;
                      dragProvider.toggleDrag(false);
                    },
                    onDragEnd: (details) {
                      isSelfDragging = false;
                      dragProvider.toggleDrag(false);
                    },
                    onDraggableCanceled: (velocity, offset) {
                      isSelfDragging = false;
                      dragProvider.toggleDrag(false);
                    },
                    affinity: Axis.horizontal,
                    dragAnchorStrategy: (draggable, context, position) {
                      return Offset(
                          (width * 0.8), ((context.size?.height ?? 200) + 20));
                    },
                    data:
                        recognizer?.getBlockRecognizedById(widget.textBlockId),
                    feedback: Center(
                      child: SizedBox(
                        width: width,
                        child: Center(
                          child: Container(
                            width: width * 0.8,
                            decoration: BoxDecoration(
                              color: theme.backgroundColor.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: box_shadow(context),
                              border: Border.all(
                                color: theme.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.text,
                                style: theme.textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      child: SizedBox(
                        width: width * 0.15,
                        child: Center(
                            child: Icon(Icons.drag_indicator,
                                color: theme.primaryColor)),
                      ),
                      onLongPressDown: (details) {
                        isSelfDragging = true;
                        dragProvider.toggleDrag(true);
                      },
                      onLongPressEnd: (details) {
                        isSelfDragging = false;
                        dragProvider.toggleDrag(false);
                      },
                      onLongPressCancel: () {
                        isSelfDragging = false;
                        dragProvider.toggleDrag(false);
                      },
                    ),
                  )
                ],
              ),
            ),
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
                          child:
                              Icon(Icons.delete, color: theme.backgroundColor),
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
              ]),
            Consumer<DragProvider>(builder: (context, value, child) {
              return DragTarget<Recognizerblock>(
                onWillAccept: (data) {
                  setState(() {
                    isBeingAcceptedBottom = true;
                  });
                  return true;
                },
                onLeave: (data) {
                  setState(() {
                    isBeingAcceptedBottom = false;
                  });
                },
                onAccept: (data) {
                  setState(() {
                    if (!isSelfDragging) {
                      data.unsave();
                      Recognizerblock? localRecognizerBlock = recognizer!
                          .getBlockRecognizedById(widget.textBlockId);
                      if (localRecognizerBlock != null) {
                        data.unsave();
                        localRecognizerBlock.setTextEdited(
                            "${localRecognizerBlock.getTextEdited()} \n ${data.getTextEdited()}");
                        localRecognizerBlock.save();
                        Provider.of<Recognizers>(context, listen: false)
                            .refreshRecognizers();
                      }
                    }
                    isBeingAcceptedBottom = false;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  if (value.getDrag() && !isSelfDragging) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: 20,
                      child: Center(
                        child: Divider(
                          indent: isBeingAcceptedBottom ? 20 : 70,
                          endIndent: isBeingAcceptedBottom ? 20 : 70,
                          color: theme.primaryColor,
                          thickness: isBeingAcceptedBottom ? 3 : 1,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 20,
                    );
                  }
                },
              );
            }),
          ]),
        ),
      ),
    );
  }
}
