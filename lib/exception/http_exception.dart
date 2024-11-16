class HttpException extends Error {
  final String? msg;
  HttpException(this.msg);

  @override
  String toString() => '$msg';
}
