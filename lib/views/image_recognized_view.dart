import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/models/recognizerNetwork.dart';
import 'package:fleme/utils/shadow_black.dart';
import 'package:fleme/views/camera_view.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:fleme/widgets/image_resume_widget.dart';
import 'package:fleme/widgets/morphism_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fleme/widgets/images_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class ImageRecognized extends StatefulWidget {
  const ImageRecognized({super.key, required this.recognizedId});

  final int recognizedId;

  @override
  State<ImageRecognized> createState() => _ImageRecognizedState();
}

class _ImageRecognizedState extends State<ImageRecognized> {
  bool isTextBlocks = true;

  @override
  Widget build(BuildContext context) {
    String description = '';
    TextEditingController controller = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Recognizers recognizers = Provider.of<Recognizers>(context, listen: false);
    Recognizer? recognizer = recognizers.getRecognizer(widget.recognizedId);

    String markdown = '';
    if (recognizer != null && recognizer!.getMarkedText() == '') {
      recognizer.getSavedTextBlock().forEach((element) {
        markdown += element.text;
      });

      recognizer.setMarkedText(markdown);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageResume(
                width: width,
                height: height,
                recognizedId: widget.recognizedId),
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.white10,
                      offset: Offset(2, 2),
                      blurRadius: 10,
                      spreadRadius: 1),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MorphismButton(
                        textValue: "RawText",
                        onTaped: () {
                          setState(() {
                            isTextBlocks = false;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MorphismButton(
                        textValue: "Text Blocks",
                        onTaped: () {
                          setState(() {
                            isTextBlocks = true;
                          });
                        }),
                  )
                ],
              ),
            ),
            if (isTextBlocks)
              Consumer<Recognizers>(builder: (context, recognizers, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: recognizers
                          .getRecognizer(widget.recognizedId)
                          ?.getSavedTextBlock()
                          .length ??
                      0,
                  itemBuilder: (context, index) {
                    TextBlock textBlock = recognizers
                        .getRecognizer(widget.recognizedId)!
                        .getSavedTextBlock()[index];

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: Text(textBlock.text),
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 239, 238, 238),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: shadowBlack(),
                        ),
                      ),
                    );
                  },
                );
              }),
            if (!isTextBlocks)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MarkdownTextInput(
                      (String value) {
                        Recognizers recognizers = context.read<Recognizers>();
                        Recognizer? recognizer =
                            recognizers.getRecognizer(widget.recognizedId);
                        if (recognizer != null) {
                          recognizer.setMarkedText(value);
                          recognizers.refreshRecognizers();
                        }
                      },
                      recognizer!.getMarkedText(),
                      label: 'Text',
                      maxLines: 10,
                      actions: MarkdownType.values,
                      controller: controller,
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 239, 238, 238),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: shadowBlack(),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Consumer<Recognizers>(
                              builder: (context, recognizers, child) {
                            Recognizer? recognizer =
                                recognizers.getRecognizer(widget.recognizedId);

                            if (recognizer != null) {
                              return MarkdownBody(
                                data: recognizer.getMarkedText(),
                                shrinkWrap: true,
                              );
                            } else
                              return Container();
                          })),
                    ),
                    SizedBox(
                      height: 300,
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
              heroTag: "home",
              onPressed: () {
                // recognzers.removeRecognizerById(widget.recognizedId);
                Navigator.pushNamed(context, "/");
              },
              child: const Icon(Icons.home, color: Colors.black87),
              backgroundColor: Colors.white,
            ),
            FloatingActionButton(
              heroTag: "delete_image_r",
              onPressed: () {
                // recognzers.removeRecognizerById(widget.recognizedId);

                Navigator.pushNamed(context, "/");
                Recognizers recognzers = context.read<Recognizers>();
                recognzers.removeRecognizerById(widget.recognizedId,
                    refresh: false);
              },
              child: const Icon(Icons.close, color: Colors.white70),
              backgroundColor: Colors.red,
            ),
            FloatingActionButton(
                heroTag: "link",
                onPressed: () async {
                  bool connected = false;
                  final result = await InternetAddress.lookup("google.com");

                  try {
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      connected = true;
                    }
                  } on SocketException catch (_) {
                    print('not connected');
                  }

                  if (!connected) {
                    Fluttertoast.showToast(
                        msg: "Error: No internet connection",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color.fromARGB(255, 101, 101, 101),
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }

                  Recognizers recognzers = context.read<Recognizers>();
                  Recognizer? recognizer =
                      recognzers.getRecognizer(widget.recognizedId);
                  if (recognizer == null) Navigator.pushNamed(context, "/");

                  String _text = recognizer!
                      .getSavedTextBlock()
                      .map((e) => e.text)
                      .join(" ");
                  RecognizerNetwork recognizerNetwork =
                      await RecognizerNetwork.post(_text);

                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      String urlValue =
                          "${dotenv.env['BACK_URL']!}:${dotenv.env['BACK_PORT']!}/${recognizerNetwork.url}";

                      ClipboardData data = ClipboardData(text: urlValue);
                      Clipboard.setData(data);

                      return ClassicGeneralDialogWidget(
                        titleText: "Link Copied",
                        negativeText: 'Close',
                        positiveText: 'Check',
                        contentText: urlValue,
                        onPositiveClick: () async {
                          Uri uri = Uri.parse(
                              "${dotenv.env["BACK_SECURED"]! == 'false' ? 'http://' : 'https://'}$urlValue");
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);

                          Navigator.of(context).pop();
                        },
                        onNegativeClick: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                child: const Icon(Icons.link)),
            FloatingActionButton(
                heroTag: "share",
                onPressed: () async {
                  Recognizers recognzers = context.read<Recognizers>();
                  Recognizer? recognizer =
                      recognzers.getRecognizer(widget.recognizedId);
                  if (recognizer == null) Navigator.pushNamed(context, "/");

                  String _text = recognizer!
                      .getSavedTextBlock()
                      .map((e) => e.text)
                      .join(" ");
                  await Share.share(_text);
                },
                child: const Icon(Icons.share)),
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
