// lib/features/brs/service/brs_service.dart
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/pagination_model.dart';
import '../../../core/services/base_service.dart';
import '../model/brs_model.dart';

class BrsService extends BaseService {
  final Dio _dio = ApiClient.instance;

  Future<ApiResult<List<BrsModel>>> getBrs({
    int page = 1,
    String? month,
    String? year,
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.brs,
        queryParameters: {
          'model': 'pressrelease',
          'lang': 'ind',
          'domain': '3202',
          'page': page,
          if (month != null) 'month': month,
          if (year != null) 'year': year,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          'key': ApiEndpoints.apiKey,
        },
      );

      final raw = response.data;
      if (raw['data-availability'] != 'available') return const ApiSuccess([]);

      final List list = raw['data'][1];
      return ApiSuccess(list.map((e) => BrsModel.fromJson(e)).toList());
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal memuat BRS');
    }
  }

  Future<BpsPagination?> getBrsPagination({
    int page = 1,
    String? month,
    String? year,
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.brs,
        queryParameters: {
          'model': 'pressrelease',
          'lang': 'ind',
          'domain': '3202',
          'page': page,
          if (month != null) 'month': month,
          if (year != null) 'year': year,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          'key': ApiEndpoints.apiKey,
        },
      );

      final raw = response.data;
      if (raw['data-availability'] != 'available') return null;
      return BpsPagination.fromJson(raw['data'][0]);
    } catch (_) {
      return null;
    }
  }

  Future<ApiResult<BrsModel>> getBrsDetail(String id) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.brsDetail,
        queryParameters: {
          'model': 'pressrelease',
          'lang': 'ind',
          'domain': '3202',
          'id': id,
          'key': ApiEndpoints.apiKey,
        },
      );

      final raw = response.data;
      if (raw['data-availability'] != 'available') {
        return const ApiError('Data tidak tersedia');
      }

      return ApiSuccess(BrsModel.fromJson(raw['data']));
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal memuat detail BRS');
    }
  }
}
