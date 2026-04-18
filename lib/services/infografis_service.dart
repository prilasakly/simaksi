import 'package:dio/dio.dart';
import 'package:simaksi/api/api_client.dart';
import 'package:simaksi/api/api_endpoints.dart';

import '../services/base_service.dart';
import '../models/infografis_model.dart';

class InfografisService extends BaseService {
  final Dio _dio = ApiClient.instance;

  Future<ApiResult<List<InfografisModel>>> getInfografis({
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.infografis,
        queryParameters: {
          'model': 'infographic',
          'lang': 'ind',
          'domain': '3202',
          'keyword': keyword, // bisa null
          'key': '36e80d5b1dc35c8127b134a3c6739b2a',
        },
      );

      final raw = response.data;

      if (raw['data-availability'] != 'available') {
        return const ApiSuccess([]);
      }

      // 🔥 ambil list di index ke-1
      final List list = raw['data'][1];

      final result = list.map((e) => InfografisModel.fromJson(e)).toList();

      return ApiSuccess(result);
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal load infografis');
    }
  }
}
