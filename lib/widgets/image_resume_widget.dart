import 'dart:io';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/widgets/blur_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageResume extends StatelessWidget {
  const ImageResume({
    Key? key,
    required this.width,
    required this.height,
    required this.recognizedId,
  }) : super(key: key);

  final double width;
  final double height;
  final int recognizedId;

  @override
  Widget build(BuildContext context) {
    return Consumer<Recognizers>(builder: (context, recognizers, child) {
      Recognizer? recognizer = recognizers.getRecognizer(recognizedId);
      if (recognizer == null) Navigator.pushNamed(context, "/");

      return Container(
        width: width,
        height: height * 0.3,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: recognizer != null
                ? Image.file(File(recognizer!.getFilePath())).image
                : Image.asset("assets/images/fleme.png").image,
          ),
        ),
        // ignore: unnecessary_null_comparison
        child: recognizers.exists(recognizedId) != null
            ? BlurTitle(
                text: "${recognizer!.getBlockRecognized().length} blocks")
            : null,
      );
    });
  }
}
