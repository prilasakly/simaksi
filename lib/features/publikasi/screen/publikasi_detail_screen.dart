// lib/features/publikasi/screen/publikasi_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:simaksi/features/publikasi/widgets/detail_content.dart';

import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../model/publikasi_model.dart';
import '../service/publikasi_service.dart';
import '../widgets/detail_hero_header.dart';

class PublikasiDetailScreen extends StatefulWidget {
  final String id;
  final PublikasiModel? preloadedData;

  const PublikasiDetailScreen({
    super.key,
    required this.id,
    this.preloadedData,
  });

  @override
  State<PublikasiDetailScreen> createState() => _PublikasiDetailScreenState();
}

class _PublikasiDetailScreenState extends State<PublikasiDetailScreen> {
  final _service = PublikasiService();

  PublikasiModel? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedData != null && widget.preloadedData!.abstrak != null) {
      _detail = widget.preloadedData;
      _isLoading = false;
    } else {
      _loadDetail();
    }
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _service.getPublikasiDetail(widget.id);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result is ApiSuccess<PublikasiModel>) {
        _detail = result.data;
      } else if (result is ApiError<PublikasiModel>) {
        _error = result.message;
        if (widget.preloadedData != null) _detail = widget.preloadedData;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return _buildLoadingScaffold();
    if (_detail == null && _error != null) return _buildErrorScaffold();

    final item = _detail!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: DetailHeroHeader(item: item),
            ),
          ),
          SliverToBoxAdapter(child: DetailContent(item: item)),
        ],
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Publikasi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Publikasi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text('Gagal memuat detail', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(_error!, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadDetail,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
