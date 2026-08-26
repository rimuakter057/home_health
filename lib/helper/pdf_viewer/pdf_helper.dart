import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfHelper {
  PdfHelper._();

  static Widget buildPdfViewer({
    required Uint8List pdfBytes,
    double heightFactor = 0.45,
  }) {
    if (pdfBytes.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final pdfHeight = MediaQuery.of(context).size.height * heightFactor;
        return  Container(
            height: pdfHeight,
            width: double.infinity,
            color: Colors.white,

            child: SfPdfViewer.memory(pdfBytes));

      },
    );
  }
}