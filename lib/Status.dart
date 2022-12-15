import 'dart:convert';

import 'package:http/http.dart' as http;

class FetchService {
  static fetchData() async {
    var client = http.Client();
    var uri = Uri.parse("https://api.github.com/users/freeCodeCamp/repos");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}
