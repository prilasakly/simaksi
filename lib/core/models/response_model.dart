import 'pagination_model.dart';

class BpsResponse<T> {
  final String status;
  final String dataAvailability;
  final BpsPagination pagination;
  final List<T> data;

  const BpsResponse({
    required this.status,
    required this.dataAvailability,
    required this.pagination,
    required this.data,
  });

  bool get isAvailable => dataAvailability == 'available';

  factory BpsResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final raw = json['data'] as List;

    return BpsResponse(
      status: json['status'] ?? '',
      dataAvailability: json['data-availability'] ?? '',
      pagination: BpsPagination.fromJson(raw[0]),
      data: (raw[1] as List).map((e) => fromJsonT(e)).toList(),
    );
  }
}
