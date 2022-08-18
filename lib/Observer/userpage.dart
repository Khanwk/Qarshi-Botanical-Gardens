import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:qarshi_app/Observer/afterimage.dart';
import 'package:qarshi_app/accounts/account.dart';
import 'package:qarshi_app/services/HomePage.dart';
import 'package:qarshi_app/services/observers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../services/RouteManager.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

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
      if (image != null) {
        Get.to(Results(), arguments: imageTemp);
      }
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException catch (e) {
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
                body: HomePage(),
                // Scaffold(
                //   appBar: AppBar(
                //     backgroundColor: Colors.white,
                //     centerTitle: true,
                //     title: SizedBox(
                //       height: 65,
                //       width: 65,
                //       child: Image.asset('assets/Image/splash.png'),
                //     ),
                //     // leadingWidth: 100,
                //     // actions: [
                //     //   Padding(
                //     //       padding: EdgeInsets.only(
                //     //           right: MediaQuery.of(context).size.width * 0.05),
                //     //       child: const IconButton(
                //     //           onPressed: null,
                //     //           icon: Icon(
                //     //             Icons.notifications,
                //     //             color: Colors.red,
                //     //             size: 32.0,
                //     //           )))
                //     // ],

                //     elevation: 0,
                //     toolbarHeight: MediaQuery.of(context).size.height * 0.1,
                //     bottom: TabBar(
                //       isScrollable: true,
                //       labelColor: Colors.red,
                //       unselectedLabelColor: Colors.grey,
                //       indicatorColor: Colors.red,
                //       tabs: [
                //         Container(
                //             width: MediaQuery.of(context).size.width * 0.3,
                //             child: Column(
                //               children: [
                //                 const Text('Observations'),
                //                 Text('${observation.length}')
                //               ],
                //             )),
                //         Container(
                //             width: MediaQuery.of(context).size.width * 0.3,
                //             child: Column(
                //               children: [
                //                 const Text('Observers'),
                //                 Text('${observer.length}')
                //               ],
                //             )),
                //         Container(
                //             width: MediaQuery.of(context).size.width * 0.3,
                //             child: Column(
                //               children: [
                //                 const Text('Sepecies'),
                //                 Text('${sepecies.length}')
                //               ],
                //             )),
                //         Container(
                //             width: MediaQuery.of(context).size.width * 0.3,
                //             child: Column(
                //               children: [
                //                 const Text('Projects'),
                //                 Text('${book.length}')
                //               ],
                //             )),
                //       ],
                //     ),
                //   ),
                //   body: TabBarView(children: [
                //     ListView.builder(
                //       itemCount: observation.length,
                //       itemBuilder: (context, index) {
                //         return Card(
                //           child: ListTile(
                //             onTap: (() {
                //               Get.to(Sepecies(), arguments: ['Observe', 4]);
                //             }),
                //             leading: Text(observation[index].rank.toString()),
                //             title: Text(observation[index].name.toString()),
                //             trailing:
                //                 Text(observation[index].nObservations.toString()),
                //           ),
                //         );
                //       },
                //     ),
                //     ListView.builder(
                //       itemCount: observer.length,
                //       itemBuilder: (context, index) {
                //         return Card(
                //           child: ListTile(
                //             onTap: (() {
                //               Get.to(Account(), arguments: 'Observer');
                //             }),
                //             leading: Text(observer[index].rank.toString()),
                //             title: Text(observer[index].name.toString()),
                //             trailing:
                //                 Text(observer[index].nObservations.toString()),
                //           ),
                //         );
                //       },
                //     ),
                //     ListView.builder(
                //       itemCount: sepecies.length,
                //       itemBuilder: (context, index) {
                //         return Card(
                //           child: ListTile(
                //             onTap: () {
                //               Get.to(Sepecies(), arguments: ['Sepecies', 3]);
                //               ;
                //             },
                //             leading: Text(sepecies[index].rank.toString()),
                //             title: Text(sepecies[index].name.toString()),
                //             trailing:
                //                 Text(sepecies[index].nObservations.toString()),
                //           ),
                //         );
                //       },
                //     ),
                //     ListView.builder(
                //       itemCount: book.length,
                //       itemBuilder: (context, index) {
                //         return Card(
                //           child: ListTile(
                //             onTap: (() {}),
                //             leading: Text(book[index].rank.toString()),
                //             title: Text(book[index].name.toString()),
                //             trailing: Text(book[index].nObservations.toString()),
                //           ),
                //         );
                //       },
                //     ),
                //   ]),

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

                // floatingActionButton: FloatingActionButton(
                //   onPressed: () async {
                //     await availableCameras().then((value) => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => CameraPage(cameras: value))));
                //     // Add your onPresed code here!
                //   },
                //   backgroundColor: Colors.red,
                //   child: const Icon(CupertinoIcons.camera),
                // ),
              ),
            ),
          ));
    });
  }
}
