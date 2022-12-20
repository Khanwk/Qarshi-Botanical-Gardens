// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_is_empty, unnecessary_string_escapes
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart%20';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/CreateProject.dart';
import 'package:qarshi_app/Observer/chat.dart';
import 'package:qarshi_app/Observer/requestAuth.dart';
import 'package:qarshi_app/Observer/requestOb.dart';
import 'package:qarshi_app/accounts/otherAccount.dart';
import 'package:qarshi_app/push.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:get/get.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:qarshi_app/services/dbManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// final productProvider = Provider.of<CRUDModel>(context);

class _HomePageState extends State<HomePage> {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  late DocumentSnapshot obdata;
  bool request = true;
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();
  late SharedPreferences prefs;
  List imgesUrl = [];
  List requestimages = [];
  List ObservationRequest = [];
  List responselist = [];
  getImage(freindId) async {
    List imgesUrl = [];
    imgesUrl.add(await FirebaseStorage.instance
        .ref()
        .child('observations/$freindId/$freindId+"1" ')
        .getDownloadURL());
    setState(() {});
  }

  int i = 0;
  int message = 0;
  List lstMsglocal = [];
  List newmsg = [];
  String currentid = "";

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
          ObservationRequest = data['requestobservation'];
          requestimages = data['requesturl'];
          responselist = data['responselist'];
        });
      }

      // var phone = data['phone'];
    }
  }

  RequestMessageList() async {
    var collection = FirebaseFirestore.instance
        .collection('observers')
        .doc(currentid)
        .collection('messages');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      Timestamp time = data['time'] as Timestamp;
      final DateTime dateTime = time.toDate();
      newmsg.add(dateTime);
      if (!lstMsglocal.contains(dateTime)) {
        setState(() {
          message += 1;
        });
      }
    }

    // Fluttertoast.showToast(
    //     msg: '$newmsg',
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 13.0);
    setState(() {
      lstMsglocal = newmsg;
      newmsg = [];
    });
  }

  saveStringListMessage() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("", ["pizza", "burger", "sandwich"]);
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app

    //await Firebase.initializeApp();
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    // String? token = await FirebaseMessaging.instance.getToken();

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          log("We are listening");
          _notificationInfo = notification;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: const Duration(seconds: 2),
          );
        }
      });
    } else {
      log('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    // setState(() {
    //   currentid = Provider.of<dbManager>(context, listen: false)
    //       .currentobserverdoc['uid'];
    // });
    // RequestList();

    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   RequestMessageList();

    //   // lstMsglocal = [];
    // });
    registerNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: SizedBox(
          height: 65,
          width: 65,
          child: Image.asset('assets/Image/splash.png'),
        ),
        leadingWidth: 100,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                // lstMsglocal = newmsg;
                message = 0;
              });

              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        elevation: 20,
                        scrollable: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0))),
                        title: const Center(child: Text('Messages')),
                        contentPadding: EdgeInsets.zero,
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 1,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('observers')
                                  .doc(context
                                      .watch<dbManager>()
                                      .currentobserverdoc["uid"])
                                  .collection('messages')
                                  .orderBy('time', descending: true)
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.docs.length < 1) {
                                    return const Center(
                                      child: Text("No Chats Available !"),
                                    );
                                  }
                                  return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        var friendId =
                                            snapshot.data.docs[index].id;
                                        var lastMsg = snapshot.data.docs[index]
                                            ['last_msg'];

                                        lstMsglocal.add(lastMsg);
                                        return FutureBuilder(
                                          future: FirebaseFirestore.instance
                                              .collection('observers')
                                              .doc(friendId)
                                              .get(),
                                          builder: (context,
                                              AsyncSnapshot asyncSnapshot) {
                                            if (asyncSnapshot.hasData) {
                                              var friend = asyncSnapshot.data;
                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      friend['image']),
                                                  maxRadius: 20,
                                                ),
                                                // ClipRRect(
                                                //   borderRadius:
                                                //       BorderRadius.circular(
                                                //           80),
                                                //   child: CachedNetworkImage(
                                                //     // fit: BoxFit.,
                                                //     imageUrl: friend['image'],
                                                //     placeholder: (conteext,
                                                //             url) =>
                                                //         const CircularProgressIndicator(),
                                                //     errorWidget: (context,
                                                //             url, error) =>
                                                //         const Icon(
                                                //       Icons.error,
                                                //     ),
                                                //     height: 50,
                                                //   ),
                                                // ),
                                                title: Text(friend['name']),
                                                subtitle: Text(
                                                  "$lastMsg",
                                                  style: const TextStyle(
                                                      color: Colors.grey),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  context
                                                      .read<dbManager>()
                                                      .ChangeObserverDoc(
                                                          friend);
                                                  Get.to(const ChatPage(),
                                                      arguments: friend["uid"]);
                                                },
                                              );
                                            }
                                            return const LinearProgressIndicator();
                                          },
                                        );
                                      });
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ),
                        actions: <Widget>[
                          // TextButton(
                          //   onPressed: () => Navigator.pop(context, 'OK'),
                          //   child:
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, elevation: 0),
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.red),
                              )),
                          // ),
                        ],
                      ));
            },
            icon: const Icon(
              Icons.message_sharp,
              // size: 32.0,
            ),
            color: Colors.red,
          ),
          Visibility(
              visible: 'Observer' == context.watch<ManageRoute>().User ||
                  'Admin' == context.watch<ManageRoute>().User,
              child: IconButton(
                  onPressed: () {
                    RequestList();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              elevation: 20,
                              scrollable: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              // title: const Text("Requests"),
                              contentPadding: EdgeInsets.zero,
                              content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: 'Observer' ==
                                            context.watch<ManageRoute>().User,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01),
                                              child: const Text(
                                                "Responses",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: responselist.length,
                                                itemBuilder:
                                                    ((context, findex) {
                                                  // List checkList = context
                                                  //     .watch<dbManager>()
                                                  //     .projectdoc['observationList'];
                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'observers')
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          return ListView
                                                              .builder(
                                                            shrinkWrap: true,
                                                            itemCount: snapshot
                                                                .data!
                                                                .docs
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              String id =
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id;
                                                              DocumentSnapshot
                                                                  projectdata =
                                                                  snapshot.data!
                                                                          .docs[
                                                                      index];
                                                              return StreamBuilder(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'observers')
                                                                      .doc(id)
                                                                      .collection(
                                                                          'observations')
                                                                      .where(
                                                                          'uid',
                                                                          isEqualTo: responselist[
                                                                              findex])
                                                                      .snapshots(),
                                                                  builder: (BuildContext
                                                                          context,
                                                                      AsyncSnapshot<
                                                                              QuerySnapshot>
                                                                          Projectssnapshot) {
                                                                    // print(
                                                                    //     "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
                                                                    // print(
                                                                    //     ObservationRequest[
                                                                    //         findex]);
                                                                    if (Projectssnapshot
                                                                        .hasData) {
                                                                      return ListView.builder(
                                                                          shrinkWrap: true,
                                                                          itemCount: Projectssnapshot.data!.docs.length,
                                                                          itemBuilder: (context, index) {
                                                                            DocumentSnapshot
                                                                                Subprojectdata =
                                                                                Projectssnapshot.data!.docs[index];
                                                                            String
                                                                                Projectid =
                                                                                Projectssnapshot.data!.docs[index].id;
                                                                            context.read<dbManager>().ChangeObservationDoc(Subprojectdata);

                                                                            String
                                                                                obName =
                                                                                projectdata['name'];
                                                                            return Card(
                                                                                clipBehavior: Clip.antiAlias,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(24),
                                                                                ), // RoundedRectangleBorder
                                                                                child: ListTile(
                                                                                  onTap: () {
                                                                                    Provider.of<dbManager>(context, listen: false).ChangeObserverDoc(projectdata);
                                                                                    context.read<ManageRoute>().ChangeSepecies("Sepecies");
                                                                                    FirebaseFirestore.instance.collection('observers').doc(id).collection('observations').doc(Projectid).get().then((DocumentSnapshot documentSnapshot) {
                                                                                      Navigator.pop(context);
                                                                                      context.read<ManageRoute>().ChangeSepecies("Response");
                                                                                      Get.to(const Sepecies(), arguments: documentSnapshot);
                                                                                    });
                                                                                  },
                                                                                  title: Text(Subprojectdata['BotanicalName']),
                                                                                  subtitle: Text(obName),
                                                                                  // trailing: IconButton(icon: Icon(Icons.delete),color: Colors.red,onPressed: () {

                                                                                  // },),
                                                                                ));
                                                                          });
                                                                    } else {
                                                                      // ignore: prefer_const_constructors
                                                                      return Visibility(
                                                                        visible:
                                                                            false,
                                                                        child:
                                                                            const Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        ),
                                                                      );
                                                                    }
                                                                  });
                                                            },
                                                          );
                                                        } else {
                                                          return const Visibility(
                                                            visible: false,
                                                            child: Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                          );
                                                        }
                                                      });
                                                })),
                                            const Divider(
                                              thickness: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                        child: const Text(
                                          "Project Requests",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('observers')
                                              .doc(context
                                                  .watch<dbManager>()
                                                  .currentobserverdoc['uid'])
                                              .collection('request')
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  Projectssnapshot) {
                                            if (Projectssnapshot.hasData) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: Projectssnapshot
                                                    .data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  String uid = context
                                                          .watch<dbManager>()
                                                          .currentobserverdoc[
                                                      'uid'];
                                                  String name = context
                                                          .watch<dbManager>()
                                                          .currentobserverdoc[
                                                      'uid'];
                                                  DocumentSnapshot
                                                      RequestSnapshot =
                                                      Projectssnapshot
                                                          .data!.docs[index];

                                                  return Card(

                                                      // child: Padding(
                                                      // padding: const EdgeInsets.all(8.0),
                                                      child: ListTile(
                                                    title: Text(RequestSnapshot[
                                                        'ProjectName']),
                                                    subtitle: Text(
                                                        RequestSnapshot[
                                                            'observername']),
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          child: IconButton(
                                                            onPressed: (() {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'observers')
                                                                  .doc(RequestSnapshot[
                                                                      'senderUid'])
                                                                  .collection(
                                                                      'projects')
                                                                  .doc(RequestSnapshot[
                                                                      'ProjectName'])
                                                                  .update({
                                                                "memberList":
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                  name
                                                                ])
                                                              });
                                                              // FirebaseFirestore.instance
                                                              //     .collection(
                                                              //         'observers')
                                                              //     .doc(RequestSnapshot[
                                                              //         'senderUid'])
                                                              //     .collection(
                                                              //         'projects')
                                                              //     .doc(RequestSnapshot[
                                                              //         'ProjectName'])
                                                              //     .update({
                                                              //   "memberList": FieldValue
                                                              //       .arrayUnion([name])
                                                              // });
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "observers")
                                                                  .doc(uid)
                                                                  .update({
                                                                "ProjectRequest":
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  RequestSnapshot[
                                                                      'ProjectName']
                                                                ])
                                                              });
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'observers')
                                                                  .doc(uid)
                                                                  .collection(
                                                                      'request')
                                                                  .doc(RequestSnapshot[
                                                                      'ProjectName'])
                                                                  .delete();
                                                            }),
                                                            icon: const Icon(
                                                              Icons
                                                                  .done_rounded,
                                                              color: Colors
                                                                  .lightGreen,
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: (() {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "observers")
                                                                .doc(uid)
                                                                .update({
                                                              "ProjectRequest":
                                                                  FieldValue
                                                                      .arrayRemove([
                                                                RequestSnapshot[
                                                                    'ProjectName']
                                                              ])
                                                            });
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'observers')
                                                                .doc(uid)
                                                                .collection(
                                                                    'request')
                                                                .doc(RequestSnapshot[
                                                                    'ProjectName'])
                                                                .delete();
                                                          }),
                                                          icon: const Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                                },
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          }),
                                    ],
                                  )),
                              actions: <Widget>[
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 0),
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ));
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.red,
                    // size: 32.0,
                  ))),
          Visibility(
            visible: 'Researcher' == context.watch<ManageRoute>().User,
            child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05),
                child: PopupMenuButton(
                  elevation: 20,
                  enabled: true,
                  // splashRadius: 20,
                  position: PopupMenuPosition.under,

                  onSelected: (value) {
                    RequestList();
                    if (value == "first") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          scrollable: true,
                          elevation: 20,
                          title: const Center(
                              child: Text("Project Notifications")),
                          contentPadding: EdgeInsets.zero,
                          content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width * 1,
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('observers')
                                      .doc(context
                                          .watch<dbManager>()
                                          .currentobserverdoc['uid'])
                                      .collection('request')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot>
                                          Projectssnapshot) {
                                    if (Projectssnapshot.hasData) {
                                      if (Projectssnapshot.data!.docs.length <
                                          1) {
                                        return const Center(
                                          child: Text("No Notification !"),
                                        );
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: Projectssnapshot
                                              .data!.docs.length,
                                          itemBuilder: (context, index) {
                                            String uid = context
                                                .watch<dbManager>()
                                                .currentobserverdoc['uid'];
                                            String name = context
                                                .watch<dbManager>()
                                                .currentobserverdoc['name'];
                                            DocumentSnapshot RequestSnapshot =
                                                Projectssnapshot
                                                    .data!.docs[index];

                                            return Card(

                                                // child: Padding(
                                                // padding: const EdgeInsets.all(8.0),
                                                child: ListTile(
                                              title: Text(
                                                  RequestSnapshot['message']),
                                              subtitle: Text(RequestSnapshot[
                                                  'observername']),
                                              trailing: SizedBox(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      onPressed: (() {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'observers')
                                                            .doc(RequestSnapshot[
                                                                'senderUid'])
                                                            .collection(
                                                                'projects')
                                                            .doc(RequestSnapshot[
                                                                'ProjectName'])
                                                            .update({
                                                          "memberList":
                                                              FieldValue
                                                                  .arrayUnion(
                                                                      [name])
                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "observers")
                                                            .doc(uid)
                                                            .update({
                                                          "ProjectRequest":
                                                              FieldValue
                                                                  .arrayRemove([
                                                            RequestSnapshot[
                                                                'ProjectName']
                                                          ])
                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'observers')
                                                            .doc(uid)
                                                            .collection(
                                                                'request')
                                                            .doc(RequestSnapshot[
                                                                'ProjectName'])
                                                            .delete();
                                                      }),
                                                      icon: const Icon(
                                                        Icons.done_rounded,
                                                        color:
                                                            Colors.lightGreen,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: (() {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "observers")
                                                            .doc(uid)
                                                            .update({
                                                          "ProjectRequest":
                                                              FieldValue
                                                                  .arrayRemove([
                                                            RequestSnapshot[
                                                                'ProjectName']
                                                          ])
                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'observers')
                                                            .doc(uid)
                                                            .collection(
                                                                'request')
                                                            .doc(RequestSnapshot[
                                                                'ProjectName'])
                                                            .delete();
                                                      }),
                                                      icon: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                          },
                                        );
                                      }
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  })),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, elevation: 0),
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    }
                    if (value == "Third") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                elevation: 20,
                                scrollable: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                title: const Center(
                                    child: Text('Informations Requests')),
                                contentPadding: EdgeInsets.zero,
                                content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    child: requestimages.length < 1
                                        ? const Center(
                                            child: Text("No Requests !"))
                                        : ListView.builder(
                                            itemCount: requestimages.length,
                                            itemBuilder: ((context, index) {
                                              return Card(
                                                child: ListTile(
                                                  title: const Text(
                                                      "I want more info on this ..."),
                                                  // subtitle: ,
                                                  onTap: (() {
                                                    Navigator.pop(context);
                                                    Get.to(const RequestOb(),
                                                        arguments:
                                                            requestimages[
                                                                index]);
                                                  }),
                                                ),
                                              );
                                            }))),
                                actions: <Widget>[
                                  TextButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        elevation: 0),
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ));
                    }
                    if (value == "Second") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                                scrollable: true,
                                title: const Center(
                                    child: Text('Observations Requests')),
                                elevation: 20,
                                contentPadding: EdgeInsets.zero,
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: ObservationRequest.length,
                                      itemBuilder: ((context, findex) {
                                        // List checkList = context
                                        //     .watch<dbManager>()
                                        //     .projectdoc['observationList'];
                                        return StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('observers')
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data!.docs.length <
                                                    1) {
                                                  return const Center(
                                                    child:
                                                        Text("No Requests !"),
                                                  );
                                                }
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: snapshot
                                                      .data!.docs.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    String id = snapshot
                                                        .data!.docs[index].id;
                                                    DocumentSnapshot
                                                        projectdata = snapshot
                                                            .data!.docs[index];
                                                    return StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'observers')
                                                            .doc(id)
                                                            .collection(
                                                                'observations')
                                                            .where('uid',
                                                                isEqualTo:
                                                                    ObservationRequest[
                                                                        findex])
                                                            .snapshots(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    QuerySnapshot>
                                                                Projectssnapshot) {
                                                          // print(
                                                          //     "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
                                                          // print(
                                                          //     ObservationRequest[
                                                          //         findex]);
                                                          if (Projectssnapshot
                                                              .hasData) {
                                                            return ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount: Projectssnapshot
                                                                        .data!
                                                                        .docs
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      DocumentSnapshot
                                                                          Subprojectdata =
                                                                          Projectssnapshot
                                                                              .data!
                                                                              .docs[index];
                                                                      String Projectid = Projectssnapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id;
                                                                      context
                                                                          .read<
                                                                              dbManager>()
                                                                          .ChangeObservationDoc(
                                                                              Subprojectdata);

                                                                      String
                                                                          obName =
                                                                          projectdata[
                                                                              'name'];
                                                                      return Card(
                                                                          clipBehavior: Clip
                                                                              .antiAlias,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(24),
                                                                          ), // RoundedRectangleBorder
                                                                          child:
                                                                              ListTile(
                                                                            onTap:
                                                                                () {
                                                                              Provider.of<dbManager>(context, listen: false).ChangeObserverDoc(projectdata);
                                                                              context.read<ManageRoute>().ChangeSepecies("Sepecies");
                                                                              FirebaseFirestore.instance.collection('observers').doc(id).collection('observations').doc(Projectid).get().then((DocumentSnapshot documentSnapshot) {
                                                                                Navigator.pop(context);
                                                                                Get.to(const RequestAuth(), arguments: documentSnapshot);
                                                                              });
                                                                            },
                                                                            title:
                                                                                Text(Subprojectdata['BotanicalName']),
                                                                            subtitle:
                                                                                Text(obName),
                                                                          ));
                                                                    });
                                                          } else {
                                                            return const Visibility(
                                                              visible: false,
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            );
                                                          }
                                                        });
                                                  },
                                                );
                                              } else {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            });
                                      })),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ));
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "first",
                      child: Text("Projects"),
                    ),
                    const PopupMenuItem(
                      value: "Second",
                      child: Text("Observations"),
                    ),
                    const PopupMenuItem(
                      value: "Third",
                      child: Text("Info Requests"),
                    ),
                  ],
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.red,
                    // size: 32.0,
                  ),
                )),
          )
        ],
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        bottom: TabBar(
          isScrollable: true,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          tabs: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.27,
                child: Column(
                  children: const [
                    Text(
                      'Observations',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Text('${observation.length}')
                  ],
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                child: Column(
                  children: const [
                    Text(
                      "Observer",
                      style: TextStyle(fontSize: 16),
                    ),
                    // Text((context.watch<ManageRoute>().observer.length)
                    //     .toString())
                  ],
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.18,
                child: Column(
                  children: const [
                    Text(
                      'Sepecies',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Text('${sepecies.length}')
                  ],
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.16,
                child: Column(
                  children: const [
                    Text(
                      'Projects',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Text('${context.watch<ManageRoute>().project.length}')
                  ],
                )),
          ],
        ),
      ),
      body: TabBarView(children: [
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('observers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length < 1) {
                  return const Center(
                    child: Text("No observations Available !"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String id = snapshot.data!.docs[index].id;
                    DocumentSnapshot projectdata = snapshot.data!.docs[index];
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('observers')
                            .doc(id)
                            .collection('observations')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> Projectssnapshot) {
                          if (Projectssnapshot.hasData) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Projectssnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot Subprojectdata =
                                      Projectssnapshot.data!.docs[index];
                                  String Projectid =
                                      Projectssnapshot.data!.docs[index].id;
                                  context
                                      .read<dbManager>()
                                      .ChangeObservationDoc(Subprojectdata);
                                  String obName = projectdata['name'];
                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<ManageRoute>()
                                          .ChangeSepecies("Sepecies");
                                      FirebaseFirestore.instance
                                          .collection('observers')
                                          .doc(id)
                                          .collection('observations')
                                          .doc(Projectid)
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        Get.to(const Sepecies(),
                                            arguments: documentSnapshot);
                                        context
                                            .read<dbManager>()
                                            .ChangeObserverDoc(projectdata);
                                      });
                                    },
                                    child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ), // RoundedRectangleBorder
                                        child: Column(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.network(
                                                      Subprojectdata['image1'],
                                                      frameBuilder: (_, image,
                                                          loadingBuilder, __) {
                                                        if (loadingBuilder ==
                                                            null) {
                                                          return const SizedBox(
                                                            height: 300,
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          );
                                                        }
                                                        return image;
                                                      },
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget image,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return image;
                                                        return SizedBox(
                                                          height: 300,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              Image.asset(
                                                        'assets\Image\splash.png',
                                                        height: 300,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ).image,
                                                    fit: BoxFit.cover)),
                                            height: 100,
                                            width: 400,
                                            child: Visibility(
                                              visible:
                                                  Subprojectdata['status'] ==
                                                      "approved",
                                              replacement: Visibility(
                                                visible:
                                                    Subprojectdata['status'] ==
                                                        "declined",
                                                replacement: Visibility(
                                                  visible: Subprojectdata[
                                                          'status'] ==
                                                      "pending",
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 7, top: 7),
                                                      child: Container(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          // padding: const EdgeInsets.all(8.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                203,
                                                                185,
                                                                21),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 7, top: 7),
                                                    child: Container(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        // padding: const EdgeInsets.all(8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7, top: 7),
                                                  child: Container(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      // padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green,
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
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
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                context
                                                        .watch<dbManager>()
                                                        .observationdoc[
                                                    'BotanicalName'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff050505),
                                                  fontSize: 18,
                                                ), // TextStyle
                                              ),
                                            ),
                                          ),

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 10),
                                              child: Text(
                                                obName,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 10),
                                              child: Text(
                                                Subprojectdata['location'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          // Visibility(
                                          //   visible: projectdata['uid'] ==
                                          //       context
                                          //           .watch<dbManager>()
                                          //           .currentobserverdoc['uid'],
                                          //   child: Align(
                                          //     alignment: Alignment.bottomLeft,
                                          //     child: IconButton(
                                          //         onPressed: (() {
                                          //           FirebaseFirestore.instance
                                          //               .collection('observers')
                                          //               .doc(context
                                          //                       .watch<dbManager>()
                                          //                       .currentobserverdoc[
                                          //                   'uid'])
                                          //               .collection(
                                          //                   'observations')
                                          //               .doc(Projectid)
                                          //               .delete();
                                          //           FirebaseStorage.instance
                                          //               .ref()
                                          //               .child(
                                          //                   '/observations/$id/$id+"1" ')
                                          //               .delete();
                                          //           FirebaseStorage.instance
                                          //               .ref()
                                          //               .child(
                                          //                   '/observations/$id/$id+"2" ')
                                          //               .delete();
                                          //           FirebaseStorage.instance
                                          //               .ref()
                                          //               .child(
                                          //                   '/observations/$id/$id+"3" ')
                                          //               .delete();
                                          //         }),
                                          //         icon: const Icon(
                                          //             Icons.delete_sharp)),
                                          //   ),
                                          // )
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
                          return const Visibility(
                              visible: false, child: LinearProgressIndicator());
                        });
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        Visibility(
          visible: 'Observer' == context.watch<ManageRoute>().User ||
              'Researcher' == context.watch<ManageRoute>().User,
          replacement: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('observers')
                  .orderBy('noObservation', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot projectdata =
                            snapshot.data!.docs[index];
                        List<String> items = <String>[
                          'Observer',
                          'Researcher',
                          'Admin'
                        ];
                        String dropdownvalue = projectdata['role'];

                        return Card(
                          child: ListTile(
                            leading: const Image(
                              width: 50,
                              image: AssetImage('assets/Image/splash.png'),
                            ),
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    projectdata['name'],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "Rank: ${index + 1}",
                                    style: const TextStyle(fontSize: 12),
                                  )
                                ]),
                            trailing: DropdownButton(
                              value: dropdownvalue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                FirebaseFirestore.instance
                                    .collection('observers')
                                    .doc(projectdata['uid'])
                                    .update({'role': newValue});
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                            onTap: () {
                              context
                                  .read<ManageRoute>()
                                  .ChangeProfile('ObserverAcc');
                              context
                                  .read<dbManager>()
                                  .ChangeObserverDoc(projectdata);

                              Get.to(const OtherAccount());
                            },
                          ),
                        );
                      });
                }
              }),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('observers')
                  .orderBy('noObservation', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot projectdata = snapshot.data!.docs[index];

                      return Card(
                        child: ListTile(
                          leading: const Image(
                            width: 50,
                            image: AssetImage('assets/Image/splash.png'),
                          ), // Ink.image

                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  projectdata['name'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "Rank: ${index + 1}",
                                  style: const TextStyle(fontSize: 12),
                                )
                              ]),

                          trailing: Text(
                            projectdata['noObservation'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          onTap: () {
                            context
                                .read<ManageRoute>()
                                .ChangeProfile('ObserverAcc');
                            context
                                .read<dbManager>()
                                .ChangeObserverDoc(projectdata);

                            Get.to(const OtherAccount());
                          },
                        ),
                      );
                    },
                  );
                }
              }),
        ),
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('observers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length < 1) {
                  return const Center(
                    child: Text("No Chats Available !"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String id = snapshot.data!.docs[index].id;
                    DocumentSnapshot projectdata = snapshot.data!.docs[index];
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('observers')
                            .doc(id)
                            .collection('observations')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> Projectssnapshot) {
                          if (Projectssnapshot.hasData) {
                            return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: Projectssnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot Subprojectdata =
                                      Projectssnapshot.data!.docs[index];
                                  String Projectid =
                                      Projectssnapshot.data!.docs[index].id;
                                  context
                                      .read<dbManager>()
                                      .ChangeObservationDoc(Subprojectdata);
                                  String obName = projectdata['name'];
                                  return GestureDetector(
                                    onTap: () {
                                      context
                                          .read<ManageRoute>()
                                          .ChangeSepecies("Sepecies");
                                      FirebaseFirestore.instance
                                          .collection('observers')
                                          .doc(id)
                                          .collection('observations')
                                          .doc(Projectid)
                                          .get()
                                          .then((DocumentSnapshot
                                              documentSnapshot) {
                                        Get.to(const Sepecies(),
                                            arguments: documentSnapshot);
                                        context
                                            .read<dbManager>()
                                            .ChangeObserverDoc(projectdata);
                                      });
                                    },
                                    child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ), // RoundedRectangleBorder
                                        child: Column(children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.network(
                                                      Subprojectdata['image1'],
                                                      frameBuilder: (_, image,
                                                          loadingBuilder, __) {
                                                        if (loadingBuilder ==
                                                            null) {
                                                          return const SizedBox(
                                                            height: 300,
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          );
                                                        }
                                                        return image;
                                                      },
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget image,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return image;
                                                        return SizedBox(
                                                          height: 300,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              value: loadingProgress
                                                                          .expectedTotalBytes !=
                                                                      null
                                                                  ? loadingProgress
                                                                          .cumulativeBytesLoaded /
                                                                      loadingProgress
                                                                          .expectedTotalBytes!
                                                                  : null,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder:
                                                          (_, __, ___) =>
                                                              Image.asset(
                                                        'assets\Image\splash.png',
                                                        height: 300,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    ).image,
                                                    fit: BoxFit.cover)),
                                            height: 100,
                                            width: 400,
                                            child: Visibility(
                                              visible:
                                                  Subprojectdata['status'] ==
                                                      "approved",
                                              replacement: Visibility(
                                                visible:
                                                    Subprojectdata['status'] ==
                                                        "declined",
                                                replacement: Visibility(
                                                  visible: Subprojectdata[
                                                          'status'] ==
                                                      "pending",
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 7, top: 7),
                                                      child: Container(
                                                          width: 20.0,
                                                          height: 20.0,
                                                          // padding: const EdgeInsets.all(8.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                203,
                                                                185,
                                                                21),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 7, top: 7),
                                                    child: Container(
                                                        width: 20.0,
                                                        height: 20.0,
                                                        // padding: const EdgeInsets.all(8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                  ),
                                                ),
                                              ),
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 7, top: 7),
                                                  child: Container(
                                                      width: 20.0,
                                                      height: 20.0,
                                                      // padding: const EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green,
                                                        border: Border.all(
                                                            color:
                                                                Colors.black),
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
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                context
                                                        .watch<dbManager>()
                                                        .observationdoc[
                                                    'BotanicalName'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff050505),
                                                  fontSize: 18,
                                                ), // TextStyle
                                              ),
                                            ),
                                          ),

                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 10),
                                              child: Text(
                                                obName,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 10),
                                              child: Text(
                                                Subprojectdata['location'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          // Visibility(
                                          //   visible: projectdata['uid'] ==
                                          //       context
                                          //           .watch<dbManager>()
                                          //           .currentobserverdoc['uid'],
                                          //   child: Align(
                                          //     alignment: Alignment.bottomLeft,
                                          //     child: IconButton(
                                          //         onPressed: (() {
                                          //           FirebaseFirestore.instance
                                          //               .collection('observers')
                                          //               .doc(context
                                          //                       .watch<dbManager>()
                                          //                       .currentobserverdoc[
                                          //                   'uid'])
                                          //               .collection(
                                          //                   'observations')
                                          //               .doc(Projectid)
                                          //               .delete();
                                          //           FirebaseStorage.instance
                                          //               .ref()
                                          //               .child(
                                          //                   '/observations/$id/$id+"1" ')
                                          //               .delete();
                                          //           FirebaseStorage.instance
                                          //               .ref()
                                          //               .child(
                                          //                   '/observations/$id/$id+"2" ')
                                          //               .delete();
                                          //           FirebaseStorage.instance
                                          //               .ref()
                                          //               .child(
                                          //                   '/observations/$id/$id+"3" ')
                                          //               .delete();
                                          //         }),
                                          //         icon: const Icon(
                                          //             Icons.delete_sharp)),
                                          //   ),
                                          // )
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
                          return const Visibility(
                              visible: false, child: LinearProgressIndicator());
                        });
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('observers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length < 1) {
                  return const Center(
                    child: Text("No Projects Available !"),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot projectdata = snapshot.data!.docs[index];
                    String id = snapshot.data!.docs[index].id;
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('observers')
                            .doc(id)
                            .collection('projects')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> Projectssnapshot) {
                          if (Projectssnapshot.hasData) {
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Projectssnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot Subprojectdata =
                                    Projectssnapshot.data!.docs[index];

                                String Projectid =
                                    Projectssnapshot.data!.docs[index].id;
                                return Card(
                                  child: ListTile(
                                    onTap: (() {
                                      context
                                          .read<dbManager>()
                                          .ChangeObserverDoc(projectdata);
                                      context
                                          .read<dbManager>()
                                          .ChangeProjectDoc(Subprojectdata);
                                      Get.to(const Project(),
                                          arguments: Projectid);
                                    }),
                                    // leading: Text(book[index].rank.toString()),
                                    title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Subprojectdata['ProjectName'],
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ]),
                                    trailing: Text(
                                        "Members: ${Subprojectdata['memberList'].length}"),
                                  ),
                                );
                              },
                            );
                          }
                          return const Visibility(
                              visible: false, child: LinearProgressIndicator());
                        });
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
      ]),
    );
  }
}
