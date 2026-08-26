import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
class DownloadHelper {
  DownloadHelper._(); // ✅ instance বানানো যাবে না
///use  url========
  static Future<bool> downloadFile({
    required String url,
    required BuildContext context,
    String? customFileName,
  }) async
  {
    try {
      final dio = Dio();
      final fileName = customFileName ?? url.split('/').last.split('?').first;

      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final savePath = "${dir!.path}/$fileName";

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
              "Progress: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );

      // Media Scanner
      await Process.run('am', [
        'broadcast',
        '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        '-d', 'file://$savePath',
      ]);

      debugPrint("Saved to: $savePath");
      return true;
    } catch (e) {
      debugPrint("Download error: $e");
      return false;
    }
  }
  ///use byte



  static Future<bool> downloadPdfBytes({
    required Uint8List pdfBytes,
    required BuildContext context,
    String fileName = 'report.pdf',
  }) async {
    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final savePath = "${dir!.path}/$fileName";
      final file = File(savePath);
      await file.writeAsBytes(pdfBytes); // ✅ bytes সরাসরি লিখবে

      // Media Scanner
      await Process.run('am', [
        'broadcast',
        '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        '-d', 'file://$savePath',
      ]);

      debugPrint("Saved to: $savePath");
      return true;
    } catch (e) {
      debugPrint("Download error: $e");
      return false;
    }
  }


}