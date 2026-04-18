import 'package:dio/dio.dart';
import 'package:simaksi/api/api_client.dart';
import 'package:simaksi/api/api_endpoints.dart';

import '../models/publikasi_model.dart';
import '../services/base_service.dart';

class PublikasiService extends BaseService {
  final Dio _dio = ApiClient.instance;

  Future<ApiResult<List<PublikasiModel>>> getPublikasi({
    int? page,
    int? month,
    int? year,
    String? keyword,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.publikasi,
        queryParameters: {
          'model': 'publication',
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

      // 🔥 ambil list sebenarnya
      final List list = raw['data'][1];

      final result = list.map((e) => PublikasiModel.fromJson(e)).toList();

      return ApiSuccess(result);
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal load publikasi');
    }
  }
  Future<ApiResult<PublikasiModel>> getPublikasiDetail(String id) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.publikasiDetail,
        queryParameters: {
          'model': 'publication',
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

      // 🔥 biasanya detail langsung object
      final data = raw['data'];

      return ApiSuccess(PublikasiModel.fromJson(data));
    } on DioException catch (e) {
      return ApiError(e.message ?? 'Gagal load detail publikasi');
    }
  }
}

