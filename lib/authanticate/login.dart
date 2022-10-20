import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/authanticate/signup.dart';
import 'package:qarshi_app/Observer/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qarshi_app/services/api_services.dart';
import 'package:qarshi_app/services/dbManager.dart';

var _passwordVisible = true;
bool _loggedin = false;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final Stream<QuerySnapshot> observerStream = FirebaseFirestore.instance
  //     .collection('observers')
  //     .snapshots(includeMetadataChanges: true);

  // final Stream<QuerySnapshot> researcherStream =
  //     FirebaseFirestore.instance.collection('observers').snapshots();

  // void login() async {
  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text.trim();

  //   if (email == "" || password == '') {
  //     Fluttertoast.showToast(
  //         msg: "Please Enter Email and Password properly !",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 13.0);
  //   } else {
  //     try {
  //       UserCredential userCredential = await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(email: email, password: password);
  //       if (userCredential.user != null) {
  //         Get.to(Start());
  //       }
  //     } on FirebaseAuthException catch (ex) {
  //       log(ex.code.toString());
  //     }
  //   }
  // }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User user = result.user!;

      Get.off(const Start());
// if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = const TextStyle(color: Colors.grey, fontSize: 14);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);
    // return Sizer(builder: (context, orientation, deviceType) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _loggedin
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.red,
              ))
            : Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.11,
                      ),
                      child: InkWell(
                        onTap: () {
                          ApiServices.fetchAlbum();
                        },
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 34,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.05,
                          left: MediaQuery.of(context).size.width * 0.05,
                          top: MediaQuery.of(context).size.height * 0.11),
                      child: TextField(
                        controller: _emailController,
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
                        controller: _passwordController,
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
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.width * 0.5),
                        child: RichText(
                          text: TextSpan(
                            style: defaultStyle,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Forget Password',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {}),
                            ],
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.065,
                            child: ElevatedButton(
                                onPressed: () async {
                                  bool signing = true;
                                  setState(() {
                                    _loggedin = true;
                                  });

                                  if (_emailController.text != "" ||
                                      _passwordController.text != "") {
                                    try {
                                      final credential = await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email:
                                                  _emailController.text.trim(),
                                              password:
                                                  _passwordController.text);
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        setState(() {
                                          signing = false;
                                          _loggedin = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: 'invalid email',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 13.0);
                                      } else if (e.code == 'wrong-password') {
                                        setState(() {
                                          signing = false;
                                          _loggedin = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: 'Invalid password',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 13.0);
                                      }
                                    }
                                    if (signing) {
                                      final FirebaseAuth auth =
                                          FirebaseAuth.instance;
                                      final User? user = auth.currentUser;
                                      final userid = user!.uid;
                                      Map<String, dynamic> data = {};

                                      FirebaseFirestore.instance
                                          .collection('observers')
                                          .doc(userid)
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        data = documentSnapshot.data()
                                            as Map<String, dynamic>;

                                        setState(() {
                                          _loggedin = false;

                                          context
                                              .read<dbManager>()
                                              .ChangeCurrentObserverDoc(
                                                  documentSnapshot);
                                          _emailController.clear();
                                          _passwordController.clear();

                                          _loggedin = false;
                                        });

                                        Get.off(const Start(),
                                            arguments: data['role']);

                                        // else if (data['role'] == 'Researcher') {
                                        //   Get.off(ResearcherHome(),
                                        //       arguments: data['role']);
                                        // }
                                        // print(context.watch<ManageRoute>().User);
                                      });
                                    }

                                    // print(context.watch<ManageRoute>().User);

                                    //  {
                                    //     Fluttertoast.showToast(
                                    //         msg: "Email or Password invalid!",
                                    //         toastLength: Toast.LENGTH_SHORT,
                                    //         gravity: ToastGravity.BOTTOM,
                                    //         timeInSecForIosWeb: 1,
                                    //         backgroundColor: Colors.red,
                                    //         textColor: Colors.white,
                                    //         fontSize: 13.0);
                                    //   }
                                    // login();
                                  } else {
                                    setState(() {
                                      _loggedin = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please Enter Email and Password !",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 13.0);
                                  }
                                },
                                child: FittedBox(
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(
                                          width: 3, color: Colors.red),
                                    ))))),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  //   child: Visibility(
                  //     visible: SizerUtil.deviceType != DeviceType.mobile,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.065,
                    child: ElevatedButton(
                      child:
                          const FittedBox(child: Text('Sign In with Google')),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: const BorderSide(width: 3, color: Colors.red),
                          )),
                      onPressed: () {
                        signup(context);
                      },
                    ),
                  ),
                ),
                // ),
                // Padding(
                //     padding: EdgeInsets.only(
                //         top: MediaQuery.of(context).size.height * 0.02),
                //     child: Visibility(
                //       visible: SizerUtil.deviceType == DeviceType.mobile,
                //       child: SizedBox(
                //         width: MediaQuery.of(context).size.width * 0.20,
                //         height: MediaQuery.of(context).size.height * 0.20,
                //         child: Image.asset('assets/Image/splash.png'),
                //       ),
                //     )),
                const Spacer(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.1,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                  style: defaultStyle,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Don\'t have any account!  ',
                                        style: TextStyle(fontSize: 14)),
                                    TextSpan(
                                        text: 'Sign Up',
                                        style: linkStyle,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.to(() => const SignUp());
                                          }),
                                  ],
                                ),
                              ),
                            ])))
              ]),
      ),
    );
  }
}
