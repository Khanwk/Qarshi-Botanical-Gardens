import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  static var data = {};
  static fetchAlbum() async {
    var img1 = "https%3A%2F%2Fmy.plantnet.org%2Fimages%2Fimage_1.jpeg";
    var img2 = "https%3A%2F%2Fmy.plantnet.org%2Fimages%2Fimage_2.jpeg";
    final response = await http.get(Uri.parse(
        'https://my-api.plantnet.org/v2/identify/all?api-key=2b10CIppBiSiXgbZTDEvMfRAVu&images=${img1}&images=${img2}&organs=flower&organs=leaf'));

    if (response.statusCode == 200) {
      print("************************************");
      // print(response.body);
      data = jsonDecode(response.body);
      print(data['query']['']);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
