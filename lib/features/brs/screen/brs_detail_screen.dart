// lib/features/brs/screen/brs_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simaksi/features/brs/widgets/brs_abstrak_section.dart';
import 'package:simaksi/features/brs/widgets/brs_detail_action.dart';
import 'package:simaksi/features/brs/widgets/brs_detail_header.dart';

import '../../../core/api/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../model/brs_model.dart';
import '../service/brs_service.dart';
class BrsDetailScreen extends StatefulWidget {
  final String id;
  final BrsModel? preloadedData;

  const BrsDetailScreen({super.key, required this.id, this.preloadedData});

  @override
  State<BrsDetailScreen> createState() => _BrsDetailScreenState();
}

class _BrsDetailScreenState extends State<BrsDetailScreen> {
  static const _green = Color(0xFF1B5E20);

  final _service = BrsService();
  BrsModel? _detail;
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

    final result = await _service.getBrsDetail(widget.id);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result is ApiSuccess<BrsModel>) {
        _detail = result.data;
      } else if (result is ApiError<BrsModel>) {
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
          // ── Collapsible Header ─────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: _green,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: BrsDetailHeader(item: item),
            ),
          ),

          // ── Body Content ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action Buttons
                  BrsDetailActions(item: item),
                  const SizedBox(height: 24),

                  // Ringkasan / Abstrak
                  BrsAbstrakSection(abstrak: item.abstrak),
                  if (item.abstrak != null) const SizedBox(height: 24),

                  // Infografis
                  BrsInfographicsSection(infographics: item.infographics),
                  if (item.infographics.isNotEmpty) const SizedBox(height: 24),

                  // BRS Terkait
                  BrsRelatedSection(
                    related: item.related,
                    onTap: (id) => context.push('/brs/$id'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail BRS'),
        backgroundColor: _green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: CircularProgressIndicator(color: Color(0xFF1B5E20)),
      ),
    );
  }

  Widget _buildErrorScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail BRS'),
        backgroundColor: _green,
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
              style: ElevatedButton.styleFrom(backgroundColor: _green),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
