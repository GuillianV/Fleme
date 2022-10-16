import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFManager {
  late Directory dir;
  late Document document;
  late File file;
  late String fullPath;
  String fileName = '';
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
    pdfManager.fileName = documentName;
    pdfManager.fullPath = "${dir.path}/$documentName.pdf";

    File pdfFile = File(pdfManager.fullPath);

    if (await pdfFile.exists()) {
      pdfManager.isCreated = true;
      pdfManager.file = pdfFile;
    }

    return pdfManager;
  }

  Future<bool> create() async {
    if (!isCreated) {
      file = File(fullPath);
      isCreated = true;
      await addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(16),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(fileName),
            );
          }));

      return true;
    }

    return false;
  }

  Future<void> addPage(pw.Page page, {int? pageNumber}) async {
    if (isCreated) document.addPage(page, index: pageNumber);
    await file.writeAsBytes(await document.save());
  }

  Future<void> editPage(int pageNumber, pw.Page page) async {
    if (isCreated) document.editPage(pageNumber, page);
    await file.writeAsBytes(await document.save());
  }
}
