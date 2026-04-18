class BpsPagination {
  final int page, pages, perPage, count, total;

  const BpsPagination({
    required this.page,
    required this.pages,
    required this.perPage,
    required this.count,
    required this.total,
  });

  factory BpsPagination.fromJson(Map<String, dynamic> json) {
    return BpsPagination(
      page: json['page'] ?? 0,
      pages: json['pages'] ?? 0,
      perPage: json['per_page'] ?? 0,
      count: json['count'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
