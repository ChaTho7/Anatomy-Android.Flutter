import 'package:http/http.dart' as http;

class TissueApi {
  static Future getTissues() {
    var url = Uri.parse('http://192.168.1.3:5000/api/tissues/getall');
    return http.get(url);
  }

  static Future getTissuesById(int id) {
    var url = Uri.parse('http://192.168.1.3:5000/api/tissues/getbyid?id=$id');
    return http.get(url);
  }
}
