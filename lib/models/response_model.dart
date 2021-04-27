import 'package:ChaTho_Anatomy/models/Tissue.dart';

class ResponseModel {
  List<Tissue> data;
  bool success;
  String message;

  ResponseModel({this.data, this.message, this.success});

  factory ResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> list = parsedJson['data'] as List;
    List<Tissue> tissueList = list.map((e) => Tissue.fromJson(e)).toList();
    return ResponseModel(
        data: tissueList,
        success: parsedJson['success'],
        message: parsedJson['message']);
  }
}
