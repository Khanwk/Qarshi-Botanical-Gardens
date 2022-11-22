// ignore_for_file: file_names, non_constant_identifier_names

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

  // ignore: non_constant_identifier_names
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

  var data = {};
  bool showSpinner = false;
  Future<void> uploadImage(String type1, String type2, String type3) async {
    setState(() {
      // showSpinner = true;
    });

    var stream = http.ByteStream(image1!.openRead());
    stream.cast();
    var stream2 = http.ByteStream(image1!.openRead());
    stream2.cast();
    var stream3 = http.ByteStream(image1!.openRead());
    stream3.cast();

    var length = await image1!.length();

    var uri = Uri.parse(
        "https://my-api.plantnet.org/v2/identify/all?include-related-images=true&no-reject=true&lang=en&api-key=2b10CIppBiSiXgbZTDEvMfRAVu");

    var request = http.MultipartRequest('POST', uri);
    if (image1 != null && image2 != null && image3 != null) {
      request.fields['organs'] = type1;
      request.files
          .add(await http.MultipartFile.fromPath("images", image1!.path));
      request.fields['organs'] = type2;
      request.files
          .add(await http.MultipartFile.fromPath("images", image2!.path));
      request.fields['organs'] = type3;
      request.files
          .add(await http.MultipartFile.fromPath("images", image3!.path));
    } else if (image2 == null && image3 == null) {
      request.fields['organs'] = type1;
      request.files
          .add(await http.MultipartFile.fromPath("images", image1!.path));
    } else if (image3 == null) {
      request.fields['organs'] = type1;
      request.files
          .add(await http.MultipartFile.fromPath("images", image1!.path));
      request.fields['organs'] = type2;
      request.files
          .add(await http.MultipartFile.fromPath("images", image2!.path));
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

    // var multiport =;

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

  // ignore: non_constant_identifier_names
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

  // ignore: non_constant_identifier_names
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
                          child: Text(
                            "Auto-Fill",
                            style: TextStyle(color: Colors.red),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white, elevation: 0),
                          onPressed: (() async {
                            if (image1 != null) {
                              uploadImage(
                                  dropdownvalueImage1.toString(),
                                  dropdownvalueImage2.toString(),
                                  dropdownvalueImage3.toString());
                              _BotanicalName = TextEditingController(
                                  text: await data["results"][0]["species"]
                                      ["scientificName"]);
                              _EnglishName = TextEditingController(
                                  text: await data["results"][0]["species"]
                                          ["commonNames"]
                                      .toString());
                              _Family = TextEditingController(
                                  text: await data["results"][0]["species"]
                                          ["family"]['scientificName']
                                      .toString());
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
                          })),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          child: Text(
                            "Clear all",
                            style: TextStyle(color: Colors.red),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white, elevation: 0),
                          onPressed: (() {
                            _projectDescription.clear();
                            _projectName.clear();
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
                          }))),
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
                            minLines: 3,
                            maxLines: 4,
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
            Visibility(
                visible: dropdownvalue == 'Add Observation',
                child: Column(
                  // shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Column(
                            children: [
                              Visibility(
                                visible: image1 == null,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: ElevatedButton(
                                    child: const Icon(Icons.add_a_photo),
                                    onPressed: () {
                                      pickImage(ImageSource.camera, image1, 1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        // backgroundColor: Colors.white,
                                        side: const BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                                // ignore: sized_box_for_whitespace
                                replacement: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: image1 == null
                                        ? const Text('No image to show')
                                        : Image.file(image1!)),
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
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Visibility(
                            visible: image1 != null,
                            child: Visibility(
                              visible: image2 == null,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
                                  child: const Icon(Icons.add_a_photo),
                                  onPressed: () {
                                    pickImage(ImageSource.camera, image2, 2);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      // backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                              // ignore: sized_box_for_whitespace
                              replacement: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: image2 == null
                                      ? const Text('No image to show')
                                      : Image.file(image2!)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Visibility(
                            visible: image2 != null && image1 != null,
                            child: Visibility(
                              visible: image3 == null,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: ElevatedButton(
                                  child: const Icon(Icons.add_a_photo),
                                  onPressed: () =>
                                      pickImage(ImageSource.camera, image3, 3),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      // backgroundColor: Colors.white,
                                      side: const BorderSide(
                                        width: 2,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                              // ignore: sized_box_for_whitespace
                              replacement: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: image3 == null
                                      ? const Text('No image to show')
                                      : Image.file(image3!)),
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
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final User? user = auth.currentUser;
                                final userid = user!.uid;
                                int max = DateTime.now().microsecond;
                                int min = DateTime.now().millisecond;
                                final String docid = (max * min).toString();
                                if (image1 == null) {
                                } else {
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child("observations")
                                      .child(docid)
                                      .child(docid + "1");
                                  await ref.putFile(image1!);

                                  url1 = await ref.getDownloadURL();
                                }
                                if (image1 == null) {
                                } else {
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child("observations")
                                      .child(docid)
                                      .child(docid + "2");
                                  await ref.putFile(image1!);

                                  url2 = await ref.getDownloadURL();
                                }
                                if (image1 == null) {
                                } else {
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child("observations")
                                      .child(docid)
                                      .child(docid + "3");
                                  await ref.putFile(image1!);

                                  url3 = await ref.getDownloadURL();
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
