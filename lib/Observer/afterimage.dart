import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qarshi_app/Observer/ResultDetail.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  File image = Get.arguments;
  String url = "";
  String url1 = "";
  var data = {};
  bool showSpinner = false;
  late var result;
  // ApiServices apiServices = ApiServices();

  // List<File> plantImage = [File.image, File.image];
  // getImage() async {
  //   String id = (Provider.of<dbManager>(context, listen: false)
  //               .currentobserverdoc!['uid'] +
  //           ".jpg")
  //       .toString();
  //   print("id :: $id");
  //   url = await FirebaseStorage.instance
  //       .ref()
  //       .child('TempScan/$id ')
  //       .getDownloadURL();
  //   url1 = url.substring(8);
  //   print("////////////////////////////////////////////////");
  //   print(url);
  //   setState(() {});
  // }

  Future<void> uploadImage(String type) async {
    setState(() {
      // showSpinner = true;
    });

    var stream = http.ByteStream(image.openRead());
    stream.cast();

    var length = await image.length();

    var uri = Uri.parse(
        "https://my-api.plantnet.org/v2/identify/all?include-related-images=true&no-reject=true&lang=en&api-key=2b10CIppBiSiXgbZTDEvMfRAVu");

    var request = http.MultipartRequest('POST', uri);

    request.fields['organs'] = type;

    // var multiport =;

    request.files.add(await http.MultipartFile.fromPath("images", image.path));

    var response1 = await request.send();
    var response = await http.Response.fromStream(response1);

    // print(response1.stream.toString());
    if (response1.statusCode == 200) {
      data = jsonDecode(response.body);
      setState(() {
        showSpinner = false;
      });
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }

  // Future getResult() async {
  //   return await apiServices.fetchAlbum(url1);
  // }

  @override
  void initState() {
    // init();
    // getImage();

// no need of the file extension, the name will do fine.

    // url = await ref.getDownloadURL();

    super.initState();
  }

  String dropdownvalue = 'leaf';

// List of items in our dropdown menu
  var items = [
    'leaf',
    'flower',
    'fruit',
    'bark',
    'auto',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Results',
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Not Satisfied ?",
                style: TextStyle(color: Colors.red),
              ),
              style:
                  ElevatedButton.styleFrom(primary: Colors.white, elevation: 0),
            )
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
            Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15),
              child: Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: image == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                    // Image.network(
                    //   url.toString(),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      children: [
                        Text(
                          "Please Select from the following:",
                          style: TextStyle(color: Colors.red),
                        ),
                        DropdownButton(
                            // Initial Value
                            value: dropdownvalue,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down),

                            // Array list of items
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                                uploadImage(newValue);
                                showSpinner = true;
                              });
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Visibility(
                visible: showSpinner,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
                replacement: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(Button(), arguments: [data, index]);
                        },
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ), // RoundedRectangleBorder
                            child: Column(children: [
                              Stack(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Image.network(
                                        data["results"][index]["images"][0]
                                                ["url"]["o"]
                                            .toString(),
                                        fit: BoxFit.cover,
                                      )), // Ink.image
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 216, top: 5),
                                child: Text(
                                  data["results"][index]["species"]
                                          ["scientificName"]
                                      .toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 216, top: 5),
                                child: Text(
                                  data["results"][index]["species"]
                                          ["commonNames"]
                                      .toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 260, bottom: 3),
                                child: Text(
                                  data["results"][index]["score"].toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),

                              // Text
                            ])),
                      );
                    } // Stack

                    ),
              )),
        ]));
  }
}
