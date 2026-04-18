import 'package:html_unescape/html_unescape.dart';

extension CleanHTML on String? {
  /// Fungsi untuk membersihkan HTML tags dan unescape entities
  String cleanHtml() {
    if (this == null || this!.isEmpty) return '';

    // 1. Decode HTML Entities (&lt; -> <, dll)
    var unescape = HtmlUnescape();
    String decoded = unescape.convert(this!);

    // 2. Hapus tag HTML, bersihkan spasi, dan trim
    return decoded
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('\n\n\n', '\n')
        .trim();
  }
}
