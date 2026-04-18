import 'package:dio/dio.dart';
import 'package:simaksi/api/api_client.dart';
import 'package:simaksi/api/api_endpoints.dart';

import '../models/brs_model.dart';
import '../services/base_service.dart';

class BrsService extends BaseService {
  final Dio _dio = ApiClient.instance;

  Future<ApiResult<List<BrsModel>>> getBrs({
    int? page,
    int? month,
    int? year,
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.brs,
        queryParameters: {
          'model': 'pressrelease',
          'lang': 'ind',
          'domain': '3202',
          if (page != null) 'page': page,
          if (month != null) 'month': month,
          if (year != null) 'year': year,
          if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          'key': '36e80d5b1dc35c8127b134a3c6739b2a',
        },
      );

      final raw = response.data;

      if (raw['data-availability'] != 'available') {
        return const ApiSuccess([]);
      }

      // 🔥 ambil data list sebenarnya
      final List list = raw['data'][1];

      final result = list.map((e) => BrsModel.fromJson(e)).toList();

      return ApiSuccess(result);
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal load BRS');
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
          'key': '36e80d5b1dc35c8127b134a3c6739b2a',
        },
      );

      final raw = response.data;

      if (raw['data-availability'] != 'available') {
        return const ApiError('Data tidak tersedia');
      }

      final data = raw['data'];

      return ApiSuccess(BrsModel.fromJson(data));
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal load detail BRS');
    }
  }
}
