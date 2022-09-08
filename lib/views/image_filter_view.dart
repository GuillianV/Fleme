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

double width = 0;
double height = 0;

double containerWidth = 0;
double containerHeight = 0;

late Recognizers recognzers;
late Recognizer recognizer;

double aspectRationWidth = 1;
double aspectRationHeight = 1;

class _ImageFilterState extends State<ImageFilter> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    containerWidth = width * 1;
    containerHeight = height * 1;

    recognzers = context.read<Recognizers>();
    recognizer = recognzers.getRecognizers()[widget.recognizedId];

    aspectRationWidth = recognizer.widthImage / containerWidth;
    aspectRationHeight = recognizer.heightImage / containerHeight;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Listener(
            onPointerMove: (event) {
              TextBlock? textBlock = recognizer.findTextBlockByCoordonates(
                  event.position.dx * aspectRationWidth,
                  event.position.dy * aspectRationHeight);
              if (textBlock != null) {
                saveTextBlock(
                    context, recognizer.getTextBlock().indexOf(textBlock));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.file(File(recognizer.getFilePath())).image,
                ),
              ),
              child: Stack(
                children: showPositioned(context, widget.recognizedId),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: FloatingActionButton(
                heroTag: "delete",
                onPressed: () {
                  recognzers.removeRecognizerById(widget.recognizedId);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: FloatingActionButton(
                  heroTag: "save",
                  onPressed: () {
                    Navigator.pushNamed(context, '/image_recognized',
                        arguments: widget.recognizedId);
                  },
                  child: const Icon(Icons.save)),
            ),
          ]),
    );
  }

  //Charge les textBlocs en positionned
  List<Widget> showPositioned(BuildContext context, int recognizedId) {
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
                saveTextBlock(
                    context, recognizer.getTextBlock().indexOf(textBlock));
              }, onPanUpdate: (details) {
                saveTextBlock(
                    context, recognizer.getTextBlock().indexOf(textBlock));
              }, child:
                  Consumer<Recognizers>(builder: (context, recognizers, child) {
                bool isSaved =
                    recognizer.getSavedTextBlock().contains(textBlock);

                return IgnorePointer(
                  ignoring: isSaved,
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isSaved
                          ? const Color.fromARGB(30, 16, 16, 16)
                          : const Color.fromARGB(125, 255, 255, 255),
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

  void saveTextBlock(BuildContext context, int textBlockId) {
    recognizer.addSavedTextBlock(textBlockId);
    Provider.of<Recognizers>(context, listen: false).refreshRecognizers();
  }
}
