class BaseResponse<T> {
  bool error;
  String message;
  List<T>? data;
  T? singleObjectData;

  BaseResponse({
    this.error = false,
    this.message = '',
    this.data,
    this.singleObjectData,
  });

  /// if [singleObjectData] is true, then the success response will be in data form
  /// by default the data is in list form always
  factory BaseResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create,
      {bool singleObjectData = false}) {
    var data = <T>[];
    if (!singleObjectData &&
        json['data'] != null &&
        json['data'] is! String &&
        json['data'] is List) {
      json['data']?.forEach(
        (v) {
          data.add(create(v));
        },
      );
    }
    return BaseResponse(
      error: json['error'],
      message: json['message'],
      data: data.isNotEmpty ? data : null,
      singleObjectData: (singleObjectData && json['data'] != null)
          ? create(json['data']?[0])
          : null,
    );
  }

  @override
  String toString() {
    return 'Error: $error \n Message: $message \n Data: ${data.toString()} \n ObjectData: ${data.toString()}';
  }
}
