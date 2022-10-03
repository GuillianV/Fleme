import 'dart:io';

import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/theme/box_shadow.dart';
import 'package:fleme/widgets/blur_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanList extends StatelessWidget {
  const ScanList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Consumer<Recognizers>(builder: (context, recognizers, child) {
      return recognizers.getRecognizers().isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Image.asset("assets/images/fleme.png"),
                  Text("Fleme".toUpperCase(), style: theme.textTheme.headline1),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.2, 0, width * 0.2, 0),
                    child: Text(
                        "Scannez votre environnement pour détecter du texte et vous l'envoyer. Appuyez sur le bouton en bas a droite pour commencer !",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyText2),
                  )
                ])
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              itemCount: recognizers.getRecognizers().length,
              itemBuilder: (context, index) {
                Recognizer? recognizerCible = recognizers.getRecognizer(index);

                if (recognizerCible == null) {
                  return Container();
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/image_recognized',
                        arguments: index);
                  },
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: recognizers.getRecognizer(index) != null
                            ? Image.file(File(recognizers
                                    .getRecognizer(index)!
                                    .getFilePath()))
                                .image
                            : Image.asset("assets/images/fleme.png").image,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: box_shadow(context),
                    ),
                    child: BlurTitle(
                        text:
                            "${recognizerCible.getBlockRecognized().length} Blocks"),
                  ),
                );
              },
            );
    });
  }
}
