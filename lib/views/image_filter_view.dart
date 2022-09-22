import 'dart:io';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/models/recognizer_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
late Recognizer? recognizer;

double aspectRationWidth = 1;
double aspectRationHeight = 1;

class _ImageFilterState extends State<ImageFilter> {
  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    containerWidth = width * 0.9;
    containerHeight = height * 0.9;

    recognzers = context.read<Recognizers>();

    recognizer = recognzers.getRecognizer(widget.recognizedId);

    if (recognizer == null) Navigator.pushNamed(context, "/");

    aspectRationWidth = (recognizer?.widthImage ?? 1920) / containerWidth;
    aspectRationHeight = (recognizer?.heightImage ?? 1080) / containerHeight;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Listener(
            onPointerMove: (event) {
              Recognizerblock? textBlock = recognizer!
                  .findTextBlockByCoordonates(
                      event.localPosition.dx * aspectRationWidth,
                      event.localPosition.dy * aspectRationHeight);
              if (textBlock != null) {
                toggleTextBlockvoid(context, textBlock.id);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.file(
                    File(recognizer!.getFilePath()),
                  ).image,
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

    recognizer!.getBlockRecognized()?.forEach((blockRecognized) {
      Rect rect = blockRecognized.getBoundingBox();

      positioned.add(Positioned(
        left: rect.left.toDouble() / aspectRationWidth,
        top: rect.top.toDouble() / aspectRationHeight,
        width: rect.width.toDouble() / aspectRationWidth,
        height: rect.height.toDouble() / aspectRationHeight,
        child: Consumer<Recognizers>(builder: (context, recognizers, child) {
          bool isSaved =
              recognizer!.getSavedTextBlock().contains(blockRecognized);

          return GestureDetector(
            onTap: () => toggleTextBlockvoid(context, blockRecognized.id),
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
        }),
      ));
    });

    return positioned;
  }

  void toggleTextBlockvoid(BuildContext context, int textBlockId) {
    Recognizerblock? recognizerblock =
        recognizer!.getBlockRecognizedById(textBlockId);
    if (recognizerblock == null) {
      return;
    }

    if (!recognizerblock.getTimed()) {
      timedBlock(recognizerblock);
      recognizerblock.toggleSave();
      Provider.of<Recognizers>(context, listen: false).refreshRecognizers();
    }
  }

  void timedBlock(Recognizerblock recognizerblock) async {
    recognizerblock.busy();
    await Future.delayed(const Duration(milliseconds: 500), () {
      recognizerblock.free();
    });
  }
}
