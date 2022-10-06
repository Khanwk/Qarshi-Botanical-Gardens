import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/afterimage.dart';
import 'package:qarshi_app/services/HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../services/RouteManager.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

String research = 'true';

class _UserPageState extends State<UserPage> {
  ValueNotifier<bool> speedDialOpen = ValueNotifier(false);
  File? image;

  Future pickImage(source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemp = File(image.path);
      Get.to(const Results(), arguments: imageTemp);
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException {
      print("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WillPopScope(
            onWillPop: () async {
              if (speedDialOpen.value) {
                speedDialOpen.value = false;
                return false;
              } else {
                return true;
              }
            },
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                body: const HomePage(),
                floatingActionButton: Visibility(
                  visible: 'Observer' == context.watch<ManageRoute>().User,
                  child: SpeedDial(
                    animatedIcon: AnimatedIcons.search_ellipsis,
                    backgroundColor: CupertinoColors.systemRed,
                    spacing: 10,
                    spaceBetweenChildren: 8,
                    openCloseDial: speedDialOpen,
                    children: [
                      SpeedDialChild(
                          onTap: () => pickImage(ImageSource.gallery),
                          child: const Icon(Icons.image_outlined),
                          backgroundColor: CupertinoColors.white,
                          label: 'Gallery'),
                      SpeedDialChild(
                          onTap: () {
                            pickImage(ImageSource.camera);
                          },
                          child: const Icon(Icons.camera_alt_outlined),
                          backgroundColor: CupertinoColors.white,
                          label: 'Camera')
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }
}
