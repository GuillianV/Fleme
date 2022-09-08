import 'dart:io';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/views/image_filter_view.dart';
import 'package:fleme/views/image_recognized_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagesList extends StatelessWidget {
  const ImagesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Recognizers>(builder: (context, recognizers, child) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemCount: recognizers.getRecognizers().length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/image_filter', arguments: index);
            },
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.file(
                          File(recognizers.recognizer[index].getFilePath()))
                      .image,
                  fit: BoxFit.cover,
                ),
                color: Color.fromARGB(255, 192, 225, 253),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue[200]!,
                      offset: const Offset(2, 2),
                      blurRadius: 10,
                      spreadRadius: 1),
                  const BoxShadow(
                      color: Colors.white,
                      offset: const Offset(-2, -2),
                      blurRadius: 10,
                      spreadRadius: 1)
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
