import 'package:http/http.dart' as http;

class TissueImageApi {
  static const apiUrl = "http://192.168.1.3:5000/api/TissueImages/";

  static Future getTissueImages(int id) async {
    var url = Uri.parse(apiUrl + 'getimage?tissueId=$id');
    return await http.get(url);
  }
}