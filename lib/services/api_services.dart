import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiServices {
  var data = {};
  fetchAlbum(img1) async {
    // var img1 =
    //     "https%3A%2F%2Fuser-images.githubusercontent.com%2F50805976%2F197210877-13de3b9d-1439-4b7f-9292-8cbe11bc4f65.jpg";
    // var img2 = "https%3A%2F%2Fmy.plantnet.org%2Fimages%2Fimage_2.jpeg";
    final response = await http.get(Uri.parse(
        'https://my-api.plantnet.org/v2/identify/all?images=https%3A%2F%2F${img1}&organs=leaf&include-related-images=true&no-reject=false&lang=en&api-key=2b10CIppBiSiXgbZTDEvMfRAVu'));

    if (response.statusCode == 200) {
      print("************************************");
      print(img1);
      data = jsonDecode(response.body);
      // print(data["results"]);
      return (data["results"]);
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

class PostData {
  // String img1 = "";
  String url =
      "https://my-api.plantnet.org/v2/identify/all?api-key=2b10CIppBiSiXgbZTDEvMfRAVu";
  File img = File("img");
  send() async {
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        "image_1": "images=/data/media/image_1.jpeg",
        "organ_1": "organs=flower"
      },
    );
  }
}
