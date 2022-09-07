import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/views/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class ImageFilter extends StatefulWidget {
  const ImageFilter({super.key, required this.recognizedId});

  final int recognizedId;

  @override
  State<ImageFilter> createState() => _ImageFilterState();
}

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
      .map((textBlock) => new Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(85, 158, 218, 255),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            left: textBlock.boundingBox.left.toDouble() / aspectRationWidth,
            top: textBlock.boundingBox.top.toDouble() / aspectRationHeight,
            width: textBlock.boundingBox.width.toDouble() / aspectRationWidth,
            height:
                textBlock.boundingBox.height.toDouble() / aspectRationHeight,
          ))
      .toList();

  return positioned;
}

class _ImageFilterState extends State<ImageFilter> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var recognzers = context.read<Recognizers>();
    Recognizer recognizer = recognzers.getRecognizers()[widget.recognizedId];

    return Scaffold(
        body: Container(
      child: Stack(
        children: showPositioned(context, widget.recognizedId),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: Image.file(File(recognizer.getFilePath())).image,
        ),
      ),
    ));
  }
}
