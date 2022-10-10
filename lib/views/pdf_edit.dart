import 'dart:async';
import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final pdf = pw.Document();
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  late File file;

  Future<PDFDocument?> cretePdf() async {
    // pdf.addPage(pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.Stack(children: [
    //         pw.Positioned(
    //           top: 0,
    //           left: 0,
    //           child: pw.Container(
    //             width: 200,
    //             height: 200,
    //             color: PdfColors.red,
    //           ),
    //         ),
    //         pw.Container(
    //           width: 200,
    //           height: 200,
    //           color: PdfColors.red,
    //         ),
    //         pw.Container(
    //           width: 100,
    //           height: 100,
    //           color: PdfColors.green,
    //         ),
    //       ]);
    //       // Center
    //     }));

    // Directory dir = Directory.fromUri(Uri.parse('storage/emulated/0/'));
    //  Directory dir = Directory((Platform.isAndroid
    //         ? await getExternalStorageDirectory() //FOR ANDROID
    //         : await getApplicationSupportDirectory()

    Directory dir = Directory(
        '${(Platform.isAndroid ? "storage/emulated/0" : await getApplicationSupportDirectory())}/Fleme');

    // var status = await Permission.storage.request();
    // var status2 = await Permission.manageExternalStorage.request();
    // var status3 = await Permission.accessMediaLocation.request();
    // var status = await Permission.storage.request();

    var state = await Permission.manageExternalStorage.status;
    var state2 = await Permission.storage.status;

    if (!state2.isGranted) {
      await Permission.storage.request();
    }
    if (!state.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    File file = File("${dir.path}/Dacture-1.pdf");
    return await PDFDocument.fromFile(file);

    // file = File("example.pdf");
    // await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: FutureBuilder<PDFDocument?>(
            future: cretePdf(), // async work
            builder:
                (BuildContext context, AsyncSnapshot<PDFDocument?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Loading....');
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data != null) {
                      return PDFViewer(
                        document: snapshot.data!,
                        zoomSteps: 1,
                        //uncomment below line to preload all pages
                        // lazyLoad: false,
                        // uncomment below line to scroll vertically
                        // scrollDirection: Axis.vertical,

                        //uncomment below code to replace bottom navigation with your own
                        /* navigationBuilder:
                            (context, page, totalPages, jumpToPage, animateToPage) {
                          return ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.first_page),
                                onPressed: () {
                                  jumpToPage()(page: 0);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () {
                                  animateToPage(page: page - 2);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  animateToPage(page: page);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.last_page),
                                onPressed: () {
                                  jumpToPage(page: totalPages - 1);
                                },
                              ),
                            ],
                          );
                        }, */
                        //      );,
                      );
                    } else {
                      return const Text('Error');
                    }
                  }
              }
            },
          ),
        ),
      ),
    );
    // return Container(
    //   child: FutureBuilder<PDFDocument>(
    //     future: cretePdf(), // async work
    //     builder: (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.waiting:
    //           return const Text('Loading....');
    //         default:
    //           if (snapshot.hasError) {
    //             return Text('Error: ${snapshot.error}');
    //           } else {
    //             return Container(
    //               child: const Text("Test"),
    //             );
    //           }
    //       }
    //     },
    //   ),
    // );
  }
}


// PDFViewer(
//                   document: snapshot.data!,
//                   zoomSteps: 1,
                  //uncomment below line to preload all pages
                  // lazyLoad: false,
                  // uncomment below line to scroll vertically
                  // scrollDirection: Axis.vertical,

                  //uncomment below code to replace bottom navigation with your own
                  /* navigationBuilder:
                          (context, page, totalPages, jumpToPage, animateToPage) {
                        return ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: () {
                                jumpToPage()(page: 0);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                animateToPage(page: page - 2);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                animateToPage(page: page);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: () {
                                jumpToPage(page: totalPages - 1);
                              },
                            ),
                          ],
                        );
                      }, */
          //      );