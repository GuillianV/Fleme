import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFManager {
  late Directory dir;
  late Document document;
  late File pdfFile;
  late PDFDocument pdfDocument;
  bool isLoad = false;
  bool isCreated = false;

  PDFManager(this.dir, this.document);

  static Future<bool> getStoragePermission(BuildContext buildContext) async {
    PermissionStatus storage = await Permission.storage.status;
    if (storage.isGranted) return true;

    storage = await Permission.storage.request();
    if (storage.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> _getLocalDirectoryPath() async {
    String localPath = "";
    if (Platform.isAndroid) {
      localPath = (await getExternalStorageDirectory())?.path ?? "";
    } else if (Platform.isIOS) {
      localPath = (await getApplicationDocumentsDirectory()).path;
    }

    if (localPath == "") {
      throw Exception("Local path is empty");
    }

    return localPath;
  }

  static Future<PDFManager> init(String documentName) async {
    Directory dir = Directory(await _getLocalDirectoryPath());
    var pdf = pw.Document();
    if (!await dir.exists()) {
      throw Exception("Directory does not exist");
    }

    PDFManager pdfManager = PDFManager(dir, pdf);
    pdfManager.pdfFile = File('${dir.path}/$documentName.pdf');

    if (await pdfManager.pdfFile.exists()) {
      pdfManager.isCreated = true;
      pdfManager.pdfDocument = await PDFDocument.fromFile(pdfManager.pdfFile);
      // PDFDocument.fromFile(pdfManager.file).then((document) {
      //   pdfManager.pdfDocument = document;
      //   pdfManager.isLoad = true;
      // }).catchError((error) {
      //   throw Exception("Error while loading pdf");
      // });
    }

    return PDFManager(dir, pdf);
  }

  Future<bool> create() async {
    print(this);
    if (await !pdfFile?.exists() ?? false && !isCreated) {
      await addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(16),
          build: (pw.Context context) {
            return pw.Container();
          }));

      isCreated = true;
      pdfDocument = await PDFDocument.fromFile(pdfFile);
    }

    return false;
  }

  Future<bool> load() async {
    if (pdfFile.existsSync() && isCreated) {
      return PDFDocument.fromFile(pdfFile).then((document) {
        pdfDocument = document;
        isLoad = true;
        return true;
      }).catchError((error) {
        throw Exception("Error while loading pdf");
      });
    }

    return false;
  }

  Future<void> addPage(pw.Page page, {int? pageNumber}) async {
    if (isLoad) document.addPage(page, index: pageNumber);
    await pdfFile.writeAsBytes(await document.save());
  }

  Future<void> editPage(int pageNumber, pw.Page page) async {
    if (isLoad) document.editPage(pageNumber, page);
    await pdfFile.writeAsBytes(await document.save());
  }
}
