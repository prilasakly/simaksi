// lib/features/infografis/service/infografis_service.dart
// ============================================================
// SIMAKSI - Infografis Service
// Mengambil data infografis dari BPS WebAPI
// Dokumentasi: https://webapi.bps.go.id/documentation/
// ============================================================

import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/pagination_model.dart';
import '../../../core/services/base_service.dart';
import '../model/infografis_model.dart';

class InfografisService extends BaseService {
  // ── Get list infografis ───────────────────────────────────
  /// Mengambil daftar infografis dengan pagination dan filter keyword.
  ///
  /// [page]    : halaman yang diminta (default 1)
  /// [keyword] : kata kunci pencarian (opsional)
  Future<ApiResult<List<InfografisModel>>> getInfografis({
    int page = 1,
    String? keyword,
  }) async {
    final query = _buildQuery(page: page, keyword: keyword);

    return fetchList<InfografisModel>(
      endpoint: ApiEndpoints.infografis,
      query: query,
      parser: InfografisModel.fromJson,
    );
  }

  // ── Get pagination info ───────────────────────────────────
  /// Mengambil metadata pagination (total, halaman, dsb.)
  Future<BpsPagination?> getInfografisPagination({
    int page = 1,
    String? keyword,
  }) async {
    try {
      final query = _buildQuery(page: page, keyword: keyword);
      final res = await dio.get(
        ApiEndpoints.infografis,
        queryParameters: query,
      );

      final json = res.data;
      if (json['data-availability'] != 'available') return null;

      final paginationData = json['data'][0];
      return BpsPagination.fromJson(paginationData);
    } on DioException {
      return null;
    }
  }

  // ── Get for home (limited count) ─────────────────────────
  /// Mengambil infografis untuk widget di beranda (tanpa keyword).
  /// Mengembalikan [limit] item pertama dari halaman 1.
  Future<ApiResult<List<InfografisModel>>> getInfografisForHome({
    int limit = 8,
  }) async {
    final result = await getInfografis(page: 1);

    if (result is ApiSuccess<List<InfografisModel>>) {
      final limited = result.data.take(limit).toList();
      return ApiSuccess(limited);
    }

    return result;
  }

  // ── Private helpers ───────────────────────────────────────
  Map<String, dynamic> _buildQuery({required int page, String? keyword}) {
    final query = <String, dynamic>{
      'model': 'infographic',
      'lang': 'ind',
      'domain': ApiEndpoints.wilayahKode,
      'key': ApiEndpoints.apiKey,
      'page': page,
    };

    if (keyword != null && keyword.trim().isNotEmpty) {
      query['keyword'] = keyword.trim();
    }

    return query;
  }
}
