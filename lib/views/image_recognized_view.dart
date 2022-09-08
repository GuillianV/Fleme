import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/views/camera_view.dart';
import 'package:fleme/widgets/images_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class ImageRecognized extends StatefulWidget {
  const ImageRecognized({super.key, required this.recognizedId});

  final int recognizedId;

  @override
  State<ImageRecognized> createState() => _ImageRecognizedState();
}

class _ImageRecognizedState extends State<ImageRecognized> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Expanded(
            child:
                Consumer<Recognizers>(builder: (context, recognizers, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: width,
                    height: height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.file(File(recognizers
                                .recognizer[widget.recognizedId]
                                .getFilePath()))
                            .image,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemCount: recognizers.recognizer[widget.recognizedId]
                        .getTextBlock()
                        .length,
                    itemBuilder: (context, index) {
                      TextBlock textBlock = recognizers
                          .recognizer[widget.recognizedId]
                          .getTextBlock()[index];

                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Text(textBlock.text),
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
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
                  )
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await availableCameras().then((value) =>
              Navigator.pushNamed(context, '/camera', arguments: value));
        },
        tooltip: 'Picture',
        child: const Icon(Icons.image),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
