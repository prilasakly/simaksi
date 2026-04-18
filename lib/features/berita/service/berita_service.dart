import 'package:dio/dio.dart';
import 'package:simaksi/core/api/api_client.dart';
import 'package:simaksi/core/api/api_endpoints.dart';

import '../../../core/services/base_service.dart';
import '../model/berita_model.dart';

class BeritaService extends BaseService {
  final Dio _dio = ApiClient.instance;

  // ── GET LIST ─────────────────────────────
  Future<ApiResult<List<BeritaModel>>> getBerita({
    int? page,
    String? keyword,
    int? month,
    int? year,
    String? kategori,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.berita,
        queryParameters: {
          'model': 'news',
          'lang': 'ind',
          'domain': '3202',
          'page': page,
          'keyword': keyword,
          'month': month,
          'year': year,
          'newscat': kategori,
          'key': '36e80d5b1dc35c8127b134a3c6739b2a',
        },
      );

      final raw = response.data;

      if (raw['data-availability'] != 'available') {
        return const ApiSuccess([]);
      }

      // 🔥 FIX BPS FORMAT
      final List list = raw['data'][1];

      final result = list.map((e) => BeritaModel.fromJson(e)).toList();

      return ApiSuccess(result);
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal load berita');
    }
  }

  // ── GET DETAIL ───────────────────────────
  Future<ApiResult<BeritaModel>> getDetail(String id) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.beritaDetail,
        queryParameters: {
          'model': 'news',
          'lang': 'ind',
          'domain': '3202',
          'id': id,
          'key': '36e80d5b1dc35c8127b134a3c6739b2a',
        },
      );

      final raw = response.data;

      if (raw['data-availability'] != 'available') {
        return ApiError('Data tidak tersedia');
      }

      final data = raw['data'];

      return ApiSuccess(BeritaModel.fromJson(data));
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal load detail berita');
    }
  }
}
