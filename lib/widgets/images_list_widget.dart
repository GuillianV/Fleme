import 'dart:io';
import 'package:fleme/models/providers/recognizer_provider.dart';
import 'package:fleme/models/recognizer.dart';
import 'package:fleme/views/image_filter_view.dart';
import 'package:fleme/views/image_recognized_view.dart';
import 'package:fleme/widgets/blur_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ImagesList extends StatelessWidget {
  const ImagesList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Consumer<Recognizers>(builder: (context, recognizers, child) {
      return recognizers.getRecognizers().isEmpty
          ? Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/fleme.png"),
                    Text("Fleme".toUpperCase() + " Application !",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 25))),
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(width * 0.2, 0, width * 0.2, 0),
                      child: Text(
                          "Scannez votre environnement pour détecter du text et vous l'envoyer. Appuyez sur le bouton en bas a droite pour commencer !",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12, letterSpacing: -0.5))),
                    )
                  ]),
            )
          : ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
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
                      color: const Color.fromARGB(255, 192, 225, 253),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black87,
                            offset: Offset(2, 2),
                            blurRadius: 10,
                            spreadRadius: 1),
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(-2, -2),
                            blurRadius: 10,
                            spreadRadius: 1)
                      ],
                    ),
                    child: BlurTitle(
                        text:
                            "${recognizerCible.getTextBlock().length} Blocks"),
                  ),
                );
              },
            );
    });
  }
}
