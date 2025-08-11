import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:archive/archive.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<dynamic> readJsonFile(fileName) async {
  final String response = await rootBundle.loadString(
    'assets/json/$fileName.json',
  );
  final data = json.decode(response);
  return data;
}

Future<int> getJuzOfAyah(
  int surahNumber,
  int ayahNumber,
  dynamic ayahData,
) async {
  print(ayahData);
  try {
    print('getJuzOfAyah: surahNumber: $surahNumber, ayahNumber: $ayahNumber');
    print('ayahData type: ${ayahData.runtimeType}');
    print(
      'ayahData length: ${ayahData is List ? ayahData.length : 'Not a list'}',
    );

    if (ayahData is List && ayahData.isNotEmpty) {
      // التحقق من صحة السورة
      if (surahNumber < 1 || surahNumber > ayahData.length) {
        print('Invalid surah number: $surahNumber (max: ${ayahData.length})');
        return -1;
      }

      final surahData = ayahData[surahNumber - 1];
      print('surahData: $surahData');

      if (surahData != null && surahData["ayahs"] is List) {
        final juzList = surahData["ayahs"] as List;

        // التحقق من صحة رقم الآية
        if (ayahNumber < 1 || ayahNumber > juzList.length) {
          print('Invalid ayah number: $ayahNumber (max: ${juzList.length})');
          return -1;
        }

        final juzData = juzList[ayahNumber - 1];
        return juzData['juz'] ?? -1;
      }
    }

    print('Invalid data structure in ayahData');
    return -1;
  } catch (e) {
    print('Error in getJuzOfAyah: $e');
    return -1;
  }
}

Future<bool> isAyahMemorized(
  int surahNumber,
  int ayahNumber,
  dynamic box,
) async {
  try {
    final session = box.values.firstWhereOrNull(
      (session) =>
          session.surahNumber == surahNumber.toString() &&
          session.fromAyah <= ayahNumber &&
          session.toAyah >= ayahNumber,
    );
    return session != null;
  } catch (e) {
    print('Error in isAyahMemorized: $e');
    return false;
  }
}

Future<int> getTotalAyahsInJuz(int juzNumber) async {
  final data = await readJsonFile('juz_data');
  return data[juzNumber - 1]['ayah_count'] ?? 0;
}

String compressData(Map<String, dynamic> data) {
  final jsonStr = jsonEncode(data);
  final bytes = utf8.encode(jsonStr);
  final compressed = GZipEncoder().encode(bytes);
  return base64Encode(compressed!);
}

Map<String, dynamic> decompressData(String compressedStr) {
  final compressed = base64Decode(compressedStr);
  final bytes = GZipDecoder().decodeBytes(compressed);
  return jsonDecode(utf8.decode(bytes));
}

Future<Uint8List> generateCompressedQR(Map<String, dynamic> data) async {
  final compressed = compressData(data);

  // تحقق من أن البيانات بعد الضغط مناسبة لـ QR
  if (compressed.length > 2953) {
    throw Exception('البيانات كبيرة جداً حتى بعد الضغط');
  }

  final qrPainter = QrPainter(
    data: compressed,
    version: QrVersions.auto, // سيختار الإصدار المناسب تلقائياً
    errorCorrectionLevel: QrErrorCorrectLevel.H, // أعلى تصحيح أخطاء
  );

  return (await qrPainter.toImageData(300))!.buffer.asUint8List();
}
