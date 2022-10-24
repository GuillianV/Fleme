import 'dart:io';

import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/models/recognizerNetwork.dart';
import 'package:fleme/models/recognizer_block.dart';
import 'package:fleme/widgets/resume_widget.dart';
import 'package:fleme/widgets/saved_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageRecognized extends StatefulWidget {
  const ImageRecognized({super.key, required this.recognizedId});

  final int recognizedId;

  @override
  State<ImageRecognized> createState() => _ImageRecognizedState();
}

class _ImageRecognizedState extends State<ImageRecognized> {
  bool isTextBlocks = true;
  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String description = '';
    TextEditingController controller = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Recognizers recognizers = Provider.of<Recognizers>(context, listen: false);
    Recognizer? recognizer = recognizers.getRecognizer(widget.recognizedId);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageResume(
                width: width,
                height: height,
                recognizedId: widget.recognizedId),
            if (isTextBlocks)
              Consumer<Recognizers>(builder: (context, recognizers, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  itemCount: recognizers
                          .getRecognizer(widget.recognizedId)
                          ?.getSavedTextBlock()
                          .length ??
                      0,
                  itemBuilder: (context, index) {
                    Recognizerblock textBlock = recognizers
                        .getRecognizer(widget.recognizedId)!
                        .getSavedTextBlock()[index];

                    return SavedBlockItem(
                      recognizedId: widget.recognizedId,
                      textBlockId: textBlock.id,
                      text: textBlock.getTextEdited() ?? "",
                    );
                  },
                );
              }),
            Container(
              height: 100,
            )
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
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.home, color: theme.colorScheme.secondary),
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
              backgroundColor: Colors.red,
              child: const Icon(Icons.close, color: Colors.black),
            ),
            FloatingActionButton(
                heroTag: "link",
                backgroundColor: theme.colorScheme.primary,
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
                        backgroundColor:
                            const Color.fromARGB(255, 101, 101, 101),
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }

                  Recognizers recognzers = context.read<Recognizers>();
                  Recognizer? recognizer =
                      recognzers.getRecognizer(widget.recognizedId);
                  if (recognizer == null) Navigator.pushNamed(context, "/");

                  String text = "";
                  recognizer!.getSavedTextBlock().forEach((element) {
                    text += "${element.getTextEdited()}\n";
                  });
                  RecognizerNetwork recognizerNetwork =
                      await RecognizerNetwork.post(text);

                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      late String urlValue;
                      late Uri uri;
                      if (dotenv.env["BACK_SECURED"]! == 'false') {
                        urlValue =
                            "${dotenv.env['BACK_URL']!}:${dotenv.env['BACK_PORT']!}/${recognizerNetwork.url}";
                      } else if (dotenv.env["BACK_SECURED"]! == 'true') {
                        urlValue =
                            "${dotenv.env['BACK_URL']!}/${recognizerNetwork.url}";
                      }

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
                child: Icon(
                  Icons.link,
                  color: theme.colorScheme.secondary,
                )),
            FloatingActionButton(
                heroTag: "share",
                backgroundColor: theme.colorScheme.primary,
                onPressed: () async {
                  Recognizers recognzers = context.read<Recognizers>();
                  Recognizer? recognizer =
                      recognzers.getRecognizer(widget.recognizedId);
                  if (recognizer == null) Navigator.pushNamed(context, "/");

                  String text = "";
                  recognizer!.getSavedTextBlock().forEach((element) {
                    text += "${element.getTextEdited()}\n";
                  });
                  await Share.share(text);
                },
                child: Icon(Icons.share, color: theme.colorScheme.secondary)),
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
