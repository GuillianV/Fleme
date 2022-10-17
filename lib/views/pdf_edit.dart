import 'dart:async';

import 'package:fleme/models/pdfManager.dart';
import 'package:fleme/widgets/precise_listner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key});

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  bool _isLoading = true;

  late PDFManager pdfManager;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    pdfManager = await PDFManager.init('test7_pdf');

    if (!pdfManager.isCreated) {
      await pdfManager.create();
    }

    setState(() => _isLoading = !pdfManager.isCreated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Fleme'),
            ),
            ListTile(
              title: const Text('Scan'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            )
          ],
        ),
      ),
      body: Center(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : const Reader(),
      ),
    );
  }
}

class Reader extends StatefulWidget {
  const Reader({super.key});

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  List<Positioned> positions = [];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InteractiveViewer(
      panEnabled: true,
      minScale: 0.5,
      maxScale: 4,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
            ),
            child: SizedBox(
              child: Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.9 * 1.414,
                      child: PreciseListener(
                        onSimpleTaped: (pointerDownEvent, pointerUpEvent) {
                          setState(() {
                            positions.add(Positioned(
                              left: pointerDownEvent.localPosition.dx,
                              top: pointerDownEvent.localPosition.dy,
                              child: Text(
                                'Clicked',
                                style: theme.textTheme.bodyText2,
                              ),
                            ));
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Stack(
                              children: positions,
                            )),
                      ))),
            )),
      ),
    );
  }
}



// Container(
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         height: MediaQuery.of(context).size.width * 0.9 * 1.141,
//                         child: const Text('test'),
//                       ),
//                     ),

// setState(() {
//                     pdfManager.addPage(pw.Page(
//                         pageFormat: PdfPageFormat.a4,
//                         margin: const pw.EdgeInsets.all(16),
//                         build: (pw.Context context) {
//                           return pw.Center(
//                             child: pw.Text('Helloqs dsss'),
//                           );
//                         }));

//                     loadDocument();
//                   });

// PDFView(
//                   filePath: pdfManager.file.path,
//                   onRender: (pages) {
//                     setState(() {
//                       pages = pages;
//                       isReady = true;
//                     });
//                   },
//                   onError: (error) {
//                     setState(() {
//                       errorMessage = error.toString();
//                     });
//                     print(error.toString());
//                   },
//                   onPageError: (page, error) {
//                     setState(() {
//                       errorMessage = '$page: ${error.toString()}';
//                     });
//                     print('$page: ${error.toString()}');
//                   },
//                   onViewCreated: (PDFViewController pdfViewController) {
//                     _controller.complete(pdfViewController);
//                   },
//                 ),
