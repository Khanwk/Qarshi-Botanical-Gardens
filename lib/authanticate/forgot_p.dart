// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qarshi_app/authanticate/login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool done = false;
  final TextEditingController _emailController = TextEditingController();
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
    setState(() {
      done = false;
    });
    Fluttertoast.showToast(
        msg: "Sent to your email. Please check spam !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13.0);
    Get.off(const Home());
  }

  bool isEmailCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.red),
        ),
        backgroundColor: Colors.white,
        // iconTheme: IconButton(onPressed: () {}, icon: Icon(Icons.abc_sharp)),
      ),
      body: done
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Enter your email to reset your password."),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailController,
                    // onChanged: (val) {
                    //   setState(() {
                    //     isEmailCorrect = isEmail(val);
                    //   });
                    // },
                    style: const TextStyle(color: Colors.black),
                    showCursor: true,
                    decoration: InputDecoration(
                      // labelText: "Email",
                      hintText: "somthing@email.com",
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      floatingLabelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isEmailCorrect == false
                                ? Colors.grey
                                : Colors.red,
                            width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.065,
                    child: ElevatedButton(
                        onPressed: (() {
                          setState(() {
                            done = true;
                          });
                          resetPassword();
                        }),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side:
                                  const BorderSide(width: 3, color: Colors.red),
                            )),
                        child: const FittedBox(
                          child: Text(
                            'Send Reset Email',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        )))
              ],
            ),
    );
  }
}
