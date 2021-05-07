import 'package:ChaTho_Anatomy/constants.dart';
import 'package:http/http.dart' as http;

class RegionApi {
  static const apiUrl = Constants.apiUrl+"regions/";

  static Future getRegions() async {
    var url = Uri.parse(apiUrl + 'getall');
    return await http.get(url);
  }
}
