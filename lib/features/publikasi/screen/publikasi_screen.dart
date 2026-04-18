// lib/features/publikasi/screen/publikasi_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/pagination_model.dart';
import '../../../core/theme/app_theme.dart';
import '../model/publikasi_model.dart';
import '../service/publikasi_service.dart';
import '../widgets/publikasi_card.dart';
import '../widgets/publikasi_filter_sheet.dart';

class PublikasiScreen extends StatefulWidget {
  const PublikasiScreen({super.key});

  @override
  State<PublikasiScreen> createState() => _PublikasiScreenState();
}

class _PublikasiScreenState extends State<PublikasiScreen> {
  final _service = PublikasiService();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  List<PublikasiModel> _items = [];
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

  // ── Scroll ────────────────────────────────────────────────
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  // ── Data Loading ──────────────────────────────────────────
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

    final result = await _service.getPublikasi(
      page: _currentPage,
      keyword: _keyword.isEmpty ? null : _keyword,
      month: _selectedMonth,
      year: _selectedYear,
    );

    final pagination = await _service.getPublikasiPagination(
      page: _currentPage,
      keyword: _keyword.isEmpty ? null : _keyword,
      month: _selectedMonth,
      year: _selectedYear,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _pagination = pagination;

      if (result is ApiSuccess<List<PublikasiModel>>) {
        _items = result.data;
        _hasMore = pagination != null && _currentPage < pagination.pages;
      } else if (result is ApiError<List<PublikasiModel>>) {
        _error = result.message;
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    final nextPage = _currentPage + 1;
    final result = await _service.getPublikasi(
      page: nextPage,
      keyword: _keyword.isEmpty ? null : _keyword,
      month: _selectedMonth,
      year: _selectedYear,
    );

    if (!mounted) return;

    setState(() {
      _isLoadingMore = false;
      if (result is ApiSuccess<List<PublikasiModel>>) {
        _items.addAll(result.data);
        _currentPage = nextPage;
        _hasMore = _pagination != null && _currentPage < _pagination!.pages;
      }
    });
  }

  // ── Search ────────────────────────────────────────────────
  void _onSearchChanged(String val) async {
    final now = DateTime.now();
    _lastSearch = now;
    await Future.delayed(const Duration(milliseconds: 500));
    if (_lastSearch != now || !mounted) return;
    _keyword = val;
    _loadData(reset: true);
  }

  // ── Filter ────────────────────────────────────────────────
  bool get _hasActiveFilter => _selectedMonth != null || _selectedYear != null;

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PublikasiFilterSheet(
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

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Publikasi'),
        backgroundColor: AppColors.primary,
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
          _buildSearchBar(),
          if (_hasActiveFilter) _buildActiveFilterRow(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Cari publikasi...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.7),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _keyword = '';
                    _loadData(reset: true);
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.4),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
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
            ActiveFilterChip(
              label: 'Bulan: ${_monthLabel(_selectedMonth!)}',
              onRemove: () {
                setState(() => _selectedMonth = null);
                _loadData(reset: true);
              },
            ),
          if (_selectedYear != null)
            ActiveFilterChip(
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
    if (_isLoading) return _buildLoadingGrid();

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
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada publikasi ditemukan',
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            if (_keyword.isNotEmpty || _hasActiveFilter) ...[
              const SizedBox(height: 8),
              Text(
                'Coba ubah kata kunci atau filter Anda',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _loadData(reset: true),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text(
                _pagination != null
                    ? '${_pagination!.total} publikasi ditemukan'
                    : '${_items.length} publikasi',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index == _items.length) {
                  return _isLoadingMore
                      ? const PublikasiCardShimmer()
                      : const SizedBox.shrink();
                }
                return PublikasiCard(
                  item: _items[index],
                  onTap: () => context.push(
                    '/publikasi/${_items[index].id}',
                    extra: _items[index],
                  ),
                );
              }, childCount: _items.length + (_isLoadingMore ? 2 : 0)),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 14,
                childAspectRatio: 0.54,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
        childAspectRatio: 0.54,
      ),
      itemCount: 9,
      itemBuilder: (_, __) => const PublikasiCardShimmer(),
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
}
