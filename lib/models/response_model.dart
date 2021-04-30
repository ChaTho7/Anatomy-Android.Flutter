class ResponseModel<T> {
  T data;
  bool success;
  String message;

  ResponseModel({this.data, this.message, this.success});

  factory ResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    return ResponseModel(
        data: parsedJson['data'],
        success: parsedJson['success'],
        message: parsedJson['message']);
  }
}
