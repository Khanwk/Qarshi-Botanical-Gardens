// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  //*Now i'm going to createavariable that
  String location = "";
//*and now let's createafunction that will get the current location
  // void getCurrentLocation() async {
  //   var position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   var lastPosition = await Geolocator.getLastKnownPosition();
  //   print(lastPosition);
  //   setState(() {
  //     locationMesssage = "$position.latitude,$position.longitude";
  //   });
  // }

  DateTime dateTime = DateTime.now();
  File? image;
  bool locat = true;
  Future pickImage(source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException {
      print('Failed');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
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
    return await Geolocator.getCurrentPosition();
  }

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: location);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    setState(() => location =
        '${place.street},${place.subLocality},${place.subAdministrativeArea},${place.administrativeArea},${place.country}');
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: const Text('Camera')),
                CupertinoActionSheetAction(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: const Text('Gallery')),
                CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'))
              ],
            ));
  }

  // late CameraController controller;
  // XFile? pictureFile;
  // @override
  // void initState() {
  //   super.initState();
  //   controller = CameraController(widget.cameras![0], ResolutionPreset.max);
  //   controller.initialize().then((_) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {});
  //   });
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // if (!controller.value.isInitialized) {
    //   return const SizedBox(
    //     child: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: (Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.08,
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: 'Name of Plant',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.08,
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.22,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: ElevatedButton(
                              onPressed: () {
                                _showActionSheet(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          width: 3, color: Colors.grey))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02),
                                    child: const FittedBox(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        // size: 14.sp,
                                      ),
                                    ),
                                  ),
                                  const FittedBox(
                                    child: Text(
                                      'Add Image',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  CupertinoFormSection(
                      header: const Text('Description'),
                      children: [
                        CupertinoTextFormFieldRow(
                          prefix: const Icon(Icons.notes_outlined),
                          // placeholder: 'Enter Description',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                        // CupertinoFormRow(
                        //   child: ElevatedButton(
                        //       child: const Icon(Icons.my_location),
                        //       onPressed: () async {
                        //         Position position = await _determinePosition();
                        //         GetAddressFromLatLong(position);
                        //       }),
                        // ),
                        // Row(
                        //   children: [
                        //     CupertinoButton(
                        //         child: const Icon(Icons.my_location),
                        //         onPressed: () async {
                        //           Position position = await _determinePosition();
                        //           debugPrint('${position.latitude}');
                        //           location =
                        //               'lat: ${position.latitude},long: ${position.longitude}';
                        //           setState(() {});
                        //         }),
                        //   ],
                        // ),

                        CupertinoFormRow(
                          child: CupertinoSearchTextField(
                              prefixIcon: const Icon(
                                Icons.location_on,
                                color: Colors.black,
                              ),
                              suffixIcon: const Icon(
                                Icons.my_location,
                                color: Colors.black,
                              ),
                              controller: _textController,
                              placeholder: ' Location',
                              backgroundColor: Colors.white,
                              // itemSize: 50,
                              suffixMode: OverlayVisibilityMode.notEditing,
                              onSuffixTap: () async {
                                Position position = await _determinePosition();
                                GetAddressFromLatLong(position);
                              }),
                        ),

                        // CupertinoTextFormFieldRow(
                        //   prefix: const Icon(Icons.notes_outlined),
                        //   placeholder: 'Enter Description',
                        //   validator: (String? value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter a value';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        CupertinoFormRow(
                          prefix: const Icon(Icons.date_range),
                          child: Row(
                            children: [
                              CupertinoButton(
                                  // Display a CupertinoDatePicker in dateTime picker mode.
                                  onPressed: () => _showDialog(
                                        CupertinoDatePicker(
                                          initialDateTime: dateTime,
                                          // This is called when the user changes the dateTime.
                                          onDateTimeChanged:
                                              (DateTime newDateTime) {
                                            setState(
                                                () => dateTime = newDateTime);
                                          },
                                        ),
                                      ),
                                  child: Text(
                                    '${dateTime.month}-${dateTime.day}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}',
                                    style: const TextStyle(
                                        fontSize: 18.0, color: Colors.black),
                                  )),
                            ],
                          ),
                        ),
                      ]),
                  const Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                      child: const Text('Or')),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.045,
                      // child: TextButton(
                      //     onPressed: () {
                      //       Get.to(const Project());
                      //       context
                      //           .read<ManageRoute>()
                      //           .ChangeProject('project');
                      //     },
                      child: const Text('Create Project')
                      //  ),
                      )
                ],
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen.shade200),
                          child: const Icon(
                            Icons.done,
                            size: 45,
                          )),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                image = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade200),
                            child: const Icon(
                              Icons.cancel,
                              size: 45,
                            ))),
                  ],
                ),
              ),
              // Center(
              //   child: SizedBox(
              //     height: MediaQuery.of(context).size.height * 0.76,
              //     width: MediaQuery.of(context).size.width,
              //     child: CameraPreview(controller),
              //   ),
              // ),
              // FloatingActionButton(
              //   child: const Icon(Icons.camera),
              //   onPressed: () async {
              //     pictureFile = await controller.takePicture();
              //     setState(() {});
              //   },
              // ),
              // if (pictureFile != null)
              //   Image.network(pictureFile!.path, height: 200),
            ])),
      ),
    );

    // Scaffold(
    //   body: Center(
    //     child: Column(children: [
    //       Padding(
    //         padding:
    //             EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
    //         child: CupertinoButton(
    //             color: CupertinoColors.systemRed,
    //             child: Text('Camera'),
    //             onPressed: () {}),
    //       ),
    //       Padding(
    //         padding:
    //             EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
    //         child: CupertinoButton(
    //             color: CupertinoColors.systemRed,
    //             child: Text('From Gallery'),
    //             onPressed: () {}),
    //       ),
    //     ]),
    //   ),
    // );
  }
}
