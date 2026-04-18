// lib/features/publikasi/service/publikasi_service.dart
// ============================================================
// SIMAKSI - Publikasi Service
// Mengambil data publikasi dari BPS WebAPI
// ============================================================

import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/pagination_model.dart';
import '../../../core/models/response_model.dart';
import '../../../core/services/base_service.dart';
import '../model/publikasi_model.dart';

class PublikasiService extends BaseService {
  // ── Get list publikasi (dengan pagination & filter) ──────
  Future<ApiResult<List<PublikasiModel>>> getPublikasi({
    int page = 1,
    String? keyword,
    String? month,
    String? year,
  }) async {
    final query = <String, dynamic>{
      'model': 'publication',
      'lang': 'ind',
      'domain': ApiEndpoints.wilayahKode,
      'key': ApiEndpoints.apiKey,
      'page': page,
    };

    if (keyword != null && keyword.isNotEmpty) query['keyword'] = keyword;
    if (month != null && month.isNotEmpty) query['month'] = month;
    if (year != null && year.isNotEmpty) query['year'] = year;

    return fetchList<PublikasiModel>(
      endpoint: ApiEndpoints.publikasi,
      query: query,
      parser: PublikasiModel.fromJson,
    );
  }

  // ── Get pagination info ───────────────────────────────────
  Future<BpsPagination?> getPublikasiPagination({
    int page = 1,
    String? keyword,
    String? month,
    String? year,
  }) async {
    try {
      final query = <String, dynamic>{
        'model': 'publication',
        'lang': 'ind',
        'domain': ApiEndpoints.wilayahKode,
        'key': ApiEndpoints.apiKey,
        'page': page,
      };

      if (keyword != null && keyword.isNotEmpty) query['keyword'] = keyword;
      if (month != null && month.isNotEmpty) query['month'] = month;
      if (year != null && year.isNotEmpty) query['year'] = year;

      final res = await dio.get(ApiEndpoints.publikasi, queryParameters: query);
      final json = res.data;

      if (json['data-availability'] != 'available') return null;
      final paginationData = json['data'][0];
      return BpsPagination.fromJson(paginationData);
    } catch (_) {
      return null;
    }
  }

  // ── Get detail publikasi ─────────────────────────────────
  Future<ApiResult<PublikasiModel>> getPublikasiDetail(String id) async {
    try {
      final res = await dio.get(
        ApiEndpoints.publikasiDetail,
        queryParameters: {
          'model': 'publication',
          'lang': 'ind',
          'domain': ApiEndpoints.wilayahKode,
          'key': ApiEndpoints.apiKey,
          'id': id,
        },
      );

      final json = res.data;
      if (json['data-availability'] != 'available') {
        return const ApiError('Data tidak tersedia');
      }

      return ApiSuccess(PublikasiModel.fromJson(json['data']));
    } on Exception catch (e) {
      return ApiError(e.toString());
    }
  }
}
