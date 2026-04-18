// lib/features/brs/screen/brs_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simaksi/features/brs/widgets/brs_filter_sheet.dart';
import 'package:simaksi/features/brs/widgets/brs_list_item.dart';
import 'package:simaksi/features/brs/widgets/brs_search_bar.dart';
import 'package:simaksi/features/brs/widgets/brs_stats_header.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/pagination_model.dart';
import '../../../core/theme/app_theme.dart';
import '../model/brs_model.dart';
import '../service/brs_service.dart';

class BrsScreen extends StatefulWidget {
  const BrsScreen({super.key});

  @override
  State<BrsScreen> createState() => _BrsScreenState();
}

class _BrsScreenState extends State<BrsScreen> {
  static const _green = Color(0xFF1B5E20);

  final _service = BrsService();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  List<BrsModel> _items = [];
  BpsPagination? _pagination;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  String _keyword = '';
  String? _selectedMonth;
  String? _selectedYear;
  int _currentPage = 1;
  bool _hasMore = true;

  DateTime? _lastSearch;

  @override
  void initState() {
    super.initState();
    _loadData(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Scroll ─────────────────────────────────────────────────
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  // ── Load Data ───────────────────────────────────────────────
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

    final result = await _service.getBrs(
      page: _currentPage,
      keyword: _keyword.isEmpty ? null : _keyword,
      month: _selectedMonth,
      year: _selectedYear,
    );

    final pagination = await _service.getBrsPagination(
      page: _currentPage,
      keyword: _keyword.isEmpty ? null : _keyword,
      month: _selectedMonth,
      year: _selectedYear,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _pagination = pagination;
      if (result is ApiSuccess<List<BrsModel>>) {
        _items = result.data;
        _hasMore = pagination != null && _currentPage < pagination.pages;
      } else if (result is ApiError<List<BrsModel>>) {
        _error = result.message;
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    final nextPage = _currentPage + 1;
    final result = await _service.getBrs(
      page: nextPage,
      keyword: _keyword.isEmpty ? null : _keyword,
      month: _selectedMonth,
      year: _selectedYear,
    );

    if (!mounted) return;

    setState(() {
      _isLoadingMore = false;
      if (result is ApiSuccess<List<BrsModel>>) {
        _items.addAll(result.data);
        _currentPage = nextPage;
        _hasMore = _pagination != null && _currentPage < _pagination!.pages;
      }
    });
  }

  // ── Search ──────────────────────────────────────────────────
  void _onSearchChanged(String val) async {
    final now = DateTime.now();
    _lastSearch = now;
    await Future.delayed(const Duration(milliseconds: 500));
    if (_lastSearch != now || !mounted) return;
    _keyword = val;
    _loadData(reset: true);
  }

  // ── Filter ──────────────────────────────────────────────────
  bool get _hasActiveFilter => _selectedMonth != null || _selectedYear != null;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BrsFilterSheet(
        initialMonth: _selectedMonth,
        initialYear: _selectedYear,
        onApply: (month, year) {
          setState(() {
            _selectedMonth = month;
            _selectedYear = year;
          });
          _loadData(reset: true);
        },
      ),
    );
  }

  String _monthLabel(String month) {
    const labels = {
      '1': 'Jan',
      '2': 'Feb',
      '3': 'Mar',
      '4': 'Apr',
      '5': 'Mei',
      '6': 'Jun',
      '7': 'Jul',
      '8': 'Agu',
      '9': 'Sep',
      '10': 'Okt',
      '11': 'Nov',
      '12': 'Des',
    };
    return labels[month] ?? month;
  }

  // ── Build ───────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Berita Resmi Statistik'),
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Filter',
                onPressed: _showFilterSheet,
              ),
              if (_hasActiveFilter)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          BrsSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onClear: () {
              _searchController.clear();
              _keyword = '';
              _loadData(reset: true);
            },
          ),
          if (_hasActiveFilter) _buildActiveFilterRow(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildActiveFilterRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surface,
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          if (_selectedMonth != null)
            BrsActiveFilterChip(
              label: 'Bulan: ${_monthLabel(_selectedMonth!)}',
              onRemove: () {
                setState(() => _selectedMonth = null);
                _loadData(reset: true);
              },
            ),
          if (_selectedYear != null)
            BrsActiveFilterChip(
              label: 'Tahun: $_selectedYear',
              onRemove: () {
                setState(() => _selectedYear = null);
                _loadData(reset: true);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 12),
        itemCount: 6,
        itemBuilder: (_, __) => const BrsListItemShimmer(),
      );
    }

    if (_error != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _loadData(reset: true),
              style: ElevatedButton.styleFrom(backgroundColor: _green),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Tidak ada BRS ditemukan',
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            if (_keyword.isNotEmpty || _hasActiveFilter) ...[
              const SizedBox(height: 8),
              Text(
                'Coba ubah kata kunci atau filter',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _green,
      onRefresh: () => _loadData(reset: true),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: BrsStatsHeader(
              pagination: _pagination,
              localCount: _items.length,
              hasFilter: _hasActiveFilter || _keyword.isNotEmpty,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index == _items.length) {
                return _isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: BrsListItemShimmer(),
                      )
                    : const SizedBox.shrink();
              }
              return BrsListItem(
                item: _items[index],
                onTap: () => context.push(
                  '/brs/${_items[index].id}',
                  extra: _items[index],
                ),
              );
            }, childCount: _items.length + (_isLoadingMore ? 1 : 0)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
