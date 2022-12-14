// ignore_for_file: file_names, non_constant_identifier_names, prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart%20';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/dbManager.dart';

class ResearcherAddNew extends StatefulWidget {
  const ResearcherAddNew({Key? key}) : super(key: key);

  @override
  State<ResearcherAddNew> createState() => _ResearcherAddNewState();
}

class _ResearcherAddNewState extends State<ResearcherAddNew> {
  String? dropdownvalue;
  File? image1;
  File? image2;
  File? image3;
  var items = [
    'Add Observation',
    'Create Project',
  ];
  var itemsImages = [
    'leaf',
    'flower',
    'fruit',
    'bark',
    'auto',
  ];
  String? dropdownvalueImage1 = "auto";
  String? dropdownvalueImage2 = "auto";
  String? dropdownvalueImage3 = "auto";
  TextEditingController textEditingController = TextEditingController();

  TextEditingController _BotanicalName = TextEditingController();
  TextEditingController _LocalName = TextEditingController();
  TextEditingController _EnglishName = TextEditingController();
  TextEditingController _Family = TextEditingController();
  TextEditingController _Description = TextEditingController();
  TextEditingController _PlantType = TextEditingController();
  TextEditingController _LifeSpan = TextEditingController();
  TextEditingController _BloomingPeriod = TextEditingController();
  TextEditingController _PlantHeight = TextEditingController();
  TextEditingController _PlantSpread = TextEditingController();
  TextEditingController _Habitat = TextEditingController();
  TextEditingController _FlowerShape = TextEditingController();
  TextEditingController _FlowerColour = TextEditingController();
  TextEditingController _LeafType = TextEditingController();
  TextEditingController _FruitType = TextEditingController();
  TextEditingController _FruitColor = TextEditingController();
  TextEditingController _RootType = TextEditingController();
  TextEditingController _SunLight = TextEditingController();
  TextEditingController _Temperature = TextEditingController();
  TextEditingController _Soil = TextEditingController();
  TextEditingController _Water = TextEditingController();
  TextEditingController _Propagation = TextEditingController();
  TextEditingController _Inflorescense = TextEditingController();
  TextEditingController _LeafColor = TextEditingController();
  TextEditingController _StemShape = TextEditingController();
  TextEditingController _projectName = TextEditingController();
  TextEditingController _projectDescription = TextEditingController();

  String Address = "";
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  String status = "";
  bool done = false;
  var data = {};
  bool showSpinner = false;
  Future<void> uploadImage(String type) async {
    setState(() {
      // showSpinner = true;
    });

    var stream = http.ByteStream(image1!.openRead());
    stream.cast();

    var uri = Uri.parse(
        "https://my-api.plantnet.org/v2/identify/all?include-related-images=true&no-reject=true&lang=en&api-key=2b10CIppBiSiXgbZTDEvMfRAVu");

    var request = http.MultipartRequest('POST', uri);

    request.fields['organs'] = type;

    // var multiport =;

    request.files
        .add(await http.MultipartFile.fromPath("images", image1!.path));

    var response1 = await request.send();
    var response = await http.Response.fromStream(response1);

    // print(response1.stream.toString());
    Fluttertoast.showToast(
        msg: '${response1.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13.0);
    if (response1.statusCode == 200) {
      data = jsonDecode(response.body);
      setState(() {
        showSpinner = true;
      });
    } else {
      setState(() {
        // showSpinner = false;
      });
    }
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];

    setState(() {
      textEditingController = TextEditingController(
          text: Address =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}');
    });
  }

  String url1 = "";
  String url2 = "";
  String url3 = "";
  String obid = "";

  Future pickImage(source, image, int NoOFPic) async {
    try {
      image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      if (NoOFPic == 1) {
        setState(() {
          image1 = imageTemp;
        });
      } else if (NoOFPic == 2) {
        setState(() {
          image2 = imageTemp;
        });
      } else if (NoOFPic == 3) {
        setState(() {
          image3 = imageTemp;
        });
      }
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed');
    }
  }

