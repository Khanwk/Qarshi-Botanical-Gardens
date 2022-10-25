import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/services/dbManager.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:qarshi_app/services/api_services.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  File image = Get.arguments;
  String url = "";
  String url1 = "";
  late var result;
  ApiServices apiServices = ApiServices();
  List plantName = ['Rose', 'Lavender', 'Mapel'];
  List plantProb = ['91.1 %', '92 %', '99 %'];
  // List<File> plantImage = [File.image, File.image];
  getImage() async {
    String id = (Provider.of<dbManager>(context, listen: false)
                .currentobserverdoc!['uid'] +
            ".jpg")
        .toString();
    print("id :: $id");
    url = await FirebaseStorage.instance
        .ref()
        .child('TempScan/$id ')
        .getDownloadURL();
    url1 = url.substring(8);
    print("////////////////////////////////////////////////");
    print(image.path);
    setState(() {});
  }

  Future getResult() async {
    return await apiServices.fetchAlbum(url1);
  }

  @override
  void initState() {
    // init();
    getImage();
    getResult();

// no need of the file extension, the name will do fine.

    // url = await ref.getDownloadURL();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Results',
              style: TextStyle(color: Colors.red),
            ),
          ),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Image.network(
                  url.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.black,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.65,
                child: FutureBuilder(
                  future: apiServices.fetchAlbum(url1),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: apiServices.data.length,
                          itemBuilder: (context, index) {
                            return Card(
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: image == null
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : Image.file(
                                                image,
                                                fit: BoxFit.cover,
                                              ),
                                      ), // Ink.image
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 216, top: 5),
                                        child: Text(
                                          apiServices.data["results"][index]
                                                  ["species"]["scientificName"]
                                              .toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 260, bottom: 3),
                                    child: Text(
                                      apiServices.data["results"][index]
                                              ["score"]
                                          .toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),

                                  // Text
                                ]));
                          } // Stack

                          );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                )
                // Card

                // Card(
                //   child: ListTile(
                //     onTap: () =>
                //         Get.to(const Sepecies(), arguments: ['Observe', 4]),
                //     leading: SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.2,
                //         width: MediaQuery.of(context).size.width * 0.25,
                //         child: image == null
                //             ? const Text('No image to show')
                //             : Image.file(image)),
                //     title: const Text('Observation'),
                //     trailing: const SizedBox(width: 40, child: Text('90 %')),
                //   ),
                // );
                ),
          ]));
    });
  }
}
