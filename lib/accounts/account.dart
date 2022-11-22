import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart%20' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/authanticate/login.dart';
import 'package:qarshi_app/services/dbManager.dart';
import 'package:qarshi_app/Observer/CreateProject.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:qarshi_app/Observer/chat.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../services/RouteManager.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  /// this will delete app's storage
  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.off(const Home());
  }

  bool shouldpop() {
    context.read<ManageRoute>().ChangeProfile("Profile");
    return true;
  }

  // String acc = Get.arguments;
  int obn = 0;
  int rank = 0;
  File? image;
  File? Captureimage;
  String path = "";
  String url = "";
  // Storage storage = Storage();

  getImage() async {
    String id = (Provider.of<dbManager>(context, listen: false)
                .currentobserverdoc['uid'] +
            ".jpg")
        .toString();
    print("id :: $id");
    url = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('observers/$id ')
        .getDownloadURL();

    print('url :$url');
    setState(() {});
  }

  @override
  void initState() {
    // init();
    getImage();
// no need of the file extension, the name will do fine.

    // url = await ref.getDownloadURL();

    super.initState();
  }

  // Future<void> init() async {
  //   // File? imageFile = await storage.getImageFile(
  //   //     (Provider.of<dbManager>(context, listen: false)
  //   //             .currentobserverdoc!['uid'])
  //   //         .toString());
  //   // if (mounted && imageFile != null) {
  //   //   setState(() {
  //   //     image = imageFile;
  //   //   });
  //   // }

  //   print(url);
  // }
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

  showAlert(BuildContext context) {
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
                        Captureimage!.path,
                        (Provider.of<dbManager>(context, listen: false)
                                    .currentobserverdoc['uid'] +
                                ".jpg")
                            .toString())
                    .then((value) => print(Captureimage!.path));
                Navigator.of(context).pop();
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
      showAlert(context);
    } on PlatformException {
      print("Failed");
    }
  }

  List<Widget> accountSettings = [];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return shouldpop();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.red,
              elevation: 0,
              centerTitle: true,
              title: Visibility(
                visible: context.watch<ManageRoute>().Profile == 'ObserverAcc',
                child: const Text(
                  'Observer',
                  style: TextStyle(color: Colors.white),
                ),
                replacement: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                Visibility(
                  visible:
                      context.watch<ManageRoute>().Profile != 'ObserverAcc',
                  child: IconButton(
                      onPressed: () {
                        context.read<ManageRoute>().NoObservationLIst([]);
                        context.read<ManageRoute>().ObserverLIst([]);
                        _deleteAppDir();
                        logout();
                      },
                      icon: const Icon(Icons.logout)),
                  replacement: IconButton(
                      onPressed: () {
                        Get.to(const ChatPage(),
                            arguments:
                                Provider.of<dbManager>(context, listen: false)
                                    .observerdoc['uid']);
                      },
                      icon: const Icon(
                        Icons.message,
                        color: Colors.white,
                      )),
                )
              ],
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 230,
                      child: Stack(
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(0, -1),
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                ),
                              ),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.05),
                                    child: Text(
                                      Provider.of<dbManager>(context,
                                              listen: false)
                                          .currentobserverdoc['name']
                                      // context
                                      //     .watch<dbManager>()
                                      //     .observerdoc!['name']
                                      //     .toString()
                                      ,
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Stack(
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
                                  child: CachedNetworkImage(
                                    imageUrl: url.toString(),
                                    placeholder: (conteext, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                    ),
                                    height: 50,
                                  ),

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
                                                  leading:
                                                      const Icon(Icons.photo),
                                                  title: const Text('Photo'),
                                                  onTap: () {
                                                    pickImage(
                                                        ImageSource.gallery);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                ListTile(
                                                  leading:
                                                      const Icon(Icons.camera),
                                                  title: const Text('Camera'),
                                                  onTap: () {
                                                    pickImage(
                                                        ImageSource.camera);
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
                        ],
                      ),
                    ),
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        initialIndex: 0,
                        child: Column(
                          children: [
                            const TabBar(
                              // isScrollable: true,
                              labelColor: Colors.red,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.red,
                              // labelColor: FlutterFlowTheme.of(context).primaryColor,
                              // labelStyle: FlutterFlowTheme.of(context).bodyText1,
                              // indicatorColor:
                              //     FlutterFlowTheme.of(context).secondaryColor,
                              tabs: [
                                Tab(
                                  child: Text(
                                    'Observations',
                                  ),
                                  // text: 'Observations',
                                ),
                                Tab(
                                  child: Text(
                                    'Projects',
                                  ),
                                  // text: 'Projects',
                                ),
                                Tab(
                                  child: Text(
                                    'Edit Profile',
                                  ),
                                  // text: 'Edit Profile',
                                ),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('observers')
                                          .where('uid',
                                              isEqualTo: context
                                                  .watch<dbManager>()
                                                  .currentobserverdoc['uid'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return ListView.builder(
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              String id =
                                                  snapshot.data!.docs[index].id;
                                              DocumentSnapshot projectdata =
                                                  snapshot.data!.docs[index];
                                              return StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('observers')
                                                      .doc(id)
                                                      .collection(
                                                          'observations')
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          Projectssnapshot) {
                                                    if (!Projectssnapshot
                                                        .hasData) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              Projectssnapshot
                                                                  .data!
                                                                  .docs
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            DocumentSnapshot
                                                                Subprojectdata =
                                                                Projectssnapshot
                                                                        .data!
                                                                        .docs[
                                                                    index];
                                                            String Projectid =
                                                                Projectssnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id;
                                                            context
                                                                .read<
                                                                    dbManager>()
                                                                .ChangeObservationDoc(
                                                                    Subprojectdata);
                                                            String obName =
                                                                projectdata[
                                                                    'name'];
                                                            return GestureDetector(
                                                              onTap: () {
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'observers')
                                                                    .doc(id)
                                                                    .collection(
                                                                        'observations')
                                                                    .doc(
                                                                        Projectid)
                                                                    .get()
                                                                    .then((DocumentSnapshot
                                                                        documentSnapshot) {
                                                                  Get.to(
                                                                      const Sepecies(),
                                                                      arguments:
                                                                          documentSnapshot);
                                                                  context
                                                                      .read<
                                                                          dbManager>()
                                                                      .ChangeObserverDoc(
                                                                          projectdata);
                                                                });
                                                              },
                                                              child: Card(
                                                                  clipBehavior: Clip
                                                                      .antiAlias,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            24),
                                                                  ), // RoundedRectangleBorder
                                                                  child: Column(
                                                                      children: [
                                                                        Container(
                                                                          decoration: const BoxDecoration(
                                                                              image: DecorationImage(
                                                                                  image: ExactAssetImage(
                                                                                    'assets/Image/splash.png',
                                                                                  ),
                                                                                  fit: BoxFit.cover)),
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              400,
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(right: 7, top: 7),
                                                                              child: Container(
                                                                                  width: 20.0,
                                                                                  height: 20.0,
                                                                                  // padding: const EdgeInsets.all(8.0),
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                    color: Colors.green,
                                                                                    border: Border.all(color: Colors.black),
                                                                                  )),
                                                                            ),
                                                                          ),
                                                                          // child: Image(
                                                                          //   image: AssetImage('images/plant.jpg'),
                                                                          //   fit: BoxFit.cover,
                                                                          // ),
                                                                        ), // Ink.image
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 10),
                                                                          child:
                                                                              Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              context.watch<dbManager>().observationdoc['BotanicalName'],
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color(0xff050505),
                                                                                fontSize: 18,
                                                                              ), // TextStyle
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        // Positioned(
                                                                        //   right: 5,
                                                                        //   child: Text(
                                                                        //     '* ',
                                                                        //     style: TextStyle(
                                                                        //       fontWeight: FontWeight.bold,
                                                                        //       color: Color(0xffcb1212),
                                                                        //       fontSize: 40,
                                                                        //     ), // TextStyle
                                                                        //   ),
                                                                        // ),

                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5, left: 10),
                                                                            child:
                                                                                Text(
                                                                              obName,
                                                                              style: const TextStyle(fontSize: 16),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 5, left: 10),
                                                                            child:
                                                                                Text(
                                                                              Subprojectdata['location'],
                                                                              style: const TextStyle(fontSize: 16),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child: IconButton(
                                                                              icon: Icon(Icons.delete),
                                                                              onPressed: (() {
                                                                                FirebaseFirestore.instance.collection('observers').doc(id).collection('observations').doc(Projectid).delete();
                                                                                firebase_storage.FirebaseStorage.instance.ref().child('/observations/$id/$id+"1" ').delete();
                                                                                firebase_storage.FirebaseStorage.instance.ref().child('/observations/$id/$id+"2" ').delete();
                                                                                firebase_storage.FirebaseStorage.instance.ref().child('/observations/$id/$id+"3" ').delete();
                                                                              }),
                                                                            )),
                                                                        // Padding(
                                                                        //   padding: const EdgeInsets.only(right: 281, top: 5),
                                                                        //   child: Text(
                                                                        //     '  Date ',
                                                                        //     style: TextStyle(fontSize: 16),
                                                                        //   ),
                                                                        // ),
                                                                        //
                                                                        // Text
                                                                      ])),
                                                            );
                                                          });
                                                      // Card(
                                                      //   child: ListTile(
                                                      //     onTap: (() {
                                                      //       Get.to(const Sepecies());
                                                      //       context
                                                      //           .read<ManageRoute>()
                                                      //           .ChangeSepecies('observation');
                                                      //     }),
                                                      //     // leading: Text(book[index].rank.toString()),
                                                      //     title: Text(Projectid),
                                                      //     // trailing: Text(book[index].nObservations.toString()),
                                                      //   ),
                                                      // );

                                                    }
                                                  });
                                            },
                                          );
                                        }
                                      }),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('observers')
                                          .where('uid',
                                              isEqualTo: context
                                                  .watch<dbManager>()
                                                  .currentobserverdoc['uid'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return ListView.builder(
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              String id =
                                                  snapshot.data!.docs[index].id;
                                              return StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('observers')
                                                      .doc(id)
                                                      .collection('projects')
                                                      .snapshots(),
                                                  builder: (BuildContext
                                                          context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          Projectssnapshot) {
                                                    if (!Projectssnapshot
                                                        .hasData) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            Projectssnapshot
                                                                .data!
                                                                .docs
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          DocumentSnapshot
                                                              Subprojectdata =
                                                              Projectssnapshot
                                                                  .data!
                                                                  .docs[index];
                                                          String Projectid =
                                                              Projectssnapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id;
                                                          return Card(
                                                            child: ListTile(
                                                              onTap: (() {
                                                                Get.to(
                                                                    const Project());
                                                                context
                                                                    .read<
                                                                        ManageRoute>()
                                                                    .ChangeProject(
                                                                        'Show Project');
                                                              }),
                                                              // leading: Text(book[index].rank.toString()),
                                                              title: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      Subprojectdata[
                                                                          'ProjectName'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    const Text(
                                                                      "Members:",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    )
                                                                  ]),
                                                              trailing:
                                                                  IconButton(
                                                                icon: Icon(Icons
                                                                    .delete),
                                                                onPressed: (() {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'observers')
                                                                      .doc(id)
                                                                      .collection(
                                                                          'projects')
                                                                      .doc(
                                                                          Projectid)
                                                                      .delete();
                                                                }),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  });
                                            },
                                          );
                                        }
                                      }),
                                  Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        //       appBar: AppBar(
        //         backgroundColor: Colors.red,
        //         elevation: 0,
        //         centerTitle: true,
        //         title: Visibility(
        //           visible: context.watch<ManageRoute>().Profile == 'ObserverAcc',
        //           child: const Text(
        //             'Observer',
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           replacement: const Text(
        //             'Profile',
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ),
        //         actions: [
        //           Visibility(
        //               visible:
        //                   context.watch<ManageRoute>().Profile != 'ObserverAcc',
        //               child: IconButton(
        //                   onPressed: () {
        //                     context.read<ManageRoute>().NoObservationLIst([]);
        //                     context.read<ManageRoute>().ObserverLIst([]);
        //                     _deleteAppDir();
        //                     logout();
        //                   },
        //                   icon: const Icon(Icons.logout)))
        //         ],
        //       ),
        //       body: Column(children: [
        //         Stack(
        //   fit: StackFit.expand,
        //   children: [
        //     Container(
        //       margin: const EdgeInsets.only(bottom: 50),
        //       decoration: const BoxDecoration(
        //           gradient: LinearGradient(
        //               begin: Alignment.bottomCenter,
        //               end: Alignment.topCenter,
        //               colors: [Color(0xff0043ba), Color(0xff006df1)]),
        //           borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(50),
        //             bottomRight: Radius.circular(50),
        //           )),
        //     ),
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: SizedBox(
        //         width: 150,
        //         height: 150,
        //         child: Stack(
        //           fit: StackFit.expand,
        //           children: [
        //             Container(
        //               decoration: const BoxDecoration(
        //                 color: Colors.black,
        //                 shape: BoxShape.circle,
        //                 image: DecorationImage(
        //                     fit: BoxFit.cover,
        //                     image: NetworkImage(
        //                         'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
        //               ),
        //             ),
        //             Positioned(
        //               bottom: 0,
        //               right: 0,
        //               child: CircleAvatar(
        //                 radius: 20,
        //                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //                 child: Container(
        //                   margin: const EdgeInsets.all(8.0),
        //                   decoration: const BoxDecoration(
        //                       color: Colors.green, shape: BoxShape.circle),
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        //   ],
        // ),
        //         Expanded(
        //           child: SingleChildScrollView(
        //             child: Column(children: [
        //               Visibility(
        //                 visible:
        //                     'ObserverAcc' != context.watch<ManageRoute>().Profile,
        //                 child: ExpansionTile(
        //                   title: const Text('Personal Setting'),
        //                   subtitle: const Text('Change your personal settings.'),
        //                   children: <Widget>[
        //                     const TextField(
        //                       decoration:
        //                           InputDecoration(hintText: 'Enter your Name'),
        //                     ),
        //                     const TextField(
        //                       decoration:
        //                           InputDecoration(hintText: 'Enter your Email'),
        //                     ),
        //                     const TextField(
        //                       decoration:
        //                           InputDecoration(hintText: 'Enter your Password'),
        //                     ),
        //                     const TextField(
        //                       decoration: InputDecoration(
        //                           hintText: 'Enter Confirm Password'),
        //                     ),
        //                     ElevatedButton(
        //                       onPressed: () {},
        //                       child: const Text('Save Changes'),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //               ExpansionTile(
        //                 title: const Text('Observattions'),
        //                 // subtitle: Text('Ob'),
        //                 children: <Widget>[
        //                   SizedBox(
        //                     height: MediaQuery.of(context).size.height * 0.2,
        //                     child: ListView.builder(
        //                         itemCount: 3,
        //                         itemBuilder: (context, index) {
        //                           return Card(
        //                             child: ListTile(
        //                               onTap: () => Get.to(const Sepecies(),
        //                                   arguments: ['Observe', 4]),
        //                               title: Text('Observation $index'),
        //                             ),
        //                           );
        //                         }),
        //                   )
        //                 ],
        //               ),
        //               ExpansionTile(
        //                 title: const Text('Projects'),
        //                 // subtitle: Text('Ob'),
        //                 children: <Widget>[
        //                   StreamBuilder(
        //                       stream: FirebaseFirestore.instance
        //                           .collection('observers')
        //                           .snapshots(),
        //                       builder: (BuildContext context,
        //                           AsyncSnapshot<QuerySnapshot> snapshot) {
        //                         if (!snapshot.hasData) {
        //                           return const Center(
        //                             child: CircularProgressIndicator(),
        //                           );
        //                         } else {
        //                           return ListView.builder(
        //                               itemCount: snapshot.data!.docs.length,
        //                               itemBuilder: (context, index) {
        //                                 String id = snapshot.data!.docs[index].id;
        //                                 return StreamBuilder(
        //                                     stream: FirebaseFirestore.instance
        //                                         .collection('observers')
        //                                         .doc(id)
        //                                         .collection('projects')
        //                                         .snapshots(),
        //                                     builder: (BuildContext context,
        //                                         AsyncSnapshot<QuerySnapshot>
        //                                             Projectssnapshot) {
        //                                       if (!snapshot.hasData) {
        //                                         return const Center(
        //                                           child:
        //                                               CircularProgressIndicator(),
        //                                         );
        //                                       } else {
        //                                         return Card(
        //                                           child: ListTile(
        //                                             onTap: () {
        //                                               Get.to(const Project());
        //                                               context
        //                                                   .read<ManageRoute>()
        //                                                   .ChangeProject(
        //                                                       'ProjectShow');
        //                                             },
        //                                             title: Text('Project $index'),
        //                                           ),
        //                                         );
        //                                       }
        //                                     });
        //                               });
        //                         }
        //                       })
        //                 ],
        //               ),
        //             ]),
        //           ),
        //         ),
        //       ]),
        //     );
        //   }),
        // );
        );
  }
}
