import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MaterialApp(home: QrShareExample()));
}

class QrShareExample extends StatefulWidget {
  const QrShareExample({super.key});

  @override
  State<QrShareExample> createState() => _QrShareExampleState();
}

class _QrShareExampleState extends State<QrShareExample> {
  // We need this GlobalKey to find the RenderObject in the widget tree
  final GlobalKey _qrKey = GlobalKey();
  final String? _token = "Dastern-123-ABC";

  Future<void> _shareTokenWithQr() async {
    if (_token == null) return;

    try {
      // 1. Locate the render object for the RepaintBoundary.
      // This is the core of your request: finding where the widget "lives" in the engine.
      final boundary =
          _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        await Share.share("Token: $_token");
        return;
      }

      // 2. Rasterise the widget to a ui.Image at 3x density for crispness.
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // 3. Encode the ui.Image to PNG byte data.
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        await Share.share("Token: $_token");
        return;
      }
      final pngBytes = byteData.buffer.asUint8List();

      // 4. Write the PNG to a temporary file.
      final Directory tempDir = await getTemporaryDirectory();
      final File qrFile = await File(
        '${tempDir.path}/dastern_qr_$_token.png',
      ).create();
      await qrFile.writeAsBytes(pngBytes);

      // 5. Share the file via the native share sheet.
      await Share.shareXFiles([
        XFile(qrFile.path, mimeType: 'image/png'),
      ], text: "Check out my Dastern Token: $_token");
    } catch (e) {
      debugPrint("Error sharing: $e");
      if (mounted) {
        await Share.share("Token: $_token");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Image Capture")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // THE REPAINT BOUNDARY
            // This widget marks the part of the tree we want to "photograph"
            RepaintBoundary(
              key: _qrKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white, // Crucial: give it a background color
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImageView(
                      data: _token!,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "TOKEN: $_token",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _shareTokenWithQr,
              icon: const Icon(Icons.share),
              label: const Text("Share as Image"),
            ),
          ],
        ),
      ),
    );
  }
}
