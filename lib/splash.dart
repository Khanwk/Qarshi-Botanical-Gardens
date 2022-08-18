import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qarshi_app/Researchers/BottomNaviagtor.dart';
import 'package:qarshi_app/authanticate/login.dart';
import 'package:qarshi_app/Observer/start.dart';
import 'package:qarshi_app/Observer/userpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3000), () => Get.off(Home()));
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
