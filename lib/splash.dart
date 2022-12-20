import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qarshi_app/authanticate/onBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authanticate/login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool onboard = true;

  onceon() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      onboard = sharedPreferences.getBool('onboard')!;
    });
  }

  @override
  void initState() {
    super.initState();
    onceon();
    Timer(
        const Duration(milliseconds: 3000),
        () =>
            onboard ? Get.off(const OnboardingPage1()) : Get.off(const Home()));
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/Image/splash.png')),
                // const Text('QARSHI BOTANICAL GARDENS',
                //     style: TextStyle(
                //         color: Colors.red,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 24)),
                const SizedBox(
                  height: 25,
                ),
                const CircularProgressIndicator(
                  backgroundColor: Color.fromARGB(255, 255, 200, 196),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.red,
                  ),
                )
              ]),
        )));
  }
}
