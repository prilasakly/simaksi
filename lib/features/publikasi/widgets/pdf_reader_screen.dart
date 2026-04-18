// lib/features/publikasi/screen/pdf_reader_screen.dart
import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart' show DeviceInfoPlugin;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart'
    show
        Permission,
        PermissionActions,
        PermissionStatus,
        PermissionStatusGetters,
        openAppSettings;

import '../../../core/theme/app_theme.dart';

class PdfReaderScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfReaderScreen({super.key, required this.pdfUrl, required this.title});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  String? _localPath;
  bool _isDownloading = true;
  double _downloadProgress = 0;
  String? _downloadError;

  final Completer<PDFViewController> _controllerCompleter = Completer();
  PDFViewController? _pdfController;

  int _currentPage = 0;
  int _totalPages = 0;

  bool _showSearch = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Download ──────────────────────────────────────────────
  Future<void> _downloadPdf() async {
    try {
      final bool granted = await _requestStoragePermission();
      if (!granted) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _downloadError =
                'Izin penyimpanan ditolak. Buka Pengaturan > Aplikasi > SIMAKSI > Izin untuk mengaktifkan.';
          });
        }
        return;
      }

      Directory? saveDir;
      if (Platform.isAndroid) {
        try {
          saveDir = Directory('/storage/emulated/0/Download');
          if (!await saveDir.exists()) {
            await saveDir.create(recursive: true);
          }
        } catch (_) {
          saveDir = await getExternalStorageDirectory();
          saveDir ??= await getApplicationDocumentsDirectory();
        }
      } else {
        saveDir = await getApplicationDocumentsDirectory();
      }

      if (saveDir == null) {
        throw Exception('Tidak dapat menemukan direktori penyimpanan');
      }

      final fileName =
          'BPS_${widget.title.replaceAll(RegExp(r'[^\w]'), '_').substring(0, widget.title.length.clamp(0, 30))}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${saveDir.path}/$fileName';
      final file = File(filePath);

      final dio = Dio();
      await dio.download(
        widget.pdfUrl,
        filePath,
        options: Options(
          headers: {
            'Accept': 'application/pdf,*/*',
            'User-Agent': 'Mozilla/5.0',
          },
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
        onReceiveProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() => _downloadProgress = received / total);
          }
        },
        deleteOnError: true,
      );

      if (!await file.exists() || await file.length() == 0) {
        throw Exception('File gagal tersimpan atau kosong');
      }

      if (mounted) {
        setState(() {
          _localPath = filePath;
          _isDownloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    Platform.isAndroid
                        ? 'Tersimpan di folder Download'
                        : 'PDF berhasil diunduh',
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadError =
              'Gagal mengunduh: ${e.response?.statusCode != null ? 'Error ${e.response!.statusCode}' : e.message ?? 'Periksa koneksi internet'}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadError = 'Error: ${e.toString()}';
        });
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isIOS) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    PermissionStatus status;

    if (sdkInt >= 33) {
      status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) status = await Permission.storage.request();
    } else if (sdkInt >= 30) {
      status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) status = await Permission.storage.request();
    } else {
      status = await Permission.storage.request();
    }

    if (status.isPermanentlyDenied && mounted) {
      await _showPermissionDialog();
      return false;
    }

    return status.isGranted;
  }

  Future<void> _showPermissionDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Izin Penyimpanan Diperlukan',
          style: AppTextStyles.headlineMedium,
        ),
        content: const Text(
          'Akses penyimpanan diperlukan untuk mengunduh PDF. '
          'Buka Pengaturan dan aktifkan izin Penyimpanan untuk aplikasi ini.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────
  void _goToPage(int page) {
    if (_pdfController != null && page >= 0 && page < _totalPages) {
      _pdfController!.setPage(page);
    }
  }

  void _showGoToPageDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pergi ke Halaman'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Nomor halaman (1–$_totalPages)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final page = int.tryParse(ctrl.text);
              if (page != null && page >= 1 && page <= _totalPages) {
                _goToPage(page - 1);
                Navigator.pop(context);
              }
            },
            child: const Text('Pergi'),
          ),
        ],
      ),
    );
  }

  Future<void> _searchInPdf(String query) async {
    if (query.isEmpty || _pdfController == null) return;
    setState(() => _isSearching = true);
    setState(() => _isSearching = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mencari "$query" dalam dokumen...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: _showSearch ? _buildSearchField() : _buildTitle(),
        actions: [
          if (!_showSearch)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Cari teks',
              onPressed: () => setState(() => _showSearch = true),
            ),
          if (_showSearch)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => setState(() {
                _showSearch = false;
                _searchController.clear();
                _searchQuery = '';
              }),
            ),
          if (_totalPages > 0)
            IconButton(
              icon: const Icon(Icons.open_in_full_rounded),
              tooltip: 'Pergi ke halaman',
              onPressed: _showGoToPageDialog,
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _totalPages > 0 ? _buildPageNav() : null,
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: const TextStyle(
        fontFamily: AppTextStyles.fontPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      onSubmitted: (v) {
        _searchQuery = v;
        _searchInPdf(v);
      },
      decoration: InputDecoration(
        hintText: 'Cari teks dalam PDF...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: InputBorder.none,
        filled: false,
        prefixIcon: _isSearching
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : const Icon(Icons.search_rounded, color: Colors.white70),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white70),
                onPressed: () {
                  _searchQuery = _searchController.text;
                  _searchInPdf(_searchController.text);
                },
              )
            : null,
      ),
    );
  }

  Widget _buildBody() {
    if (_isDownloading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: _downloadProgress > 0 ? _downloadProgress : null,
                strokeWidth: 4,
                color: AppColors.accent,
                backgroundColor: Colors.white12,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _downloadProgress > 0
                  ? 'Mengunduh... ${(_downloadProgress * 100).toInt()}%'
                  : 'Mempersiapkan dokumen...',
              style: const TextStyle(
                fontFamily: AppTextStyles.fontPrimary,
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_downloadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                _downloadError!,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isDownloading = true;
                    _downloadError = null;
                    _downloadProgress = 0;
                  });
                  _downloadPdf();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_localPath == null) {
      return const Center(
        child: Text(
          'File tidak ditemukan',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return PDFView(
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      fitPolicy: FitPolicy.BOTH,
      onRender: (pages) {
        if (mounted) setState(() => _totalPages = pages ?? 0);
      },
      onViewCreated: (controller) {
        _pdfController = controller;
        if (!_controllerCompleter.isCompleted) {
          _controllerCompleter.complete(controller);
        }
      },
      onPageChanged: (page, total) {
        if (mounted) {
          setState(() {
            _currentPage = page ?? 0;
            _totalPages = total ?? 0;
          });
        }
      },
      onError: (error) {
        if (mounted) setState(() => _downloadError = error.toString());
      },
    );
  }

  Widget _buildPageNav() {
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
              onPressed: _currentPage > 0
                  ? () => _goToPage(_currentPage - 1)
                  : null,
            ),
            GestureDetector(
              onTap: _showGoToPageDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1} / $_totalPages',
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontPrimary,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
              onPressed: _currentPage < _totalPages - 1
                  ? () => _goToPage(_currentPage + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
