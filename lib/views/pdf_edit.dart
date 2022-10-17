import 'dart:async';

import 'package:fleme/models/pdfManager.dart';
import 'package:fleme/widgets/precise_listner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
      appBar: AppBar(
        title: const Text('FlutterPluginPDFViewer'),
      ),
      body: Center(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PreciseListener(
                onSimpleTaped: (pointerDownEvent, pointerUpEvent) {
                  setState(() {
                    pdfManager.addPage(pw.Page(
                        pageFormat: PdfPageFormat.a4,
                        margin: const pw.EdgeInsets.all(16),
                        build: (pw.Context context) {
                          return pw.Center(
                            child: pw.Text('Helloqs dsss'),
                          );
                        }));

                    loadDocument();
                  });
                },
                child: PDFView(
                  filePath: pdfManager.file.path,
                  onRender: (pages) {
                    setState(() {
                      pages = pages;
                      isReady = true;
                    });
                  },
                  onError: (error) {
                    setState(() {
                      errorMessage = error.toString();
                    });
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    setState(() {
                      errorMessage = '$page: ${error.toString()}';
                    });
                    print('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _controller.complete(pdfViewController);
                  },
                ),
              ),
      ),
    );
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