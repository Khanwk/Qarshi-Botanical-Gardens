import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/services/dbManager.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({Key? key}) : super(key: key);

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  bool _currentisObscure = true;
  bool _newisObscure = true;
  bool cnfrmed = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController currentpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();

  // RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  // bool validatePassword(String pass) {
  //   String password = pass.trim();
  //   if (pass_valid.hasMatch(password)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Change Password"),
          centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      cursorColor: const Color.fromARGB(255, 67, 208, 128),
                      autofocus: false,
                      obscureText: _currentisObscure,
                      controller: currentpasswordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Color.fromARGB(223, 9, 66, 91),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        labelText: "Current Password",
                        suffixIcon: IconButton(
                            icon: Icon(!_currentisObscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _currentisObscure = !_currentisObscure;
                              });
                            }),
                        hintText: "Enter your Current password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (value) {
                        if (value ==
                            Provider.of<dbManager>(context, listen: false).p) {
                          setState(() {
                            cnfrmed = true;
                          });
                        } else {
                          setState(() {
                            cnfrmed = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: cnfrmed,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        cursorColor: const Color.fromARGB(255, 67, 208, 128),
                        autofocus: false,
                        obscureText: _newisObscure,
                        controller: newpasswordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Color.fromARGB(223, 9, 66, 91),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          labelText: "New Password",
                          suffixIcon: IconButton(
                              icon: Icon(!_newisObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _newisObscure = !_newisObscure;
                                });
                              }),
                          hintText: "Enter your New password",
                          // labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          // errorStyle: const TextStyle(
                          //     color: Color.fromARGB(255, 246, 18, 18),
                          //     fontSize: 15),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Password";
                          } else {
                            //call function to check password
                            // bool result = validatePassword(value);
                            // if (newpasswordController ==
                            //     confirmpasswordController) {
                            if (value.trim().length < 6) {
                              return 'password must be at least 6 characters in length';
                            }
                            //     // create account event
                            //     return null;
                            // } else {
                            //   return "Password don't match";
                            // }
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        cursorColor: const Color.fromARGB(255, 67, 208, 128),
                        autofocus: false,
                        obscureText: _newisObscure,
                        controller: confirmpasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Password";
                          } else {
                            //call function to check password
                            // bool result = validatePassword(value);
                            // if (newpasswordController ==
                            //     confirmpasswordController) {
                            if (value.trim().length < 6) {
                              return 'password must be at least 6 characters in length';
                            }
                            //     // create account event
                            //     return null;
                            // } else {
                            //   return "Password don't match";
                          }
                          // }
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Color.fromARGB(223, 9, 66, 91),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 255, 255, 255),
                          labelText: "Confirm Password",

                          suffixIcon: IconButton(
                              icon: Icon(!_newisObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _newisObscure = !_newisObscure;
                                });
                              }),
                          hintText: "Enter your Confirm password",
                          // labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          // errorStyle: const TextStyle(
                          //     color: Color.fromARGB(255, 246, 18, 18),
                          //     fontSize: 15),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    cnfrmed) {
                                  FirebaseAuth.instance.currentUser!
                                      .updatePassword(
                                          newpasswordController.text);
                                  context.read<dbManager>().ChangeP(
                                      newpasswordController.text.trim());
                                  setState(() {
                                    cnfrmed = false;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Save',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ])));
  }
}
