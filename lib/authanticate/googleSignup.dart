// ignore_for_file: unused_local_variable, avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart%20' as firebase_storage;
import 'package:qarshi_app/Observer/start.dart';

class GoogleSignup extends StatefulWidget {
  const GoogleSignup({Key? key}) : super(key: key);

  @override
  State<GoogleSignup> createState() => _GoogleSignupState();
}

class _GoogleSignupState extends State<GoogleSignup> {
  var user = Get.arguments;
  String url = "";
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _Address = TextEditingController();
  bool check = false;

  final _formKey = GlobalKey<FormState>();
  File? image;
  File? Captureimage;
  String path = "";
  bool done = false;
  Future<String> uploadObserverFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('observers/$fileName ').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
    String downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('observers/$fileName ')
        .getDownloadURL();

    setState(() {
      done = false;
    });
    return downloadUrl;
  }

  Future pickImage(source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() {
        Captureimage = imageTemp;
        path = image.path;
      });
    } on PlatformException {
      print("Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _firstName.text = user.displayName;
      // var metaData = user.metadata;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign up Page'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: _formKey,
        child: done
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0, 1),
                          child: Container(
                              width: 120,
                              height: 120,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Captureimage == null
                                  ? Image.network(user.photoURL)
                                  : Image.file(Captureimage!)),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.25, 1),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                const Color.fromARGB(255, 209, 209, 209),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Color(0xFFF83232),
                                size: 22,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(Icons.photo),
                                            title: const Text('Photo'),
                                            onTap: () {
                                              pickImage(ImageSource.gallery);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.camera),
                                            title: const Text('Camera'),
                                            onTap: () {
                                              pickImage(ImageSource.camera);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _firstName,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[[A-Z]|[a-z]][[A-Z]|[a-z]|\\d|[_]]{7,29}$")
                                  .hasMatch(value)) {
                            // r'^[a-z A-Z]+S'
                            return "Enter First name *";
                          } else {
                            return null;
                          }
                        },
                        showCursor: true,
                        // style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          labelText: _firstName.text,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ),
                  // ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _Address,
                        maxLines: 4,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[[A-Z]|[a-z]][[A-Z]|[a-z]|\\d|[_]]{7,29}$")
                                  .hasMatch(value)) {
                            // r'^[a-z A-Z]+S'
                            return "Enter Address";
                          } else {
                            return null;
                          }
                        },
                        showCursor: true,
                        // style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Address",
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  Captureimage != null &&
                                  check) {
                                setState(() {
                                  done = true;
                                });
                                // FirebaseAuth.instance
                                //     .createUserWithEmailAndPassword(
                                //         email: _SignupEmailController.text,
                                //         password:
                                //             _SignupPasswordController.text)
                                //     .then((signedInUser) {
                                //   UserManagment().storeNewObserver(
                                //       signedInUser,
                                //       _nameController,
                                //       _addressController,
                                //       context);
                                // }).catchError((e) {});

                                // try {
                                //   FirebaseAuth.instance
                                //       .createUserWithEmailAndPassword(
                                //     email: _email.text.trim(),
                                //     password: _password.text.trim(),
                                //   )
                                //       .then((signedInUser) async {
                                if (Captureimage != null) {
                                  setState(() async {
                                    // String url = await uploadObserverFile(
                                    //     Captureimage!.path, user.uid);
                                  });
                                } else {
                                  setState(() {
                                    // String url = user.url;
                                  });
                                }

                                FirebaseFirestore.instance
                                    .collection('observers')
                                    .doc(user.uid)
                                    .set({
                                  'email': user.email,
                                  'image': url,
                                  'name': _firstName.text.trim(),
                                  'address': _Address.text.trim(),
                                  'role': 'Observer',
                                  'noObservation': 0,
                                  'ProjectRequest': [],
                                  'requestobservation': [],
                                  'uid': user.uid,
                                  'requesturl': [],
                                  'requests': 0,
                                  'responselist': []
                                });
                                Get.off(const Start());
                              }
                              // }).then((signedInUser) {
                              //   Fluttertoast.showToast(
                              //       msg: 'success ',
                              //       toastLength: Toast.LENGTH_SHORT,
                              //       gravity: ToastGravity.BOTTOM,
                              //       timeInSecForIosWeb: 1,
                              //       backgroundColor: Colors.red,
                              //       textColor: Colors.white,
                              //       fontSize: 13.0);

                              //   _LastName.clear();
                              //   _firstName.clear();
                              //   _email.clear();
                              //   _password.clear();
                              //   _otp.clear();

                              //     });
                              //   });
                              // } on FirebaseAuthException catch (e) {
                              //   switch (e.code) {
                              //     case 'weak-password':
                              //       Fluttertoast.showToast(
                              //           msg:
                              //               'The password provided is too weak.',
                              //           toastLength: Toast.LENGTH_SHORT,
                              //           gravity: ToastGravity.BOTTOM,
                              //           timeInSecForIosWeb: 1,
                              //           backgroundColor: Colors.red,
                              //           textColor: Colors.white,
                              //           fontSize: 13.0);
                              //       break;
                              //     case 'email-already-in-use':
                              //       Fluttertoast.showToast(
                              //           msg:
                              //               'The account already exists for that email.',
                              //           toastLength: Toast.LENGTH_SHORT,
                              //           gravity: ToastGravity.BOTTOM,
                              //           timeInSecForIosWeb: 1,
                              //           backgroundColor: Colors.red,
                              //           textColor: Colors.white,
                              //           fontSize: 13.0);
                              //       break;
                              //     default:
                              //       Fluttertoast.showToast(
                              //           msg: e.code,
                              //           toastLength: Toast.LENGTH_SHORT,
                              //           gravity: ToastGravity.BOTTOM,
                              //           timeInSecForIosWeb: 1,
                              //           backgroundColor: Colors.red,
                              //           textColor: Colors.white,
                              //           fontSize: 13.0);
                              //   }

                              //   // if (e.code == 'weak-password') {
                              //   // } else if (e.code == 'email-already-in-use') {}
                              // }
                              //  else {
                              //   Fluttertoast.showToast(
                              //       msg: "Please add your profile image",
                              //       toastLength: Toast.LENGTH_SHORT,
                              //       gravity: ToastGravity.BOTTOM,
                              //       timeInSecForIosWeb: 1,
                              //       backgroundColor: Colors.red,
                              //       textColor: Colors.white,
                              //       fontSize: 13.0);
                              // }
                            },
                            child: const Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
