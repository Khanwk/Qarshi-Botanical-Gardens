// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http;

// class ApiServices {
//   var data = {};
//   fetchAlbum(img1) async {
//     // var img1 = Uri.parse(
//     //     "https://firebasestorage.googleapis.com/v0/b/qarshibotanicalgardens-927c3.appspot.com/o/TempScan%2F6geEYiMPHYe9HsuxmefTTm2cS4N2.jpg%20?alt=media&token=47b473c2-5b92-4c3f-ba1b-9928137ff84b");
//     // var img2 = "https%3A%2F%2Fmy.plantnet.org%2Fimages%2Fimage_2.jpeg";
//     final response = await http.get(Uri.parse(
//         'https://my-api.plantnet.org/v2/identify/all?images=${img1}&organs=leaf&include-related-images=true&no-reject=false&lang=en&api-key=2b10CIppBiSiXgbZTDEvMfRAVu'));

//     if (response.statusCode == 200) {
//       print("************************************");
//       print(img1);
//       data = jsonDecode(response.body);
//       // print(data["results"]);
//       return (data["results"]);
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       // return Album.fromJson(jsonDecode(response.body));
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load album');
//     }
//   }
// }
