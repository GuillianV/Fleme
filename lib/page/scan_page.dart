import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fleme/models/providers/picture_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/widgets/morphism_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/recognizer_provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Future<bool> cameraInitialized = Future.value(false);

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
    loadCamera();
  }

  loadCamera() async {
    await availableCameras().catchError((onError) {
      exit(1);
    }).then((cameras) {
      controller = CameraController(
        cameras[0],
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

          cameraInitialized = Future.value(true);
        });

        controller.getMaxZoomLevel().then((value) => setState(() {
              maxZoomLevel = value;
            }));
        controller.getMinZoomLevel().then((value) => setState(() {
              minZoomLevel = value;
            }));
      });
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

    ThemeData themeActual = Theme.of(context);

    return FutureBuilder<bool>(
      future: cameraInitialized,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (isLandscape) {
            deviceRatio = width / height;
            controllerRatio = (controller.value.previewSize?.width ?? 1) /
                (controller.value.previewSize?.height ?? 1);
          } else {
            deviceRatio = height / width;
            controllerRatio = (controller.value.previewSize?.height ?? 1) /
                (controller.value.previewSize?.width ?? 1);
          }

          return Scaffold(
            body: GestureDetector(
              onTapUp: (details) {
                _onTap(details);
              },
              child: Stack(children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: controllerRatio,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy < 0 && zoom < maxZoomLevel) {
                          setState(() {
                            zoom = zoom + 0.1;
                            if (zoom > maxZoomLevel) zoom = maxZoomLevel;
                            controller.setZoomLevel(zoom);
                          });
                        }

                        if (details.delta.dy > 0 && zoom > 1.0) {
                          setState(() {
                            zoom = zoom - 0.1;
                            if (zoom < 1.0) zoom = 1;
                            controller.setZoomLevel(zoom);
                          });
                        }
                      },
                      child: SizedBox(
                          width: width,
                          height: height,
                          child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: CameraPreview(controller))),
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
                            border: Border.all(
                                color: themeActual.colorScheme.primary,
                                width: 1.5)),
                      )),
                if (isPicked)
                  Container(
                      color: Colors.black54,
                      child: const Center(child: CircularProgressIndicator())),
              ]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MorphismButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: themeActual.colorScheme.primary,
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
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Container(child: const CircularProgressIndicator()),
          );
        }
      },
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
