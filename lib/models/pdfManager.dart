import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFManager {
  late Directory dir;
  late Document document;
  late File file;
  late PDFDocument pdfDocument;
  bool isLoad = false;

  PDFManager(this.dir, this.document);

  static Future<PDFManager?> create(String documentName) async {
    var manageExternalStorage = await Permission.manageExternalStorage.status;
    var storage = await Permission.storage.status;

    if (!storage.isGranted) {
      await Permission.storage.request();
      if (!storage.isGranted) {
        return null;
      }
    }
    if (!manageExternalStorage.isGranted) {
      await Permission.manageExternalStorage.request();
      if (!manageExternalStorage.isGranted) {
        return null;
      }
    }

    Directory dir = Directory(
        '${(Platform.isAndroid ? "storage/emulated/0" : await getApplicationSupportDirectory())}');

    var pdf = pw.Document();

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    PDFManager manager = PDFManager(dir, pdf);
    if (await manager._load(documentName)) {
      return manager;
    }
    return null;
  }

  Future<bool> _load(String documentName) async {
    file = File('${dir.path}/$documentName.pdf');
    isLoad = true;
    if (!file.existsSync()) {
      await addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text('Hello World'),
            );
          }));
    }

    pdfDocument = await PDFDocument.fromFile(file);
    return true;
  }

  Future<void> addPage(pw.Page page, {int? pageNumber}) async {
    if (isLoad) document.addPage(page, index: pageNumber);
    await file.writeAsBytes(await document.save());
  }

  Future<void> editPage(int pageNumber, pw.Page page) async {
    if (isLoad) document.editPage(pageNumber, page);
    await file.writeAsBytes(await document.save());
  }
}
