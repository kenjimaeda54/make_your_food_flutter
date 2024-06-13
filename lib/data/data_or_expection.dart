class DataOrException<T> {
  final T? data;
  final bool isSuccess;
  final String? exception;

  DataOrException(
      {required this.data, required this.exception, required this.isSuccess});
}
