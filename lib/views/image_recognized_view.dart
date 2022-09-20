import 'dart:io';
import 'dart:ui';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/models/recognizerNetwork.dart';
import 'package:fleme/widgets/image_resume_widget.dart';
import 'package:fleme/widgets/saved_block_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

                    int textBlockId =
                        recognizer!.getTextBlock().indexOf(textBlock);

                    return SavedBlockItem(
                      recognizedId: widget.recognizedId,
                      textBlockId: textBlockId,
                      text: recognizer?.getSavedTextEditedId(textBlockId) ?? "",
                    );
                  },
                );
              }),
            Container(
              height: 200,
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
