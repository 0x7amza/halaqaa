import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerDialog extends StatefulWidget {
  const QRScannerDialog({super.key});

  @override
  State<QRScannerDialog> createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<QRScannerDialog> {
  bool _isScanning = true;
  MobileScannerController controller = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    final String? code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() {
      _isScanning = false;
    });
    controller.stop();

    if (true) {
      Navigator.pop(context); // إغلاق دايلوق الكاميرا
      _showProcessingDialog(code);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("البيانات غير صحيحة!")));
      Navigator.pop(context); // إغلاق دايلوق الكاميرا
    }
  }

  void _showProcessingDialog(String data) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("معالجة البيانات"),
        content: Text("تم قراءة البيانات: $data"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إغلاق"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building QRScannerDialog');
    return AlertDialog(
      title: const Text("امسح الكود"),
      content: SizedBox(
        width: 300,
        height: 300,
        child: MobileScanner(controller: controller, onDetect: _onDetect),
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.stop();
            Navigator.pop(context);
          },
          child: const Text("إلغاء"),
        ),
      ],
    );
  }
}

// طريقة الاستدعاء من أي مكان في الكود
void openQRScanner(BuildContext context) {
  showDialog(context: context, builder: (_) => const QRScannerDialog());
}
