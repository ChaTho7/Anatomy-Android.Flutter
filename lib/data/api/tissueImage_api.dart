import 'dart:io';

import 'package:ChaTho_Anatomy/constants.dart';
import 'package:http/http.dart' as http;

class TissueImageApi {
  static const apiUrl = Constants.apiUrl + "TissueImages/";

  static Future getTissueImages(int id) async {
    var url = Uri.parse(apiUrl + 'getimage?tissueId=$id');
    return await http.get(url);
  }

  static Future addTissueImages(File file, int id) async {
    var url = Uri.parse(apiUrl + 'addimage');
    var request = await http.MultipartRequest('POST', url);
    var image = await http.MultipartFile.fromPath("formFile", file.path);
    request.fields["tissueId"] = id.toString();
    request.files.add(image);
    return await http.Response.fromStream(await request.send());
  }
}
