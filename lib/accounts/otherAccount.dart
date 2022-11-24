import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart%20' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/authanticate/login.dart';
import 'package:qarshi_app/services/storage.dart';

import '../Observer/CreateProject.dart';
import '../Observer/Sepecies.dart';
import '../Observer/chat.dart';
import '../services/RouteManager.dart';
import '../services/dbManager.dart';

class OtherAccount extends StatefulWidget {
  const OtherAccount({Key? key}) : super(key: key);

  @override
  State<OtherAccount> createState() => _OtherAccountState();
}

class _OtherAccountState extends State<OtherAccount> {
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
    String id =
        (Provider.of<dbManager>(context, listen: false).observerdoc['uid'] +
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
              child: const Text("Save"),
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
                title: const Text(
                  'Observer',
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  Visibility(
                    visible: context.watch<dbManager>().observerdoc['uid'] !=
                        context.watch<dbManager>().currentobserverdoc['uid'],
                    child: IconButton(
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
                  ),
                ]),
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
                                      // Provider.of<dbManager>(context,
                                      //         listen: false)
                                      //     .currentobserverdoc!['name']
                                      context
                                          .watch<dbManager>()
                                          .observerdoc['name']
                                          .toString(),
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
                                        const Icon(
                                      Icons.download,
                                      color: Colors.red,
                                    ),
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
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                          children: [
                            const TabBar(
                              // isScrollable: true,
                              labelColor: Colors.red,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.red,

                              tabs: [
                                Tab(
                                  child: Text(
                                    'Observations',
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Projects',
                                  ),
                                  // text: 'Projects',
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
                                              isEqualTo: Provider.of<dbManager>(
                                                      context,
                                                      listen: false)
                                                  .observerdoc['uid'])
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
                                                        child: Center(
                                                          child: Text(
                                                              "No Observation Yet !"),
                                                        ),
                                                      );
                                                    } else {
                                                      return ListView.builder(
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
                                                                      ])),
                                                            );
                                                          });
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
                                              isEqualTo: Provider.of<dbManager>(
                                                      context,
                                                      listen: false)
                                                  .observerdoc['uid'])
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
                                                        child: Center(
                                                          child: Text(
                                                              "No Projects Yet !"),
                                                        ),
                                                      );
                                                    } else {
                                                      return ListView.builder(
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
                                                                  const Text(
                                                                      "7"),
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
            )));
  }
}
