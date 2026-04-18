import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  /// Membuka URL ke browser eksternal.
  /// Parameter [context] bersifat opsional, hanya jika ingin menampilkan SnackBar error.
  static Future<void> launch(String urlString, {BuildContext? context}) async {
    final Uri uri = Uri.parse(urlString);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak bisa membuka link: $urlString';
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka link: $urlString'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
