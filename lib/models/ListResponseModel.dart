class ListResponseModel<T> {
  List<T> dataList;
  bool success;
  String message;

  ListResponseModel({this.dataList, this.message, this.success});

  factory ListResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    return ListResponseModel(
        dataList: parsedJson['data'],
        success: parsedJson['success'],
        message: parsedJson['message']);
  }
}
