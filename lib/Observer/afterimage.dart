// ignore_for_file: unnecessary_null_comparison, avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart%20';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/ResultDetail.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:qarshi_app/services/dbManager.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  File image = Get.arguments;
  // final firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;
  // String url = "";
  // String url1 = "";
  var data = {};
  bool showSpinner = false;
  // ignore: prefer_typing_uninitialized_variables
  late var result;

  uploadTempFile(
    String filePath,
    String fileName,
  ) async {
    final ref = FirebaseStorage.instance.ref().child("TempScan").child(
        Provider.of<dbManager>(context, listen: false)
            .currentobserverdoc['uid']);
    await ref.putFile(image);
    // String url = await ref.getDownloadURL();
    var collectiondata = FirebaseFirestore.instance
        .collection('observers')
        .where('role', isEqualTo: 'Researcher');
    var querySnapshots = await collectiondata.get();
    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id;
      //for the specific document associated with your friend

      //add lended money details and break loop
      await FirebaseFirestore.instance
          .collection('observers')
          .doc(documentID)
          .update({
        'requesturl': FieldValue.arrayUnion([
          Provider.of<dbManager>(context, listen: false)
              .currentobserverdoc['uid']
        ])
      });
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(
          msg: 'Your Request has been sent to Researchers',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 13.0);
    }
    // FirebaseFirestore.instance
    //     .collection('observers')
    //     .doc(Provider.of<dbManager>(context, listen: false)
    //         .currentobserverdoc['uid'])
    //     .update({"requestsURL": url});
    //             });
  }
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
    var uri = Uri.parse(
        "https://my-api.plantnet.org/v2/identify/all?include-related-images=true&no-reject=true&lang=en&api-key=2b10CIppBiSiXgbZTDEvMfRAVu");

    var request = http.MultipartRequest('POST', uri);

    request.fields['organs'] = type;

    request.files.add(await http.MultipartFile.fromPath("images", image.path));

    var response1 = await request.send();
    var response = await http.Response.fromStream(response1);

    if (response1.statusCode == 200) {
      data = jsonDecode(response.body);
      setState(() {
        showSpinner = false;
        api = true;
      });
    } else {
      setState(() {
        showSpinner = false;
      });
    }
  }

  String requests = "";
  RequestList() async {
    var collection = FirebaseFirestore.instance.collection('observers');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      // Fluttertoast.showToast(
      //     msg:
      //         '${Provider.of<dbManager>(context, listen: false).currentobserverdoc['uid']}',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 13.0);
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (data['uid'] ==
          Provider.of<dbManager>(context, listen: false)
              .currentobserverdoc['uid']) {
        setState(() {
          requests = data['requests'];
        });
      }

      // var phone = data['phone'];
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
    RequestList();
  }

  String dropdownvalue = 'leaf';
  bool api = false;

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
            Visibility(
              visible: context.watch<dbManager>().currentobserverdoc['role'] ==
                      "Observer" &&
                  api &&
                  requests == "0",
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSpinner = true;
                  });

                  uploadTempFile(
                          image.path,
                          (Provider.of<dbManager>(context, listen: false)
                                      .currentobserverdoc['uid'] +
                                  ".jpg")
                              .toString())
                      .then((value) => print(image.path));

                  FirebaseFirestore.instance
                      .collection('observers')
                      .doc(Provider.of<dbManager>(context, listen: false)
                          .currentobserverdoc['uid'])
                      .update({"requests": '1'});
                  RequestList();
                  setState(() {
                    api = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, elevation: 0),
                child: const Text(
                  "Not Satisfied ?",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        ),
        body: showSpinner
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
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
                              const Text(
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
                      replacement: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(const Button(),
                                    arguments: [data, index]);
                                // print(
                                //     "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL${data["results"][index]["images"][0]["url"]["o"].toString()}");
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
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Image.network(
                                              data["results"][index]["images"]
                                                      [0]["url"]["o"]
                                                  .toString(),
                                              fit: BoxFit.cover,
                                            )), // Ink.image
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 216, top: 5),
                                      child: Text(
                                        data["results"][index]["species"]
                                                ["scientificName"]
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 216, top: 5),
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
                                        data["results"][index]["score"]
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),

                                    // Text
                                  ])),
                            );
                          } // Stack

                          ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )),
              ]));
  }
}
