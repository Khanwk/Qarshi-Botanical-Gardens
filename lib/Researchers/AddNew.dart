// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  TextEditingController textEditingController = TextEditingController();

  final TextEditingController _BotanicalName = TextEditingController();
  final TextEditingController _LocalName = TextEditingController();
  final TextEditingController _EnglishName = TextEditingController();
  final TextEditingController _Family = TextEditingController();
  final TextEditingController _Description = TextEditingController();
  final TextEditingController _PlantType = TextEditingController();
  final TextEditingController _LifeSpan = TextEditingController();
  final TextEditingController _BloomingPeriod = TextEditingController();
  final TextEditingController _PlantHeight = TextEditingController();
  final TextEditingController _PlantSpread = TextEditingController();
  final TextEditingController _Habitat = TextEditingController();
  final TextEditingController _FlowerShape = TextEditingController();
  final TextEditingController _FlowerColour = TextEditingController();
  final TextEditingController _LeafType = TextEditingController();
  final TextEditingController _FruitType = TextEditingController();
  final TextEditingController _FruitColor = TextEditingController();
  final TextEditingController _RootType = TextEditingController();
  final TextEditingController _SunLight = TextEditingController();
  final TextEditingController _Temperature = TextEditingController();
  final TextEditingController _Soil = TextEditingController();
  final TextEditingController _Water = TextEditingController();
  final TextEditingController _Propagation = TextEditingController();
  final TextEditingController _Inflorescense = TextEditingController();
  final TextEditingController _LeafColor = TextEditingController();
  final TextEditingController _StemShape = TextEditingController();
  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _projectDescription = TextEditingController();

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

  // ignore: non_constant_identifier_names
  Future pickImage(source, image, int NoOFPic) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
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
                                  .doc(_projectName.text)
                                  .set({
                                'ProjectName': _projectName.text,
                                'ProjectDesc': _projectDescription.text,
                                'admin': true
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
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
                          child: Visibility(
                            visible: image1 == null,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                child: const Icon(Icons.add_a_photo),
                                onPressed: () =>
                                    pickImage(ImageSource.camera, image1, 1),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    backgroundColor: Colors.white,
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
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: image1 == null
                                    ? const Text('No image to show')
                                    : Image.file(image1!)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Visibility(
                            visible: image2 == null,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                child: const Icon(Icons.add_a_photo),
                                onPressed: () {
                                  pickImage(ImageSource.camera, image2, 2);
                                },
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    backgroundColor: Colors.white,
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
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: image2 == null
                                    ? const Text('No image to show')
                                    : Image.file(image2!)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.065),
                          child: Visibility(
                            visible: image3 == null,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                child: const Icon(Icons.add_a_photo),
                                onPressed: () =>
                                    pickImage(ImageSource.camera, image3, 3),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    backgroundColor: Colors.white,
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
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: image3 == null
                                    ? const Text('No image to show')
                                    : Image.file(image3!)),
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
                        ElevatedButton(
                            onPressed: () {
                              final FirebaseAuth auth = FirebaseAuth.instance;
                              final User? user = auth.currentUser;
                              final userid = user!.uid;
                              FirebaseFirestore.instance
                                  .collection('observers')
                                  .doc(userid)
                                  .collection('observations')
                                  .doc(_BotanicalName.text)
                                  .set({
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
