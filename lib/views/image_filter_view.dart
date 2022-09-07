import 'dart:io';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class ImageFilter extends StatefulWidget {
  const ImageFilter({super.key, required this.recognizedId});

  final int recognizedId;

  @override
  State<ImageFilter> createState() => _ImageFilterState();
}

//Charge l'image et les textBlocs dans le build
List<Widget> showPositioned(BuildContext context, int recognizedId) {
  var recognzers = context.read<Recognizers>();
  Recognizer recognizer = recognzers.getRecognizers()[recognizedId];

  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  double aspectRationWidth = recognizer.widthImage / width;
  double aspectRationHeight = recognizer.heightImage / height;

  List<Widget> positioned = List.empty(growable: true);

  positioned = recognizer
      .getTextBlock()
      .map((textBlock) => Positioned(
            left: textBlock.boundingBox.left.toDouble() / aspectRationWidth,
            top: textBlock.boundingBox.top.toDouble() / aspectRationHeight,
            width: textBlock.boundingBox.width.toDouble() / aspectRationWidth,
            height:
                textBlock.boundingBox.height.toDouble() / aspectRationHeight,
            child: GestureDetector(onTap: () {
              saveTextBlock(context, recognizedId,
                  recognizer.getTextBlock().indexOf(textBlock));
            }, onPanUpdate: (details) {
              saveTextBlock(context, recognizedId,
                  recognizer.getTextBlock().indexOf(textBlock));
            }, child:
                Consumer<Recognizers>(builder: (context, recognizers, child) {
              bool isSaved = recognizer.getSavedTextBlock().contains(textBlock);

              return IgnorePointer(
                ignoring: isSaved,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSaved
                        ? Color.fromARGB(30, 16, 16, 16)
                        : Color.fromARGB(125, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        color: Colors.white, width: 0.5 // red as border color
                        ),
                  ),
                ),
              );
            })),
          ))
      .toList();

  return positioned;
}

void saveTextBlock(BuildContext context, int recognizedId, int textBlockId) {
  var recognzers = context.read<Recognizers>();
  Recognizer recognizer = recognzers.getRecognizers()[recognizedId];

  recognizer.addSavedTextBlock(textBlockId);

  Provider.of<Recognizers>(context, listen: false).refreshRecognizers();
}

class _ImageFilterState extends State<ImageFilter> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var recognzers = context.read<Recognizers>();
    Recognizer recognizer = recognzers.getRecognizers()[widget.recognizedId];

    double aspectRationWidth = recognizer.widthImage / width;
    double aspectRationHeight = recognizer.heightImage / height;

    return Scaffold(
        body: Listener(
      onPointerMove: (event) {
        TextBlock? textBlock = recognizer.findTextBlockByCoordonates(
            event.position.dx * aspectRationWidth,
            event.position.dy * aspectRationHeight);
        if (textBlock != null) {
          recognizer
              .addSavedTextBlock(recognizer.getTextBlock().indexOf(textBlock));
          Provider.of<Recognizers>(context, listen: false).refreshRecognizers();
        }
      },
      child: Container(
        child: Stack(
          children: showPositioned(context, widget.recognizedId),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.file(File(recognizer.getFilePath())).image,
          ),
        ),
      ),
    ));
  }
}
