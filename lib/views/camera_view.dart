import 'dart:io';
import 'package:fleme/main.dart';
import 'package:fleme/models/providers/picture_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/views/homepage_view.dart';
import 'package:fleme/views/image_filter_view.dart';
import 'package:fleme/widgets/morphism_button.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../models/providers/recognizer_provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraPage({this.cameras, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController controller;
  XFile? pictureFile;
  double controllerRatio = 1.0;
  double deviceRatio = 1;
  bool showFocusCircle = false;
  double x = 0;
  double y = 0;
  bool isPicked = false;
  double zoom = 1.0;
  double maxZoomLevel = 1.0;
  double minZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras![0],
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controllerRatio = controller.value.previewSize!.height /
            controller.value.previewSize!.width;
      });

      controller.getMaxZoomLevel().then((value) => setState(() {
            maxZoomLevel = value;
          }));
      controller.getMinZoomLevel().then((value) => setState(() {
            minZoomLevel = value;
          }));
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final isLandscape = MediaQuery.of(context).orientation ==
        Orientation.landscape; // check if the orientation is landscape

    if (isLandscape) {
      deviceRatio = width / height;
      controllerRatio = (controller.value.previewSize?.width ?? 1) /
          (controller.value.previewSize?.height ?? 1);
    } else {
      deviceRatio = height / width;
      controllerRatio = (controller.value.previewSize?.height ?? 1) /
          (controller.value.previewSize?.width ?? 1);
    }

    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: GestureDetector(
        onTapUp: (details) {
          _onTap(details);
        },
        child: Stack(children: [
          Center(
            child: Transform.scale(
              scale: 1.2,
              child: Center(
                child: AspectRatio(
                  aspectRatio: controllerRatio,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.delta.dy > 0 && zoom < maxZoomLevel) {
                        setState(() {
                          zoom = zoom + 0.1;
                          controller.setZoomLevel(zoom);
                        });
                      }

                      if (details.delta.dy < 0 && zoom > 1.0) {
                        setState(() {
                          zoom = zoom - 0.1;
                          controller.setZoomLevel(zoom);
                        });
                      }
                    },
                    child: SizedBox(
                        width: width,
                        height: height,
                        child: CameraPreview(controller)),
                  ),
                ),
              ),
            ),
          ),
          if (showFocusCircle)
            Positioned(
                top: y - 20,
                left: x - 20,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5)),
                )),
          if (isPicked)
            Container(
                color: Colors.black54,
                child: Center(child: CircularProgressIndicator())),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MorphismButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.black54,
                size: 30.0,
                textDirection: TextDirection.ltr,
                semanticLabel:
                    'Icon', // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
              ),
              textValue: "Scan !",
              onTaped: () async {
                setState(() {
                  isPicked = true;
                });
                pictureFile = await controller.takePicture();
                if (pictureFile != null) {
                  var picture = context.read<Picture>();
                  picture.saveFilePath(pictureFile?.path ?? "");

                  Recognizer recognizer =
                      Recognizer.create(picture.getFilePath());
                  await recognizer.setTextBlock();
                  var recognizers = context.read<Recognizers>();
                  recognizers.addRecognizer(recognizer);

                  int recognizerIndex =
                      recognizers.getRecognizers().indexOf(recognizer);

                  setState(() {
                    isPicked = false;
                  });
                  Navigator.pushNamed(context, '/image_filter',
                      arguments: recognizerIndex);
                } else {
                  setState(() {
                    isPicked = false;
                  });
                  Navigator.pushNamed(context, '/');
                }

                // ignore: use_build_context_synchronously
              }),
        ],
      ),
    );
  }

  Future<void> _onTap(TapUpDetails details) async {
    if (controller.value.isInitialized) {
      showFocusCircle = true;
      x = details.localPosition.dx;
      y = details.localPosition.dy;

      double fullWidth = MediaQuery.of(context).size.width;
      double cameraHeight = fullWidth * controller.value.aspectRatio;

      double xp = (x / fullWidth).clamp(0, 1.0);
      double yp = (y / cameraHeight).clamp(0, 1.0);

      Offset point = Offset(xp, yp);
      print("point : $point");

      // Manually focus
      await controller.setFocusPoint(point);

      // Manually set light exposure
      //controller.setExposurePoint(point);

      setState(() {
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          setState(() {
            showFocusCircle = false;
          });
        });
      });
    }
  }
}
