import 'dart:convert';
import 'package:ChaTho_Anatomy/models/Tissue.dart';
import 'package:http/http.dart' as http;

class TissueApi {
  static const apiUrl = "http://192.168.1.3:5000/api/tissues/";

  static Future getTissues() async {
    var url = Uri.parse(apiUrl + 'getall');
    return await http.get(url);
  }

  static Future getTissueDetails() async {
    var url = Uri.parse(apiUrl + 'getbyfilter');
    return await http.get(url);
  }

  static Future getTissueById(int id) async {
    var url = Uri.parse(apiUrl + 'getbyid?id=$id');
    return await http.get(url);
  }

  static Future<http.Response> addTissue(Tissue tissue) async {
    var url = Uri.parse(apiUrl + 'add');
    return await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(tissue.toJson()));
  }

  static Future updateTissue(Tissue tissue) async {
    var url = Uri.parse(apiUrl + 'update');
    return await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(tissue.toJson()));
  }
}
