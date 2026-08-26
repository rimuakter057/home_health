

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:ezygut/feature/patient/food_log/barcode/presentation/screens/scan_result_screen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  // 1. Controller create kora
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // Duplicate thamanor jonno
    returnImage: false, // Image return na korle memory-te chap kom pore
  );

  // 2. Scan status check korar flag
  bool _isNavigationInProgress = false;

  @override
  void dispose() {
    _controller.dispose(); // Memory leak thamanor jonno dispose kora must
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      controller: _controller,

      // ── Custom AppBar ──
      appBarBuilder: (context, controller) => AppBar(
        backgroundColor: Colors.black,
        title: const Text('Scan Barcode', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () => controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white),
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),

      galleryButtonType: GalleryButtonType.icon,

      // ── Main Logic ──
      onDetect: (barcodeCapture) async {
        // Jodi agei scan hoye thake ba navigation cholte thake, tobe stop koro
        if (_isNavigationInProgress) return;

        final barcodes = barcodeCapture.barcodes;
        if (barcodes.isNotEmpty) {
          final String? code = barcodes.first.rawValue;

          if (code != null) {
            // Flag true kore dao jeno bar bar onDetect trigger na hoy
            _isNavigationInProgress = true;

            // ── IMPORTANT: Camera-ke ekhane stop koro ──
            // Eta korle buffer overload hobe na ebong ImageReader_JNI error asbe na
            await _controller.stop();

            debugPrint('Scanned Barcode Success: $code');

            if (!mounted) return;

            // Result Screen-e jaoa
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  barcodeValue: code,
                  onGoToFoodLog: () {
                    // সব screen বন্ধ করে MainScreen এর FoodLog tab এ যাও
                    Navigator.popUntil(context, (route) => route.isFirst);
                    // তারপর FoodLog tab switch করো
                  },
                ),
              ),
            );

            // Result screen theke back korle abar scanner chalu hobe
            _isNavigationInProgress = false;
            await _controller.start();
          }
        }
      },

      validator: (value) => value.barcodes.isNotEmpty,
    );
  }
}