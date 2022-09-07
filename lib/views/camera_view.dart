import 'dart:io';
import 'package:fleme/main.dart';
import 'package:fleme/models/picture.dart';
import 'package:fleme/widgets/morphism_button.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Transform.scale(
          scale: 1.2,
          child: Center(
            child: AspectRatio(
              aspectRatio: controllerRatio,
              child: SizedBox(
                  width: width,
                  height: height,
                  child: CameraPreview(controller)),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MorphismButton(
          textValue: "Scan !",
          onTaped: () async {
            pictureFile = await controller.takePicture();
            if (pictureFile != null) {
              var picture = context.read<Picture>();
              picture.saveFilePath(pictureFile?.path ?? "");
            }
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(
                  title: "Fleme",
                ),
              ),
            );
          }),
    );
  }
}
