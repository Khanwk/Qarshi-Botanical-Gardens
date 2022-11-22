// ignore_for_file: file_names
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qarshi_app/authanticate/login.dart';
import 'package:firebase_storage/firebase_storage.dart%20' as firebase_storage;
import 'package:validators/validators.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _firstName = TextEditingController();
TextEditingController _LastName = TextEditingController();
TextEditingController _Address = TextEditingController();

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  // TextEditingController textEditingController = TextEditingController(); //here
  bool isEmailCorrect = false;

  dynamic snackBar = SnackBar(
    duration: const Duration(milliseconds: 1500),
    content: const Text("Your Registration Complete"),
    action: SnackBarAction(
      label: 'Got it',
      onPressed: () {},
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        elevation: 2,
        title: const Text('Sign up Page'),
        // centerTitle: true,
        // backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _email,
                onChanged: (val) {
                  setState(() {
                    isEmailCorrect = isEmail(val);
                  });
                },
                style: const TextStyle(color: Colors.black),
                showCursor: true,
                decoration: InputDecoration(
                  // labelText: "Email",
                  hintText: "somthing@email.com",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            isEmailCorrect == false ? Colors.grey : Colors.red,
                        width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: isEmailCorrect == false
                    ? null
                    : (() {
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        Get.to(const Verify());
                      }),
                style: ButtonStyle(
                  backgroundColor: isEmailCorrect == false
                      ? MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 255, 255))
                      : MaterialStateProperty.all(Colors.white),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                      color:
                          isEmailCorrect == false ? Colors.grey : Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  // TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up Page'),
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtpTextField(
              numberOfFields: 5,
              enabledBorderColor: const Color.fromARGB(255, 151, 151, 151),
              focusedBorderColor: const Color.fromARGB(255, 225, 64, 64),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {}, // end onSubmit
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Email()),
                          );
                        },
                        child: const Text(
                          "Previous",
                          style: TextStyle(color: Colors.red),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Password()),
                          );
                        }
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    confirmController.dispose(); //here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up Page'),
        backgroundColor: Colors.red,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: _password,
                // validator: (value) {
                //   if (value!.isEmpty || !RegExp(r'[0-9]').hasMatch(value!)) {
                //     // r'^[a-z A-Z]+S'
                //     return "Add digit or symbols";
                //   } else {
                //     return null;
                //   }
                // },
                showCursor: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Password',
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  // floatingLabelStyle: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: confirmController,
                // validator: (value) {
                //   if (value!.isEmpty || !RegExp(r'[0-9]').hasMatch(value!)) {
                //     // r'^[a-z A-Z]+S'
                //     return "Add digit or symbols";
                //   } else {
                //     return null;
                //   }
                // },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Confirm Password',
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Verify()),
                        );
                      },
                      child: const Text(
                        "Previous",
                        style: TextStyle(color: Colors.red),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Final()),
                        );
                      }
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Final extends StatefulWidget {
  const Final({Key? key}) : super(key: key);

  @override
  State<Final> createState() => _FinalState();
}

class _FinalState extends State<Final> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  File? Captureimage;
  String path = "";
  bool done = false;
  Future<void> uploadObserverFile(
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
    String downloadUrl = await storage.ref().child(fileName).getDownloadURL();
    FirebaseFirestore.instance.collection('observers').doc(fileName).set({
      "image": downloadUrl,
    });
  }

  showAlert(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Align(
            alignment: Alignment.center,
            child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Captureimage == null
                    ? const Text('No image to show')
                    : Image.file(Captureimage!)),
          ),
          // content: Text("Are You Sure Want To Proceed?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                uploadObserverFile(
                    Captureimage!.path, (id + ".jpg").toString());
                Navigator.of(context).pop();

                Get.off(const Home());
              },
            ),
            ElevatedButton(
              child: Text("Discard"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Divider(
            //   height: 65.0,
            // ),
            // Align(alignment: Alignment.topRight, child: Icon(Icons.exit_to_app)),

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
                            ? Container(
                                color: Colors.grey,
                              )
                            : Image.file(Captureimage!)

                        //  url != null
                        //     ? Image.network(
                        //         ,
                        //         fit: BoxFit.cover,
                        //       )
                        //     : Center(
                        //         child: CircularProgressIndicator()),
                        ),
                    // FutureBuilder(
                    //   future: FirebaseStorage.instance
                    //       .ref()
                    //       .child('hello.jpg')
                    //       .getDownloadURL(),
                    //   builder: (BuildContext context,
                    //       AsyncSnapshot<String> snapshot) {
                    //     if (snapshot.connectionState ==
                    //             ConnectionState.done &&
                    //         snapshot.hasData) {
                    //       Container(
                    //         width: 120,
                    //         height: 120,
                    //         clipBehavior: Clip.antiAlias,
                    //         decoration: const BoxDecoration(
                    //           shape: BoxShape.circle,
                    //         ),
                    //         child: Image.network(
                    //           snapshot.data!,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       );
                    //     }
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return const CircularProgressIndicator();
                    //     }
                    //     return
                    //   },

                    // FutureBuilder),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0.25, 1),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color.fromARGB(255, 209, 209, 209),
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
                    hintText: 'First Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),

            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _LastName,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r"^[[A-Z]|[a-z]][[A-Z]|[a-z]|\\d|[_]]{7,29}$")
                            .hasMatch(value)) {
                      // r'^[a-z A-Z]+S'
                      return "Enter Last Name *";
                    } else {
                      return null;
                    }
                  },
                  showCursor: true,
                  // style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Last Name',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
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
                    hintText: 'Address',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Password()),
                        );
                      },
                      child: const Text(
                        "Previous",
                        style: TextStyle(color: Colors.red),
                      )),
                ),
                Flexible(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          Captureimage != null) {
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

                        try {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: _email.text.trim(),
                            password: _password.text.trim(),
                          )
                              .then((signedInUser) async {
                            await showAlert(context, signedInUser.user!.uid);
                            FirebaseFirestore.instance
                                .collection('observers')
                                .doc(signedInUser.user!.uid)
                                .set({
                              'email': signedInUser.user!.email,
                              'name': _firstName.text.trim() +
                                  _LastName.text.trim(),
                              'address': _Address.text.trim(),
                              'role': 'Observer',
                              'noObservation': '0',
                              'ProjectRequest': [],
                              'uid': signedInUser.user!.uid
                            }).then((signedInUser) {
                              Fluttertoast.showToast(
                                  msg: 'success ',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 13.0);
                            });
                          });
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case 'weak-password':
                              Fluttertoast.showToast(
                                  msg: 'The password provided is too weak.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 13.0);
                              break;
                            case 'email-already-in-use':
                              Fluttertoast.showToast(
                                  msg:
                                      'The account already exists for that email.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 13.0);
                              break;
                            default:
                              Fluttertoast.showToast(
                                  msg: e.code,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 13.0);
                          }
                          // if (e.code == 'weak-password') {
                          // } else if (e.code == 'email-already-in-use') {}
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please add your profile image",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 13.0);
                      }
                      // _LastName.clear();
                      // _firstName.clear();
                      // _email.clear();
                      // _password.clear();
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
          ],
        ),
      ),
    );
  }
}