  SendObservation() async {
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
        'requestobservation': FieldValue.arrayUnion([obid])
      });
    }
  }

  getlocation() async {
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
  }

  @override
  void initState() {
    super.initState();
    getlocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.07,
                  right: MediaQuery.of(context).size.width * 0.15,
                  left: MediaQuery.of(context).size.width * 0.15),
              child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.red),
                    hintText: "Select to Add",
                  ),
                  value: dropdownvalue,
                  items: items
                      .map((items) =>
                          DropdownMenuItem(value: items, child: Text(items)))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownvalue = value ?? "";
                    });
                  }),
            ),
            Visibility(
              visible: dropdownvalue != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: dropdownvalue == 'Add Observation',
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, elevation: 0),
                          onPressed: (() async {
                            if (image1 != null) {
                              await uploadImage(
                                dropdownvalueImage1.toString(),
                                // dropdownvalueImage2.toString(),
                                // dropdownvalueImage3.toString()
                              );
                              if (showSpinner) {
                                _BotanicalName = TextEditingController(
                                    text: await data["results"][0]["species"]
                                        ["scientificName"]);
                                _EnglishName = TextEditingController(
                                    text: data["results"][0]["species"]
                                            ["commonNames"]
                                        .toString());
                                _Family = TextEditingController(
                                    text: data["results"][0]["species"]
                                            ["family"]['scientificName']
                                        .toString());
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please wait',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 13.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'No image Found',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 13.0);
                            }
                          }),
                          child: const Text(
                            "Auto-Fill",
                            style: TextStyle(color: Colors.red),
                          )),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, elevation: 0),
                          onPressed: (() {
                            _projectDescription.clear();
                            _projectName.clear();
                            setState(() {
                              image1 = null;
                              image2 = null;
                              image3 = null;
                              dropdownvalueImage1 = "auto";
                              dropdownvalueImage2 = "auto";
                              dropdownvalueImage3 = "auto";
                            });

                            _BotanicalName.clear();
                            _LocalName.clear();
                            _EnglishName.clear();
                            _Family.clear();
                            _Description.clear();
                            _PlantType.clear();
                            _LifeSpan.clear();
                            _BloomingPeriod.clear();
                            _PlantHeight.clear();
                            _PlantSpread.clear();
                            _Habitat.clear();
                            _FlowerShape.clear();
                            _FlowerColour.clear();
                            _LeafType.clear();
                            _FruitType.clear();
                            _FruitColor.clear();
                            _RootType.clear();
                            _SunLight.clear();
                            _Temperature.clear();
                            _Soil.clear();
                            _Water.clear();
                            _Propagation.clear();
                            _Inflorescense.clear();
                            _LeafColor.clear();
                            _StemShape.clear();
                          }),
                          child: const Text(
                            "Clear all",
                            style: TextStyle(color: Colors.red),
                          ))),
                ],
              ),
            ),
            Visibility(
                visible: dropdownvalue == 'Create Project',
                child: Column(
                  children: [
                    CupertinoFormSection(
                        header: const Text('Project Detail'),
                        children: [
                          CupertinoTextFormFieldRow(
                            prefix: const Text('Name : '),
                            controller: _projectName,
                          ),
                          CupertinoTextFormFieldRow(
                            minLines: 2,
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            prefix: const Text('Discription : '),
                            controller: _projectDescription,
                          )
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final User? user = auth.currentUser;
                              final userid = user!.uid;
                              FirebaseFirestore.instance
                                  .collection('observers')
                                  .doc(userid)
                                  .collection('projects')
                                  .doc()
                                  .set({
                                'ProjectName': _projectName.text,
                                'ProjectDesc': _projectDescription.text,
                                'admin': userid,
                                'memberList': [userid],
                                'observationList': []
                              });
                              _projectDescription.clear();
                              _projectName.clear();
                              Fluttertoast.showToast(
                                  msg: 'Saved to your Profile',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 13.0);
                            },
                            child: const Text('Save')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.07,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _projectDescription.clear();
                              _projectName.clear();
                            },
                            child: const Text("Discard"))
                      ],
                    )
                  ],
                )),
            done == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Visibility(
                    visible: dropdownvalue == 'Add Observation',
                    child: Column(
                      // shrinkWrap: true,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.065),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: image1 == null,
                                    // ignore: sized_box_for_whitespace
                                    replacement: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: image1 == null
                                            ? const Text('No image to show')
                                            : Image.file(image1!)),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          pickImage(
                                              ImageSource.camera, image1, 1);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            // backgroundColor: Colors.white,
                                            side: const BorderSide(
                                              width: 2,
                                              color: Colors.black,
                                            )),
                                        child: const Icon(Icons.add_a_photo),
                                      ),
                                    ),
                                  ),
                                  DropdownButton(
                                    value: dropdownvalueImage1,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: itemsImages.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalueImage1 = newValue!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.065),
                              child: Visibility(
                                visible: image1 != null,
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: image2 == null,
                                      // ignore: sized_box_for_whitespace
                                      replacement: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: image2 == null
                                              ? const Text('No image to show')
                                              : Image.file(image2!)),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            pickImage(
                                                ImageSource.camera, image2, 2);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              // backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                width: 2,
                                                color: Colors.black,
                                              )),
                                          child: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                    ),
                                    DropdownButton(
                                      value: dropdownvalueImage2,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: itemsImages.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalueImage2 = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.065),
                              child: Visibility(
                                visible: image2 != null && image1 != null,
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: image3 == null,
                                      // ignore: sized_box_for_whitespace
                                      replacement: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: image3 == null
                                              ? const Text('No image to show')
                                              : Image.file(image3!)),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: ElevatedButton(
                                          onPressed: () => pickImage(
                                              ImageSource.camera, image3, 3),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              // backgroundColor: Colors.white,
                                              side: const BorderSide(
                                                width: 2,
                                                color: Colors.black,
                                              )),
                                          child: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                    ),
                                    DropdownButton(
                                      value: dropdownvalueImage3,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      items: itemsImages.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownvalueImage3 = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        CupertinoFormRow(
                            child: CupertinoSearchTextField(
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          suffixIcon: const Icon(Icons.my_location_outlined),
                          suffixMode: OverlayVisibilityMode.notEditing,
                          placeholder: "Enter Location",
                          onSuffixTap: () async {
                            Position position = await _getGeoLocationPosition();
                            GetAddressFromLatLong(position);
                          },
                          controller: textEditingController,
                        )),
                        CupertinoFormSection(
                          header: const Text('Plant Information :'),
                          children: [
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Botanical Name: '),
                              controller: _BotanicalName,
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Urdu Name : '),
                              controller: _LocalName,
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('English Name : '),
                              controller: _EnglishName,
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Family : '),
                              controller: _Family,
                            ),
                            CupertinoTextFormFieldRow(
                              minLines: 3,
                              maxLines: 4,
                              prefix: const Text('Desciption : '),
                              controller: _Description,
                            )
                          ],
                        ),
                        CupertinoFormSection(
                            header: const Text('Chracteristics'),
                            children: [
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Life Span: '),
                                controller: _LifeSpan,
                                // placeholder: '',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Blooming Period: '),
                                controller: _BloomingPeriod,
                                // placeholder: 'Enter Urdu Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Plant Height: '),
                                controller: _PlantHeight,
                                // placeholder: 'Enter English Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Plant Spread : '),
                                controller: _PlantSpread,
                                // placeholder: 'Enter Family Nam',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Habitat: '),
                                controller: _Habitat,
                                // placeholder: 'Enter Description',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Inflorescence: '),
                                controller: _Inflorescense,
                                // placeholder: 'Enter Botanical Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Flower Shape: '),
                                controller: _FlowerShape,
                                // placeholder: 'Enter Urdu Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Flower Color: '),
                                controller: _FlowerColour,
                                // placeholder: 'Enter English Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Leaf Type: '),
                                controller: _LeafType,
                                // placeholder: 'Enter Family Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Leaf Color: '),
                                controller: _LeafColor,
                                // placeholder: 'Enter Description',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Fruit Type: '),
                                controller: _FruitType,
                                // placeholder: 'Enter Botanical Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Fruit Color: '),
                                controller: _FruitColor,
                                // placeholder: 'Enter Urdu Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Stem Shape: '),
                                controller: _StemShape,
                                // placeholder: 'Enter English Name',
                              ),
                              CupertinoTextFormFieldRow(
                                prefix: const Text('Root Type: '),
                                controller: _RootType,
                                // placeholder: 'Enter Family Name',
                              ),
                            ]),
                        CupertinoFormSection(
                          header: const Text('Habitat: '),
                          children: [
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Sunlight: '),
                              controller: _SunLight,
                              // placeholder: 'Enter Botanical Name',
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Temprature: '),
                              controller: _Temperature,
                              // placeholder: 'Enter Urdu Name',
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Soil: '),
                              controller: _Soil,
                              // placeholder: 'Enter English Name',
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Water: '),
                              controller: _Water,
                              // placeholder: 'Enter Family Name',
                            ),
                            CupertinoTextFormFieldRow(
                              prefix: const Text('Propagation: '),
                              controller: _Propagation,
                              // placeholder: 'Enter Description',
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: image1 != null,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      done = true;
                                    });
                                    final FirebaseAuth auth =
                                        FirebaseAuth.instance;
                                    final User? user = auth.currentUser;
                                    final userid = user!.uid;
                                    int max = DateTime.now().microsecond;
                                    int min = DateTime.now().millisecond;

                                    final String docid = (max * min).toString();
                                    setState(() {
                                      obid = docid;
                                    });
                                    if (image1 == null) {
                                    } else {
                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child("observations")
                                          .child(docid)
                                          .child("${docid}1");
                                      await ref.putFile(image1!);

                                      url1 = await ref.getDownloadURL();
                                      if (image2 == null) {
                                      } else {
                                        final ref = FirebaseStorage.instance
                                            .ref()
                                            .child("observations")
                                            .child(docid)
                                            .child("${docid}2");
                                        await ref.putFile(image1!);

                                        url2 = await ref.getDownloadURL();
                                        if (image3 == null) {
                                        } else {
                                          final ref = FirebaseStorage.instance
                                              .ref()
                                              .child("observations")
                                              .child(docid)
                                              .child("${docid}3");
                                          await ref.putFile(image1!);

                                          url3 = await ref.getDownloadURL();
                                        }
                                      }
                                    }
                                    if (Provider.of<dbManager>(context,
                                                listen: false)
                                            .currentobserverdoc['role'] ==
                                        'Observer') {
                                      setState(() {
                                        status = 'pending';
                                      });
                                      SendObservation();
                                      // Fluttertoast.showToast(
                                      //     msg: 'Observer',
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 13.0);
                                    } else {
                                      setState(() {
                                        status = 'approved';
                                      });
                                      // Fluttertoast.showToast(
                                      //     msg: 'Researcher',
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     timeInSecForIosWeb: 1,
                                      //     backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 13.0);
                                    }

                                    // String url1 = getImage(docid, "1");
                                    // String url2 = getImage(docid, "2");
                                    // String url3 = getImage(docid, "3");

                                    await FirebaseFirestore.instance
                                        .collection('observers')
                                        .doc(userid)
                                        .collection('observations')
                                        .doc(docid)
                                        .set({
                                      'uid': docid,
                                      'status': status,
                                      'image1': url1,
                                      'image2': url2,
                                      'image3': url3,
                                      'BotanicalName': _BotanicalName.text,
                                      'LocalName': _LocalName.text,
                                      'EnglishName': _EnglishName.text,
                                      'Family': _Family.text,
                                      'Description': _Description.text,
                                      'location': textEditingController.text,
                                      'PlantType': _PlantType.text,
                                      'LifeSpan': _LifeSpan.text,
                                      'BloomingPeriod': _BloomingPeriod.text,
                                      'PlantHeight': _PlantHeight.text,
                                      'PlantSpread': _PlantSpread.text,
                                      'Habitat': _Habitat.text,
                                      'FlowerShape': _FlowerShape.text,
                                      'FlowerColour': _FlowerColour.text,
                                      'LeafType': _LeafType.text,
                                      'FruitType': _FruitType.text,
                                      'FruitColor': _FlowerColour.text,
                                      'RootType': _RootType.text,
                                      'Inflorescense': _Inflorescense.text,
                                      'LeafColor': _LeafColor.text,
                                      'StemShape': _StemShape.text,
                                      'SunLight': _SunLight.text,
                                      'Temperature': _Temperature.text,
                                      'Soil': _Soil.text,
                                      'Water': _Water.text,
                                      'Propagation': _Propagation.text,
                                      'Date': DateTime.now()
                                    });
                                    FirebaseFirestore.instance
                                        .collection('observers')
                                        .doc(userid)
                                        .update({
                                      "noObservation": FieldValue.increment(1)
                                    });

                                    setState(() {
                                      image1 = null;
                                      image2 = null;
                                      image3 = null;
                                    });

                                    _BotanicalName.clear();
                                    _LocalName.clear();
                                    _EnglishName.clear();
                                    _Family.clear();
                                    _Description.clear();
                                    _PlantType.clear();
                                    _LifeSpan.clear();
                                    _BloomingPeriod.clear();
                                    _PlantHeight.clear();
                                    _PlantSpread.clear();
                                    _Habitat.clear();
                                    _FlowerShape.clear();
                                    _FlowerColour.clear();
                                    _LeafType.clear();
                                    _FruitType.clear();
                                    _FruitColor.clear();
                                    _RootType.clear();
                                    _SunLight.clear();
                                    _Temperature.clear();
                                    _Soil.clear();
                                    _Water.clear();
                                    _Propagation.clear();
                                    _Inflorescense.clear();
                                    _LeafColor.clear();
                                    _StemShape.clear();
                                    setState(() {
                                      done = false;
                                    });
                                  },
                                  child: const Text('Save')),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.07,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    image1 = null;
                                    image2 = null;
                                    image3 = null;
                                  });

                                  _BotanicalName.clear();
                                  _LocalName.clear();
                                  _EnglishName.clear();
                                  _Family.clear();
                                  _Description.clear();
                                  _PlantType.clear();
                                  _LifeSpan.clear();
                                  _BloomingPeriod.clear();
                                  _PlantHeight.clear();
                                  _PlantSpread.clear();
                                  _Habitat.clear();
                                  _FlowerShape.clear();
                                  _FlowerColour.clear();
                                  _LeafType.clear();
                                  _FruitType.clear();
                                  _FruitColor.clear();
                                  _RootType.clear();
                                  _SunLight.clear();
                                  _Temperature.clear();
                                  _Soil.clear();
                                  _Water.clear();
                                  _Propagation.clear();
                                  _Inflorescense.clear();
                                  _LeafColor.clear();
                                  _StemShape.clear();
                                },
                                child: const Text("Discard"))
                          ],
                        )
                      ],
                    ))
          ],
        ),
      ),
    );
  }
}
