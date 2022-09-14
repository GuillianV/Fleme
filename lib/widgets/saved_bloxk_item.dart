import 'package:fleme/utils/shadow_black.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class SavedBlockItem extends StatefulWidget {
  const SavedBlockItem(
      {super.key, required this.recognizedId, required this.textBlock});

  final int recognizedId;
  final TextBlock textBlock;

  @override
  State<SavedBlockItem> createState() => _SavedBlockItemState();
}

class _SavedBlockItemState extends State<SavedBlockItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTapDown: (details) {},
          onTapUp: (details) {},
          child: Text(widget.textBlock.text)),
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 239, 238, 238),
        borderRadius: BorderRadius.circular(5),
        boxShadow: shadowBlack(),
      ),
    );
  }
}
