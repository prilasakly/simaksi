import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../models/response_model.dart';

abstract class BaseService {
  final Dio dio = ApiClient.instance;

  Future<ApiResult<List<T>>> fetchList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) parser,

    // 🔥 param fleksibel (WAJIB untuk BPS)
    Map<String, dynamic>? query,
  }) async {
    try {
      final res = await dio.get(endpoint, queryParameters: query);

      final json = res.data;

      if (json['data-availability'] != 'available') {
        return const ApiSuccess([]);
      }

      // 🔥 FIX FORMAT BPS
      final List list = json['data'][1];

      final result = list.map((e) => parser(e)).toList();

      return ApiSuccess(result);
    } on DioException catch (e) {
      return ApiError(e.message ?? 'API Error');
    }
  }
}
