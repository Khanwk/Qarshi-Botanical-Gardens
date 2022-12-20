// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names, sized_box_for_whitespace, prefer_is_empty, unnecessary_string_escapes

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart%20' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/accounts/changePassword.dart';
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
  bool edit = false;
  final TextEditingController _nameEdit = TextEditingController();
  final TextEditingController _address = TextEditingController();

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  String name = "";
  String address = '';
  RequestList() async {
    var collection = FirebaseFirestore.instance.collection('observers');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      // Fluttertoast.showToast(
      //     msg:
      //         '${Provider.of<dbManager>(context, listen: false).currentobserverdoc['uid']}',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 13.0);
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (data['uid'] ==
          Provider.of<dbManager>(context, listen: false)
              .currentobserverdoc['uid']) {
        setState(() {
          name = data['name'];
          address = data['address'];
        });
      }

      // var phone = data['phone'];
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
    _deleteAppDir();
    _deleteCacheDir();
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
            .currentobserverdoc['uid'])
        .toString();

    url = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('observers/$id ')
        .getDownloadURL();
    setState(() {});
  }

  @override
  void initState() {
    // init();
    getImage();
    RequestList();
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
    String downloadUrl = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('observers/$fileName ')
        .getDownloadURL();
    FirebaseFirestore.instance
        .collection('observers')
        .doc(fileName)
        .update({'image': downloadUrl});
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
              child: const Text("Save"),
              onPressed: () {
                uploadObserverFile(
                        Captureimage!.path,
                        (Provider.of<dbManager>(context, listen: false)
                                .currentobserverdoc['uid'])
                            .toString())
                    .then((value) => print(Captureimage!.path));
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Discard"),
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
                replacement: const Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                child: const Text(
                  'Observer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                Visibility(
                  visible:
                      context.watch<ManageRoute>().Profile != 'ObserverAcc',
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
                  child: IconButton(
                      onPressed: () {
                        context.read<ManageRoute>().NoObservationLIst([]);
                        context.read<ManageRoute>().ObserverLIst([]);
                        _deleteAppDir();
                        logout();
                      },
                      icon: const Icon(Icons.logout)),
                )
              ],
            ),
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.29,
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
                                      name,
                                      style: const TextStyle(
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
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Text("Loading...")),
                                    height: 50,
                                  ),
                                ),
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
                                                    } else if (Projectssnapshot
                                                            .data!.docs.length <
                                                        1) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.2),
                                                        child: const Center(
                                                          child: Text(
                                                              "No Observation Yet !"),
                                                        ),
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
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
                                                                          decoration: BoxDecoration(
                                                                              image: DecorationImage(
                                                                                  image: Image.network(
                                                                                    Subprojectdata['image1'],
                                                                                    frameBuilder: (_, image, loadingBuilder, __) {
                                                                                      if (loadingBuilder == null) {
                                                                                        return const SizedBox(
                                                                                          height: 300,
                                                                                          child: Center(child: CircularProgressIndicator()),
                                                                                        );
                                                                                      }
                                                                                      return image;
                                                                                    },
                                                                                    loadingBuilder: (BuildContext context, Widget image, ImageChunkEvent? loadingProgress) {
                                                                                      if (loadingProgress == null) return image;
                                                                                      return SizedBox(
                                                                                        height: 300,
                                                                                        child: Center(
                                                                                          child: CircularProgressIndicator(
                                                                                            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                    errorBuilder: (_, __, ___) => Image.asset(
                                                                                      'assets\Image\splash.png',
                                                                                      height: 300,
                                                                                      fit: BoxFit.fitHeight,
                                                                                    ),
                                                                                  ).image,
                                                                                  fit: BoxFit.cover)),
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              400,
                                                                          child:
                                                                              Visibility(
                                                                            visible:
                                                                                Subprojectdata['status'] == "approved",
                                                                            replacement:
                                                                                Visibility(
                                                                              visible: Subprojectdata['status'] == "declined",
                                                                              replacement: Visibility(
                                                                                visible: Subprojectdata['status'] == "pending",
                                                                                child: Align(
                                                                                  alignment: Alignment.topRight,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(right: 7, top: 7),
                                                                                    child: Container(
                                                                                        width: 20.0,
                                                                                        height: 20.0,
                                                                                        // padding: const EdgeInsets.all(8.0),
                                                                                        decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle,
                                                                                          color: const Color.fromARGB(255, 203, 185, 21),
                                                                                          border: Border.all(color: Colors.black),
                                                                                        )),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              child: Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(right: 7, top: 7),
                                                                                  child: Container(
                                                                                      width: 20.0,
                                                                                      height: 20.0,
                                                                                      // padding: const EdgeInsets.all(8.0),
                                                                                      decoration: BoxDecoration(
                                                                                        shape: BoxShape.circle,
                                                                                        color: Colors.red,
                                                                                        border: Border.all(color: Colors.black),
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: Padding(
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
                                                                              icon: const Icon(Icons.delete),
                                                                              onPressed: (() {
                                                                                FirebaseFirestore.instance.collection('observers').doc(id).collection('observations').doc(Projectid).delete();
                                                                                firebase_storage.FirebaseStorage.instance.ref().child('observations').child(Projectid).child("${Projectid}1").delete();
                                                                                firebase_storage.FirebaseStorage.instance.ref().child('observations').child(Projectid).child("${Projectid}2").delete();
                                                                                firebase_storage.FirebaseStorage.instance.ref().child('observations').child(Projectid).child("${Projectid}3").delete();
                                                                                FirebaseFirestore.instance.collection('observers').doc(id).update({
                                                                                  'noObservation': FieldValue.increment(-1)
                                                                                });
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
                                              DocumentSnapshot projectdata =
                                                  snapshot.data!.docs[index];
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
                                                    } else if (Projectssnapshot
                                                            .data!.docs.length <
                                                        1) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.2),
                                                        child: const Center(
                                                          child: Text(
                                                              "No Projects Yet !"),
                                                        ),
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
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
                                                                context
                                                                    .read<
                                                                        dbManager>()
                                                                    .ChangeObserverDoc(
                                                                        projectdata);
                                                                context
                                                                    .read<
                                                                        dbManager>()
                                                                    .ChangeProjectDoc(
                                                                        Subprojectdata);
                                                                context
                                                                    .read<
                                                                        ManageRoute>()
                                                                    .ChangeProject(
                                                                        'Show Project');
                                                                Get.to(
                                                                    const Project(),
                                                                    arguments:
                                                                        Projectid);
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
                                                                    Text(
                                                                      "Members: ${Subprojectdata['memberList'].length}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    )
                                                                  ]),
                                                              trailing:
                                                                  IconButton(
                                                                icon: const Icon(
                                                                    Icons
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
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ListTile(
                                            onTap: null,
                                            tileColor: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            title: Text(
                                              name,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            subtitle: Text(context
                                                .watch<dbManager>()
                                                .currentobserverdoc['email']),
                                            trailing: Visibility(
                                              visible: !edit,
                                              // ignore: sort_child_properties_last
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons.create_outlined),
                                                color: const Color.fromARGB(
                                                    255, 74, 74, 74),
                                                onPressed: () {
                                                  setState(() {
                                                    edit = true;
                                                  });
                                                },
                                              ),
                                              replacement: IconButton(
                                                icon: const Icon(Icons.done),
                                                color: const Color.fromARGB(
                                                    255, 74, 74, 74),
                                                onPressed: _nameEdit
                                                            .text.isEmpty &&
                                                        _address.text.isEmpty
                                                    ? (() {
                                                        setState(() {
                                                          edit = false;
                                                        });
                                                      })
                                                    : () {
                                                        if (_nameEdit
                                                            .text.isEmpty) {
                                                          _nameEdit.text = name;
                                                        }
                                                        if (_address
                                                            .text.isEmpty) {
                                                          _address.text =
                                                              address;
                                                        }
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'observers')
                                                            .doc(Provider.of<
                                                                            dbManager>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .currentobserverdoc[
                                                                'uid'])
                                                            .update({
                                                          'name':
                                                              _nameEdit.text,
                                                          'address':
                                                              _address.text
                                                        });
                                                        RequestList();
                                                        _nameEdit.clear();
                                                        _address.clear();
                                                        Fluttertoast.showToast(
                                                            msg: "Changed !",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.red,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 13.0);

                                                        // DocumentSnapshot
                                                        //     documentSnapshot =
                                                        //     FirebaseFirestore.instance
                                                        //         .collection(
                                                        //             'observers')
                                                        //         .doc(Provider.of<
                                                        //                     dbManager>(
                                                        //                 context,
                                                        //                 listen: false)
                                                        //             .currentobserverdoc['uid'])
                                                        //         .get() as DocumentSnapshot<Object?>;
                                                        // context
                                                        //     .read<dbManager>()
                                                        //     .ChangeCurrentObserverDoc(
                                                        //         documentSnapshot);
                                                        setState(() {
                                                          edit = false;
                                                        });
                                                      },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            visible: edit,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: _nameEdit,
                                                    decoration: InputDecoration(
                                                      labelText: name,
                                                      border:
                                                          const UnderlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                    controller: _address,
                                                    decoration: InputDecoration(
                                                      labelText: address,
                                                      border:
                                                          const UnderlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: const Text(
                                              "Change Password",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Open sans",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            leading: Ink(
                                                // decoration: const ShapeDecoration(
                                                //   color: Color(0xffD9D9D9),
                                                //   shape: CircleBorder(),
                                                // ),
                                                child: const Icon(
                                              Icons.lock_reset_rounded,
                                              color: Colors.red,
                                              size: 25,
                                            )),
                                            onTap: () {
                                              Get.to(() => const ChangePass());
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => const Homepage(),
                                              //   ),
                                              // );
                                            },
                                            tileColor: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            trailing: const Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Color.fromARGB(
                                                    255, 74, 74, 74)),
                                          ),
                                        ),
                                        // visibilityByRole(widgetIsFor, userRole),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            title: const Text(
                                              "Support",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Open sans",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            leading: Ink(
                                                // decoration: const ShapeDecoration(
                                                //   color: Color(0xffD9D9D9),
                                                //   shape: CircleBorder(),
                                                // ),
                                                child: const Icon(
                                              Icons.contact_support_outlined,
                                              color: Colors.red,
                                              size: 25,
                                            )),
                                            onTap: () {
                                              // Get.to(() => const Support());
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => const Homepage(),
                                              //   ),
                                              // );
                                            },
                                            tileColor: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            trailing: const Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Color.fromARGB(
                                                    255, 74, 74, 74)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ListTile(
                                            title: const Text(
                                              "About Us",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Open sans",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            leading: Ink(
                                                // decoration: const ShapeDecoration(
                                                //   color: Color(0xffD9D9D9),
                                                //   shape: CircleBorder(),
                                                // ),
                                                child: const Icon(
                                              Icons.info_outline,
                                              color: Colors.red,
                                              size: 25,
                                            )),
                                            onTap: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) => const Homepage(),
                                              //   ),
                                              // );
                                            },
                                            tileColor: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            trailing: const Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Color.fromARGB(
                                                    255, 74, 74, 74)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
