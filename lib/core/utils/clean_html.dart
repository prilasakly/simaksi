import 'package:html_unescape/html_unescape.dart';

extension CleanHTML on String? {
  String cleanHtml() {
    if (this == null || this!.isEmpty) return '';

    var unescape = HtmlUnescape();
    String text = unescape.convert(this!);

    // 1. Ubah elemen list menjadi teks yang bisa dibaca
    // Mengganti <li> menjadi bullet point
    text = text.replaceAll(
      RegExp(r'<\s*li[^>]*>', caseSensitive: false),
      '\n• ',
    );

    // Mengganti <br> atau <p> menjadi baris baru
    text = text.replaceAll(
      RegExp(r'<\s*(br|p|div)[^>]*>', caseSensitive: false),
      '\n',
    );

    // 2. Hapus sisa tag HTML lainnya
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // 3. Bersihkan spasi berlebih dan baris kosong
    return text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n');
  }
}
