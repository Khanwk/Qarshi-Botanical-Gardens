import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart%20';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:qarshi_app/Observer/start.dart';
import 'package:qarshi_app/Observer/userpage.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:qarshi_app/services/dbManager.dart';
import 'package:http/http.dart' as http;

class RequestOb extends StatefulWidget {
  const RequestOb({Key? key}) : super(key: key);

  @override
  State<RequestOb> createState() => _RequestObState();
}

class _RequestObState extends State<RequestOb> {
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
  TextEditingController _SearchQuery = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
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
  String Address = "";
  String docid = "";
  String url = "";
  String freindId = Get.arguments;
  bool spinner = true;
  // bool _value = false;
  String val = "null";
  getImage() async {
    print("id :: $freindId");
    url = await FirebaseStorage.instance
        .ref()
        .child('TempScan')
        .child(freindId)
        .getDownloadURL();

    print('url :$url');
    setState(() {
      spinner = false;
    });
  }

  deletstorageImage() async {
    await FirebaseStorage.instance
        .ref()
        .child('TempScan')
        .child(freindId)
        .delete();
  }

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

  var data = {};
  bool showspinner = false;
  bool done = false;
  Future<void> uploadImage(String type) async {
    setState(() {
      // showSpinner = true;
    });

    var stream = http.ByteStream(image1!.openRead());
    stream.cast();

    var length = await image1!.length();

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
        done = true;
      });
    } else {
      setState(() {
        // showSpinner = false;
      });
    }
  }

  getlocation() async {
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImage();
    getlocation();
    // Position position = await _getGeoLocationPosition();
    // GetAddressFromLatLong(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Request",
          style: TextStyle(color: Colors.red),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Visibility(
                  visible: spinner,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  replacement: Container(
                      decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          image: DecorationImage(
                    image: Image.network(
                      url,
                      fit: BoxFit.fill,
                    ).image,
                  ))),
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: RadioListTile(
                      title: Text(
                        "Create New",
                        style: TextStyle(color: Colors.red),
                      ),
                      value: "new",
                      groupValue: val,
                      onChanged: (value) {
                        setState(() {
                          val = value.toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: RadioListTile(
                      title: Text("Already Exist",
                          style: TextStyle(color: Colors.red)),
                      value: "already",
                      groupValue: val,
                      onChanged: (value) {
                        setState(() {
                          val = value.toString();
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            Visibility(
              visible: val == 'new',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        // visible: dropdownvalue == 'Add Observation',
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
                                    // dropdownvalueImage2.toString(),
                                    // dropdownvalueImage3.toString()
                                  );
                                  if (done) {
                                    _BotanicalName = TextEditingController(
                                        text: await data["results"][0]
                                            ["species"]["scientificName"]);
                                    _EnglishName = TextEditingController(
                                        text: await data["results"][0]
                                                ["species"]["commonNames"]
                                            .toString());
                                    _Family = TextEditingController(
                                        text: await data["results"][0]
                                                    ["species"]["family"]
                                                ['scientificName']
                                            .toString());
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'No data Found',
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
                                  backgroundColor: Colors.white, elevation: 0),
                              onPressed: (() {
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
                                textEditingController.clear();
                              }))),
                    ],
                  ),
                  showspinner == true
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Row(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: image1 == null,
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: ElevatedButton(
                                          child: const Icon(Icons.add_a_photo),
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
                                        ),
                                      ),
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
                                          child: image1 == null
                                              ? const Text('No image to show')
                                              : Image.file(image1!)),
                                    ),
                                    DropdownButton(
                                      value: dropdownvalueImage1,
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
                                  child: Visibility(
                                    visible: image2 == null,
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: ElevatedButton(
                                        child: const Icon(Icons.add_a_photo),
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
                                      ),
                                    ),
                                    // ignore: sized_box_for_whitespace
                                    replacement: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: image2 == null
                                            ? const Text('No image to show')
                                            : Image.file(image2!)),
                                  ),
                                ),
                              ),
                            ]),
                            CupertinoFormRow(
                                child: CupertinoSearchTextField(
                              prefixIcon:
                                  const Icon(Icons.location_on_outlined),
                              suffixIcon:
                                  const Icon(Icons.my_location_outlined),
                              suffixMode: OverlayVisibilityMode.notEditing,
                              placeholder: "Enter Location",
                              onSuffixTap: () async {
                                Position position =
                                    await _getGeoLocationPosition();
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: Text(
                                    "Save and Send",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 0),
                                  onPressed: () async {
                                    setState(() {
                                      showspinner = true;
                                    });

                                    final FirebaseAuth auth =
                                        FirebaseAuth.instance;
                                    final User? user = auth.currentUser;
                                    final userid = user!.uid;
                                    int max = DateTime.now().microsecond;
                                    int min = DateTime.now().millisecond;
                                    setState(() {
                                      docid = (max * min).toString();
                                    });

                                    if (image1 == null) {
                                    } else {
                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child("observations")
                                          .child(docid)
                                          .child(docid + "1");
                                      await ref.putFile(image1!);

                                      url1 = await ref.getDownloadURL();
                                      if (image2 == null) {
                                      } else {
                                        final ref = FirebaseStorage.instance
                                            .ref()
                                            .child("observations")
                                            .child(docid)
                                            .child(docid + "2");
                                        await ref.putFile(image1!);

                                        url2 = await ref.getDownloadURL();
                                        if (image3 == null) {
                                        } else {
                                          final ref = FirebaseStorage.instance
                                              .ref()
                                              .child("observations")
                                              .child(docid)
                                              .child(docid + "3");
                                          await ref.putFile(image1!);

                                          url3 = await ref.getDownloadURL();
                                        }
                                      }
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
                                      'status': "pending",
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
                                    var collectiondata = await FirebaseFirestore
                                        .instance
                                        .collection('observers')
                                        .where('role', isEqualTo: 'Researcher');
                                    var querySnapshots =
                                        await collectiondata.get();
                                    for (var snapshot in querySnapshots.docs) {
                                      var documentID = snapshot.id;
                                      //for the specific document associated with your friend

                                      //add lended money details and break loop
                                      await FirebaseFirestore.instance
                                          .collection('observers')
                                          .doc(documentID)
                                          .update({
                                        'requesturl':
                                            FieldValue.arrayRemove([freindId])
                                      });
                                      // });
                                    }
                                    List temp = Provider.of<dbManager>(context,
                                            listen: false)
                                        .currentobserverdoc['requesturl'];
                                    temp.remove(url);
                                    Provider.of<dbManager>(context,
                                            listen: false)
                                        .ChangeInfoList(temp);
                                    FirebaseFirestore.instance
                                        .collection('observers')
                                        .doc(userid)
                                        .update({
                                      "noObservation": FieldValue.increment(1)
                                    });
                                    FirebaseFirestore.instance
                                        .collection('observers')
                                        .doc(freindId)
                                        .update({
                                      'responselist':
                                          FieldValue.arrayUnion([docid]),
                                      'requests': "0"
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
                                      showspinner = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: Text(
                                    "Clear all",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      elevation: 0),
                                  onPressed: () {
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
                                ),
                              ],
                            )
                          ],
                        ),
                ],
              ),
            ),
            Visibility(
              visible: val == 'already',
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.52,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('observers')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              String id = snapshot.data!.docs[index].id;
                              DocumentSnapshot projectdata =
                                  snapshot.data!.docs[index];
                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('observers')
                                      .doc(id)
                                      .collection('observations')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot>
                                          Projectssnapshot) {
                                    if (!Projectssnapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: Projectssnapshot
                                              .data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot Subprojectdata =
                                                Projectssnapshot
                                                    .data!.docs[index];
                                            String Projectid = Projectssnapshot
                                                .data!.docs[index].id;
                                            context
                                                .read<dbManager>()
                                                .ChangeObservationDoc(
                                                    Subprojectdata);
                                            String obName = projectdata['name'];
                                            return GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<ManageRoute>()
                                                    .ChangeSepecies("Sepecies");
                                                FirebaseFirestore.instance
                                                    .collection('observers')
                                                    .doc(id)
                                                    .collection('observations')
                                                    .doc(Projectid)
                                                    .get()
                                                    .then((DocumentSnapshot
                                                        documentSnapshot) {
                                                  Get.to(const Sepecies(),
                                                      arguments:
                                                          documentSnapshot);
                                                  context
                                                      .read<dbManager>()
                                                      .ChangeObserverDoc(
                                                          projectdata);
                                                });
                                              },
                                              child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                  ), // RoundedRectangleBorder
                                                  child: Column(children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: Image.network(
                                                                      Subprojectdata[
                                                                          'image1'])
                                                                  .image,
                                                              fit: BoxFit
                                                                  .cover)),
                                                      height: 100,
                                                      width: 400,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 7,
                                                                  top: 7),
                                                          child: Container(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              // padding: const EdgeInsets.all(8.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .green,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                              )),
                                                        ),
                                                      ),
                                                      // child: Image(
                                                      //   image: AssetImage('images/plant.jpg'),
                                                      //   fit: BoxFit.cover,
                                                      // ),
                                                    ), // Ink.image
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    context
                                                                        .watch<
                                                                            dbManager>()
                                                                        .observationdoc['BotanicalName'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xff050505),
                                                                      fontSize:
                                                                          18,
                                                                    ), // TextStyle
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 10),
                                                                  child: Text(
                                                                    obName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 10),
                                                                  child: Text(
                                                                    Subprojectdata[
                                                                        'location'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed:
                                                                (() async {
                                                              var collectiondata = await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'observers')
                                                                  .where('role',
                                                                      isEqualTo:
                                                                          'Researcher');
                                                              var querySnapshots =
                                                                  await collectiondata
                                                                      .get();
                                                              for (var snapshot
                                                                  in querySnapshots
                                                                      .docs) {
                                                                var documentID =
                                                                    snapshot.id;
                                                                //for the specific document associated with your friend

                                                                //add lended money details and break loop
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'observers')
                                                                    .doc(
                                                                        documentID)
                                                                    .update({
                                                                  'requesturl':
                                                                      FieldValue
                                                                          .arrayRemove([
                                                                    freindId
                                                                  ])
                                                                });
                                                                // });
                                                              }
                                                              List temp = Provider.of<
                                                                          dbManager>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .currentobserverdoc['requesturl'];
                                                              temp.remove(url);
                                                              // context.read<dbManager>().ChangeInfoList(temp);
                                                              Provider.of<dbManager>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .ChangeInfoList(
                                                                      temp);

                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'observers')
                                                                  .doc(freindId)
                                                                  .update({
                                                                'responselist':
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                  Projectid
                                                                ]),
                                                                'requests': "0"
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                            icon: Icon(
                                                              Icons.send,
                                                              color: Colors.red,
                                                            ))
                                                      ],
                                                    ),

                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(right: 281, top: 5),
                                                    //   child: Text(
                                                    //     '  Date ',
                                                    //     style: TextStyle(fontSize: 16),
                                                    //   ),
                                                    // ),
                                                    //
                                                    // Text
                                                  ])),
                                            );
                                          });
                                      // Card(
                                      //   child: ListTile(
                                      //     onTap: (() {
                                      //       Get.to(const Sepecies());
                                      //       context
                                      //           .read<ManageRoute>()
                                      //           .ChangeSepecies('observation');
                                      //     }),
                                      //     // leading: Text(book[index].rank.toString()),
                                      //     title: Text(Projectid),
                                      //     // trailing: Text(book[index].nObservations.toString()),
                                      //   ),
                                      // );

                                    }
                                  });
                            },
                          );
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
