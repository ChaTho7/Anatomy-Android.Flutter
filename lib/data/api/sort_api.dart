import 'package:ChaTho_Anatomy/constants.dart';
import 'package:http/http.dart' as http;

class SortApi {
  static const apiUrl = Constants.apiUrl + "sorts/";

  static Future getSorts() async {
    var url = Uri.parse(apiUrl + 'getall');
    return await http.get(url);
  }
}
