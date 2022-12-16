import 'dart:convert';

import 'package:get/get_connect/connect.dart';
import 'package:http/http.dart' as http;
import 'package:pagination_demo_getx/resource/string_resource.dart';

class Repository extends GetConnect {
  Future<dynamic> getApiData(int pageIndex, String searchText) async {
    try {
      Uri url = Uri.parse(StringResource.baseUrl);
      final msg = jsonEncode({
        "pageIndex": pageIndex.toString(),
        "searchText": searchText,
        "returnedRecords": 20.toString()
      });

      var response = await http.post(
        url,
        body: msg,
        headers: StringResource.headers,
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return Future.error(response.body);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
