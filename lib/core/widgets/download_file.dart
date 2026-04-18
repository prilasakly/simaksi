import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> downloadFile({
  required String url,
  required String fileName,
  required String extension, // pdf / pptx
}) async {
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/$fileName.$extension';

  final dio = Dio();

  try {
    await dio.download(url, filePath);

    // buka file setelah download
    await OpenFilex.open(filePath);
  } catch (e) {
    print('Download error: $e');
  }
}

String safeFileName(String name) {
  return name
      .replaceAll(RegExp(r'[^\w\s-]'), '') // hapus karakter aneh
      .replaceAll(' ', '_'); // ganti spasi jadi _
}
