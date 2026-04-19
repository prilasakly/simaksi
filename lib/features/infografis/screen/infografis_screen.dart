// lib/features/infografis/screen/infografis_screen.dart
// ============================================================
// SIMAKSI - Infografis Screen
// Layar utama galeri infografis BPS Kabupaten Sukabumi.
//
// Fitur:
//   • Grid 2 kolom dengan animasi stagger masuk
//   • Search bar dengan debounce 500ms
//   • Pagination: infinite scroll (load more saat scroll bawah)
//   • Pull-to-refresh
//   • Bottom sheet detail + unduh + lihat gambar penuh
//   • State: loading, error, empty, data
// ============================================================

import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/pagination_model.dart';
import '../../../core/theme/app_theme.dart';
import '../model/infografis_model.dart';
import '../service/infografis_service.dart';
import '../widgets/infografis_card.dart';
import '../widgets/infografis_detail_sheet.dart';
import '../widgets/infografis_empty_state.dart';
import '../widgets/infografis_search_bar.dart';
import '../widgets/infografis_stats_header.dart';

class InfografisScreen extends StatefulWidget {
  const InfografisScreen({super.key});

  @override
  State<InfografisScreen> createState() => _InfografisScreenState();
}

class _InfografisScreenState extends State<InfografisScreen> {
  // ── Dependencies ──────────────────────────────────────────
  final _service = InfografisService();
  final _scrollCtrl = ScrollController();

  // ── State ─────────────────────────────────────────────────
  List<InfografisModel> _items = [];
  BpsPagination? _pagination;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String _keyword = '';
  int _currentPage = 1;
  bool _hasMore = true;

  // Debounce
  DateTime? _lastSearchTime;

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadData(reset: true);
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Scroll listener ───────────────────────────────────────
  void _onScroll() {
    final pos = _scrollCtrl.position;
    if (pos.pixels >= pos.maxScrollExtent - 240 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  // ── Data loading ──────────────────────────────────────────
  Future<void> _loadData({bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 1;
        _items = [];
        _hasMore = true;
      });
    }

    // Jalankan parallel: data + pagination
    final results = await Future.wait([
      _service.getInfografis(
        page: _currentPage,
        keyword: _keyword.isEmpty ? null : _keyword,
      ),
      _service.getInfografisPagination(
        page: _currentPage,
        keyword: _keyword.isEmpty ? null : _keyword,
      ),
    ]);

    if (!mounted) return;

    final dataResult = results[0] as ApiResult<List<InfografisModel>>;
    final paginResult = results[1] as BpsPagination?;

    setState(() {
      _isLoading = false;
      _pagination = paginResult;

      if (dataResult is ApiSuccess<List<InfografisModel>>) {
        _items = dataResult.data;
        _hasMore = paginResult != null && _currentPage < paginResult.pages;
      } else if (dataResult is ApiError<List<InfografisModel>>) {
        _error = dataResult.message;
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    final nextPage = _currentPage + 1;
    final result = await _service.getInfografis(
      page: nextPage,
      keyword: _keyword.isEmpty ? null : _keyword,
    );

    if (!mounted) return;

    setState(() {
      _isLoadingMore = false;
      if (result is ApiSuccess<List<InfografisModel>>) {
        _items.addAll(result.data);
        _currentPage = nextPage;
        _hasMore = _pagination != null && _currentPage < _pagination!.pages;
      }
    });
  }

  // ── Search ────────────────────────────────────────────────
  Future<void> _onSearchChanged(String val) async {
    final now = DateTime.now();
    _lastSearchTime = now;

    // Debounce 500ms
    await Future.delayed(const Duration(milliseconds: 500));
    if (_lastSearchTime != now || !mounted) return;

    setState(() => _keyword = val);
    _loadData(reset: true);
  }

  void _clearSearch() {
    setState(() => _keyword = '');
    _loadData(reset: true);
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search bar (menempel di bawah AppBar)
          InfografisSearchBar(
            onChanged: _onSearchChanged,
            onClear: _clearSearch,
          ),

          // Stats header (total & halaman)
          if (!_isLoading && _error == null && _items.isNotEmpty)
            InfografisStatsHeader(
              pagination: _pagination,
              currentPage: _currentPage,
              keyword: _keyword,
            ),

          // Body
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Infografis',
            style: TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
            'BPS Kab. Sukabumi',
            style: TextStyle(
              fontFamily: AppTextStyles.fontPrimary,
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Refresh',
          onPressed: () => _loadData(reset: true),
        ),
      ],
    );
  }

  Widget _buildBody() {
    // ── Loading awal ────────────────────────────────────────
    if (_isLoading) return _buildLoadingGrid();

    // ── Error (tanpa data) ──────────────────────────────────
    if (_error != null && _items.isEmpty) {
      return InfografisErrorState(
        message: _error!,
        onRetry: () => _loadData(reset: true),
      );
    }

    // ── Kosong ──────────────────────────────────────────────
    if (_items.isEmpty) {
      return InfografisEmptyState(
        keyword: _keyword,
        onReset: _keyword.isNotEmpty ? _clearSearch : null,
      );
    }

    // ── Data ────────────────────────────────────────────────
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _loadData(reset: true),
      child: CustomScrollView(
        controller: _scrollCtrl,
        slivers: [
          // Grid utama
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _AnimatedCardWrapper(
                  index: i,
                  child: InfografisCard(
                    item: _items[i],
                    onTap: () => _openDetail(_items[i]),
                  ),
                ),
                childCount: _items.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
            ),
          ),

          // Load more indicator / end message
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const InfografisCardShimmer(),
    );
  }

  Widget _buildFooter() {
    if (_isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (!_hasMore && _items.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            '— Semua ${_pagination?.total ?? _items.length} infografis telah ditampilkan —',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ),
      );
    }

    return const SizedBox(height: 24);
  }

  // ── Detail ────────────────────────────────────────────────
  void _openDetail(InfografisModel item) {
    InfografisDetailSheet.show(context, item: item);
  }
}

// ── Stagger animation wrapper ─────────────────────────────────
class _AnimatedCardWrapper extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedCardWrapper({required this.index, required this.child});

  @override
  State<_AnimatedCardWrapper> createState() => _AnimatedCardWrapperState();
}

class _AnimatedCardWrapperState extends State<_AnimatedCardWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final delay = (widget.index % 6) * 60;

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
