// lib/services/sdgs_service.dart
// ============================================================
// SIMAKSI - SDGs Service
// Ambil data SDGs dari BPS WebAPI
// Endpoint: https://webapi.bps.go.id/v1/api/list/
// Params  : model=sdgs, goals=1-17, key=...
// ============================================================

import 'package:dio/dio.dart';
import 'package:simaksi/core/api/api_client.dart'
    show ApiClient, ApiResult, ApiSuccess, ApiError;
import 'package:simaksi/core/api/api_endpoints.dart' show ApiEndpoints;
import 'package:simaksi/core/services/base_service.dart' show BaseService;
import 'package:simaksi/features/sdgs/model/sdgs_model.dart' show SdgsModel;

class SdgsService extends BaseService {
  final Dio _dio = ApiClient.instance;

  /// Ambil semua indikator SDGs (semua goal sekaligus)
  /// Karena API tidak support goals=all, kita loop 1–17
  Future<ApiResult<List<SdgsModel>>> getAllSdgs({
    int page = 1,
    String? keyword,
  }) async {
    final List<SdgsModel> allData = [];

    for (int goal = 1; goal <= 17; goal++) {
      final result = await getSdgsByGoal(goal: goal, page: page);
      if (result is ApiSuccess<List<SdgsModel>>) {
        allData.addAll(result.data);
      }
    }

    // Filter by keyword jika ada
    if (keyword != null && keyword.trim().isNotEmpty) {
      final q = keyword.toLowerCase();
      return ApiSuccess(
        allData.where((item) {
          return item.title.toLowerCase().contains(q) ||
              item.sdgsId.toLowerCase().contains(q) ||
              item.subName.toLowerCase().contains(q) ||
              item.sdgsGoalName.toLowerCase().contains(q);
        }).toList(),
      );
    }

    return ApiSuccess(allData);
  }

  /// Ambil indikator SDGs berdasarkan goal (1–17)
  Future<ApiResult<List<SdgsModel>>> getSdgsByGoal({
    required int goal,
    int page = 1,
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.sdgs, // '/api/list'
        queryParameters: {
          'model': 'sdgs',
          'domain': '0000',
          'goal': goal,
          'page': page,
          'key': ApiEndpoints.apiKey,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        },
      );

      final raw = response.data;

      if (raw['data-availability'] != 'available') {
        return const ApiSuccess([]);
      }

      final List list = raw['data'][1];
      final result = list.map((e) => SdgsModel.fromJson(e)).toList();

      return ApiSuccess(result);
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal memuat data SDGs');
    } catch (e) {
      return ApiError('Terjadi kesalahan: $e');
    }
  }
}
