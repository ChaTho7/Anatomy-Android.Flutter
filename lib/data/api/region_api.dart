import 'package:http/http.dart' as http;

class RegionApi {
  static const apiUrl = "http://192.168.1.3:5000/api/regions/";

  static Future getRegions() async {
    var url = Uri.parse(apiUrl + 'getall');
    return await http.get(url);
  }
}
