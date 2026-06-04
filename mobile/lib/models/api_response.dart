class ApiResponse<T> {
  final List<T> data;
  final int currentPage;
  final int lastPage;
  final int total;

  ApiResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}