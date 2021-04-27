import 'package:http/http.dart' as http;

class TissueApi {
  static Future getTissues() {
    var url = Uri.parse('http://localhost:5000/api/tissues/getall');
    return http.get(url);
  }

  static Future getTissuesById(int id) {
    var url = Uri.parse('http://10.0.2.2:5000/api/tissues/getbyid?id=$id');
    return http.get(url);
  }
}
