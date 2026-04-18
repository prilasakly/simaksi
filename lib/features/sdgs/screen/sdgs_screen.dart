// lib/features/sdgs/sdgs_screen.dart
// ============================================================
// SIMAKSI - SDGs Screen
// Tampilkan indikator SDGs dari BPS WebAPI
// Filter per goal (1-17) & search by keyword
// ============================================================

import 'package:flutter/material.dart';
import 'package:simaksi/core/api/api_client.dart' show ApiSuccess, ApiError;
import 'package:simaksi/core/theme/app_theme.dart' show AppColors;
import 'package:simaksi/features/sdgs/model/sdgs_model.dart' show SdgsModel;
import 'package:simaksi/features/sdgs/service/sdgs_service.dart' show SdgsService;
import 'package:simaksi/features/sdgs/widget/sdgs_card.dart' show SdgsCard;
import 'package:simaksi/features/sdgs/widget/sdgs_goal_filter.dart' show SdgsGoalFilter;

class SdgsScreen extends StatefulWidget {
  const SdgsScreen({super.key});

  @override
  State<SdgsScreen> createState() => _SdgsScreenState();
}

class _SdgsScreenState extends State<SdgsScreen> {
  final SdgsService _service = SdgsService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int? _selectedGoal; // null = semua goal
  String _keyword = '';
  bool _isLoading = false;
  String? _errorMsg;

  // Cache per-goal agar tidak re-fetch saat switch goal
  final Map<int, List<SdgsModel>> _cache = {};
  List<SdgsModel> _allData = [];
  List<SdgsModel> get _displayData {
    List<SdgsModel> data;
    if (_selectedGoal == null) {
      data = _allData;
    } else {
      data = _allData.where((e) => e.goalNumber == _selectedGoal).toList();
    }
    if (_keyword.trim().isNotEmpty) {
      final q = _keyword.toLowerCase();
      data = data.where((e) {
        return e.title.toLowerCase().contains(q) ||
            e.sdgsId.toLowerCase().contains(q) ||
            e.subName.toLowerCase().contains(q) ||
            e.sdgsGoalName.toLowerCase().contains(q);
      }).toList();
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    // Jika pilih goal tertentu dan sudah di-cache, pakai cache
    if (_selectedGoal != null && _cache.containsKey(_selectedGoal)) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (_selectedGoal != null) {
      // Load satu goal
      final result = await _service.getSdgsByGoal(goal: _selectedGoal!);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (result is ApiSuccess<List<SdgsModel>>) {
          _cache[_selectedGoal!] = result.data;
          // Merge ke allData
          _allData.removeWhere((e) => e.goalNumber == _selectedGoal);
          _allData.addAll(result.data);
          _allData.sort((a, b) => a.goalNumber.compareTo(b.goalNumber));
        } else if (result is ApiError<List<SdgsModel>>) {
          _errorMsg = result.message;
        }
      });
    } else {
      // Load semua goal secara paralel
      final futures = List.generate(
        17,
        (i) => _service.getSdgsByGoal(goal: i + 1),
      );
      final results = await Future.wait(futures);
      if (!mounted) return;

      final List<SdgsModel> merged = [];
      String? err;
      for (int i = 0; i < results.length; i++) {
        final r = results[i];
        if (r is ApiSuccess<List<SdgsModel>>) {
          _cache[i + 1] = r.data;
          merged.addAll(r.data);
        } else if (r is ApiError<List<SdgsModel>> && err == null) {
          err = r.message;
        }
      }
      merged.sort((a, b) => a.goalNumber.compareTo(b.goalNumber));

      setState(() {
        _isLoading = false;
        _allData = merged;
        if (merged.isEmpty && err != null) _errorMsg = err;
      });
    }
  }

  void _onGoalChanged(int? goal) {
    setState(() {
      _selectedGoal = goal;
      _searchController.clear();
      _keyword = '';
    });
    // Jika belum di-cache, load
    if (goal != null && !_cache.containsKey(goal)) {
      _loadData();
    }
    // Scroll ke atas
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Filter Chips ─────────────────────────────────
          Container(
            color: AppColors.surface,
            child: SdgsGoalFilter(
              selectedGoal: _selectedGoal,
              onGoalChanged: _onGoalChanged,
            ),
          ),

          // ── Search Bar ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _keyword = v),
              decoration: InputDecoration(
                hintText: 'Cari indikator SDGs...',
                hintStyle: const TextStyle(
                  color: AppColors.textHint,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
                suffixIcon: _keyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppColors.textHint,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _keyword = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.surfaceVariant,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.surfaceVariant,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // ── Result Count ─────────────────────────────────
          if (!_isLoading && _errorMsg == null)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
              child: Row(
                children: [
                  Text(
                    '${_displayData.length} indikator',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_selectedGoal != null) ...[
                    const Text(
                      ' · ',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                    Text(
                      'Goal $_selectedGoal',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // ── Content ──────────────────────────────────────
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SDGs',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          Text(
            'Indikator Pembangunan Berkelanjutan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            _cache.clear();
            _allData.clear();
            _loadData();
          },
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading) return _buildLoading();
    if (_errorMsg != null) return _buildError();
    if (_displayData.isEmpty) return _buildEmpty();
    return _buildList();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
          const SizedBox(height: 16),
          Text(
            _selectedGoal == null
                ? 'Memuat semua indikator SDGs...'
                : 'Memuat Goal $_selectedGoal...',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ini mungkin butuh beberapa detik',
            style: TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMsg ?? '',
              style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Tidak ada hasil',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (_keyword.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'untuk "$_keyword"',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: () async {
        _cache.clear();
        _allData.clear();
        await _loadData();
      },
      color: AppColors.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: _displayData.length,
        itemBuilder: (context, index) {
          return SdgsCard(item: _displayData[index]);
        },
      ),
    );
  }
}
