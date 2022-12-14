import 'package:camera/camera.dart';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/models/recognizer_block.dart';
import 'package:fleme/theme/box_shadow.dart';
import 'package:fleme/views/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TextBlockEdit extends StatefulWidget {
  const TextBlockEdit(
      {super.key, required this.recognizedId, required this.textBlockId});
  final int recognizedId;
  final int textBlockId;

  @override
  State<TextBlockEdit> createState() => _TextBlockEditState();
}

class _TextBlockEditState extends State<TextBlockEdit> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Recognizers recognizers = context.read<Recognizers>();
    Recognizer? recognizer = recognizers.getRecognizer(widget.recognizedId);
    Recognizerblock? textBlock =
        recognizer!.getSavedTextBlockById(widget.textBlockId);

    TextEditingController txtController = TextEditingController();
    txtController.text = textBlock.getTextEdited();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Text Editor",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(fontSize: 25))),
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(width * 0.2, 0, width * 0.2, 0),
                      child: Text("Modifiez le contenu de votre bloc de texte",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 12, letterSpacing: -0.5))),
                    )
                  ]),
              Container(
                margin: EdgeInsets.fromLTRB(
                    width * 0.1, height * 0.05, width * 0.1, 0),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  boxShadow: box_shadow(context),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: theme.backgroundColor,
                  border:
                      Border.all(color: theme.colorScheme.primary, width: 1),
                ),
                child: TextField(
                  controller: txtController,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  onChanged: (value) {
                    textBlock.setTextEdited(value);
                  },
                  style: GoogleFonts.poppins(
                      textStyle:
                          const TextStyle(fontSize: 12, letterSpacing: -0.5)),
                  maxLines: null,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        onPressed: () async {
          await availableCameras().then((value) => Navigator.pop(context));
        },
        tooltip: 'Back',
        child: Icon(
          Icons.arrow_back,
          color: theme.colorScheme.secondary,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
