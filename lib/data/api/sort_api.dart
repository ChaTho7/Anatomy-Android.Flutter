import 'package:http/http.dart' as http;

class SortApi {
  static const apiUrl = "http://192.168.1.3:5000/api/sorts/";

  static Future getSorts() async {
    var url = Uri.parse(apiUrl + 'getall');
    return await http.get(url);
  }
}
