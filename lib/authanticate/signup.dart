import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qarshi_app/authanticate/login.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

var _passwordVisible = true;
var _value = false;

class _SignUpState extends State<SignUp> {
  TextEditingController _SignupEmailController = TextEditingController();
  TextEditingController _SignupPasswordController = TextEditingController();
  TextEditingController _ConfirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  Future creaeUser(
      {required String name,
      required String email,
      required String password,
      required String address}) async {
    final docUser = FirebaseFirestore.instance.collection('observers').doc();
    final observerData = {
      'id': docUser.id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'observer': true
    };
    await docUser.set(observerData);
    Get.off(Home());
  }

  void Signup() async {
    String email = _SignupEmailController.text.trim();
    String password = _SignupPasswordController.text.trim();
    String confirmPassword = _ConfirmPasswordController.text.trim();
    // String name = _nameController.text.trim();
    // String address = _addressController.text.trim();

    if (password != confirmPassword) {
      Fluttertoast.showToast(
          msg: "Password Don't Match !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 13.0);
    }
    if (email == '' || password == '' || confirmPassword == '') {
      Fluttertoast.showToast(
          msg: "Please Fill all Feilds !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 13.0);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // User user = userCredential.user!;
        // await FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user.uid)
        //     .set({'name': name, 'address': address});
        if (userCredential.user != null) {
          Get.off(Home());
        }
      } on FirebaseAuthException catch (ex) {
        log(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 20.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.08),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 34,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.07),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle),
                      hintText: 'Enter Full Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: TextField(
                    controller: _SignupEmailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Enter Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: TextField(
                    controller: _SignupPasswordController,
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                      suffixIconColor: Colors.grey,
                      hintText: 'Enter Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: TextField(
                    controller: _ConfirmPasswordController,
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                      suffixIconColor: Colors.grey,
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                      left: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: TextField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.home),
                      hintText: '\n  Address (Optional)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03),
                  child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Accept terms and contions'),
                      activeColor: Colors.grey,
                      checkColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      value: _value,
                      selected: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = !_value;
                        });
                      }),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.065,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_SignupPasswordController.text !=
                                  _ConfirmPasswordController.text) {
                                Fluttertoast.showToast(
                                    msg: "Password Don't Match !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 13.0);
                              }
                              if (_SignupEmailController.text == '' ||
                                  _SignupPasswordController.text == '' ||
                                  _ConfirmPasswordController.text == '' ||
                                  _addressController.text == '' ||
                                  _nameController.text == '') {
                                Fluttertoast.showToast(
                                    msg: "Please Fill all Feilds !",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 13.0);
                              } else {
                                creaeUser(
                                    name: _nameController.text,
                                    email: _SignupEmailController.text,
                                    password: _SignupPasswordController.text,
                                    address: _addressController.text);
                              }
                              // Signup();
                            },
                            child: const Text(
                              'Sign Up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(
                                      width: 3, color: Colors.red),
                                ))))),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.1),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: defaultStyle,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Already have an account  '),
                                    TextSpan(
                                        text: 'Sign In',
                                        style: linkStyle,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.back();
                                          }),
                                  ],
                                ),
                              ),
                            ])))
              ]),
            )));
  }
}
