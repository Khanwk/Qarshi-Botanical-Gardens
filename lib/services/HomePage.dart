import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/CreateProject.dart';
import 'package:qarshi_app/Observer/chat.dart';
import 'package:qarshi_app/accounts/otherAccount.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:get/get.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qarshi_app/services/dbManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// final productProvider = Provider.of<CRUDModel>(context);

class _HomePageState extends State<HomePage> {
  late DocumentSnapshot obdata;
  bool request = true;
  FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) => getObserverList());
  //   WidgetsBinding.instance.addPostFrameCallback((_) => getProjectList());
  // }

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
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Messages'),
                        contentPadding: EdgeInsets.zero,
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          width: MediaQuery.of(context).size.width * 1,
                          child: ListView.builder(
                            // shrinkWrap: true,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Card(

                                  // child: Padding(
                                  // padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                onTap: (() {
                                  context
                                      .read<ManageRoute>()
                                      .ChangeMessage('CreateMessage');
                                  Navigator.pop(context, 'OK');
                                  Get.to(const ChatPage());
                                }),
                                title: Text('Message $index'),
                                subtitle: const Text('Observer'),
                              ));
                            },
                          ),
                        ),
                        actions: const <Widget>[
                          // TextButton(
                          //   onPressed: () => Navigator.pop(context, 'OK'),
                          //   child:
                          Text('OK'),
                          // ),
                        ],
                      ));
            },
            icon: const Icon(Icons.message_sharp),
            color: Colors.red,
          ),
          Visibility(
              visible: 'Observer' == context.watch<ManageRoute>().User,
              child: IconButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text("Requests"),
                            contentPadding: EdgeInsets.zero,
                            content: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width * 1,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('observers')
                                        .doc(context
                                            .watch<dbManager>()
                                            .currentobserverdoc!['uid'])
                                        .collection('request')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            Projectssnapshot) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            Projectssnapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          String uid = context
                                              .watch<dbManager>()
                                              .currentobserverdoc!['uid'];
                                          String name = context
                                              .watch<dbManager>()
                                              .currentobserverdoc!['name'];
                                          DocumentSnapshot RequestSnapshot =
                                              Projectssnapshot
                                                  .data!.docs[index];

                                          String Projectid = Projectssnapshot
                                              .data!.docs[index].id;
                                          return Card(

                                              // child: Padding(
                                              // padding: const EdgeInsets.all(8.0),
                                              child: ListTile(
                                            title: Text(
                                                RequestSnapshot['ProjectName']),
                                            subtitle: Text(RequestSnapshot[
                                                'observername']),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: IconButton(
                                                    onPressed: (() {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'observers')
                                                          .doc(RequestSnapshot[
                                                              'senderUid'])
                                                          .collection(
                                                              'projects')
                                                          .doc(RequestSnapshot[
                                                              'ProjectName'])
                                                          .update({
                                                        "memberList": FieldValue
                                                            .arrayUnion([name])
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
                                                      FirebaseFirestore.instance
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
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'observers')
                                                          .doc(uid)
                                                          .collection('request')
                                                          .doc(RequestSnapshot[
                                                              'ProjectName'])
                                                          .delete();
                                                    }),
                                                    icon: Icon(
                                                      Icons.done_rounded,
                                                      color: Colors.lightGreen,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: (() {
                                                    FirebaseFirestore.instance
                                                        .collection("observers")
                                                        .doc(uid)
                                                        .update({
                                                      "ProjectRequest":
                                                          FieldValue
                                                              .arrayRemove([
                                                        RequestSnapshot[
                                                            'ProjectName']
                                                      ])
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection('observers')
                                                        .doc(uid)
                                                        .collection('request')
                                                        .doc(RequestSnapshot[
                                                            'ProjectName'])
                                                        .delete();
                                                  }),
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                        },
                                      );
                                    })),
                            actions: const <Widget>[
                              // TextButton(
                              //   onPressed: () => Navigator.pop(context, 'OK'),
                              //   child:
                              Text('OK'),
                              // ),
                            ],
                          )),
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.red,
                    size: 32.0,
                  ))),
          Visibility(
            visible: 'Researcher' == context.watch<ManageRoute>().User,
            child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05),
                child: PopupMenuButton(
                  elevation: 20,
                  enabled: true,
                  onSelected: (value) {
                    if (value == "first") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width * 1,
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('observers')
                                      .doc(context
                                          .watch<dbManager>()
                                          .currentobserverdoc!['uid'])
                                      .collection('request')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot>
                                          Projectssnapshot) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          Projectssnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        String uid = context
                                            .watch<dbManager>()
                                            .currentobserverdoc!['uid'];
                                        String name = context
                                            .watch<dbManager>()
                                            .currentobserverdoc!['name'];
                                        DocumentSnapshot RequestSnapshot =
                                            Projectssnapshot.data!.docs[index];

                                        String Projectid = Projectssnapshot
                                            .data!.docs[index].id;
                                        return Card(

                                            // child: Padding(
                                            // padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                          title: Text(
                                              RequestSnapshot['ProjectName']),
                                          subtitle: Text(
                                              RequestSnapshot['senderUid']),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 5),
                                                child: IconButton(
                                                  onPressed: (() {
                                                    FirebaseFirestore.instance
                                                        .collection('observers')
                                                        .doc(RequestSnapshot[
                                                            'senderUid'])
                                                        .collection('projects')
                                                        .doc(RequestSnapshot[
                                                            'ProjectName'])
                                                        .update({
                                                      "memberList":
                                                          FieldValue.arrayUnion(
                                                              [name])
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection("observers")
                                                        .doc(uid)
                                                        .update({
                                                      "ProjectRequest":
                                                          FieldValue
                                                              .arrayRemove([
                                                        RequestSnapshot[
                                                            'ProjectName']
                                                      ])
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection('observers')
                                                        .doc(uid)
                                                        .collection('request')
                                                        .doc(RequestSnapshot[
                                                            'ProjectName'])
                                                        .delete();
                                                  }),
                                                  icon: Icon(
                                                    Icons.done_rounded,
                                                    color: Colors.lightGreen,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: (() {
                                                  FirebaseFirestore.instance
                                                      .collection("observers")
                                                      .doc(uid)
                                                      .update({
                                                    "ProjectRequest":
                                                        FieldValue.arrayRemove([
                                                      RequestSnapshot[
                                                          'ProjectName']
                                                    ])
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection('observers')
                                                      .doc(uid)
                                                      .collection('request')
                                                      .doc(RequestSnapshot[
                                                          'ProjectName'])
                                                      .delete();
                                                }),
                                                icon: Icon(
                                                  Icons.cancel,
                                                  color: Colors.red,
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                      },
                                    );
                                  })),
                          actions: const <Widget>[
                            // TextButton(
                            //   onPressed: () => Navigator.pop(context, 'OK'),
                            //   child:
                            Text('OK'),
                            // ),
                          ],
                        ),
                      );
                    }
                    if (value == "Second") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Center(
                                      child: Text("No Observation requests !")),
                                ),
                                actions: const <Widget>[
                                  // TextButton(
                                  //   onPressed: () => Navigator.pop(context, 'OK'),
                                  //   child:
                                  Text('OK'),
                                  // ),
                                ],
                              ));
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Project"),
                      value: "first",
                    ),
                    PopupMenuItem(
                      child: Text("Observation"),
                      value: "Second",
                    ),
                  ],
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.red,
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
                width: MediaQuery.of(context).size.width * 0.3,
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
                width: MediaQuery.of(context).size.width * 0.3,
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
                width: MediaQuery.of(context).size.width * 0.3,
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
                width: MediaQuery.of(context).size.width * 0.3,
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
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
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
                            .orderBy("Date", descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> Projectssnapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
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
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: ExactAssetImage(
                                                      'assets/Image/splash.png',
                                                    ),
                                                    fit: BoxFit.cover)),
                                            height: 100,
                                            width: 400,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 7, top: 7),
                                                child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    // padding: const EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green,
                                                      border: Border.all(
                                                          color: Colors.black),
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
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                context
                                                        .watch<dbManager>()
                                                        .observationdoc![
                                                    'BotanicalName'],
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
                .orderBy('noObservation', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
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
        StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('observers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
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
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
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
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: ExactAssetImage(
                                                      'assets/Image/splash.png',
                                                    ),
                                                    fit: BoxFit.cover)),
                                            height: 100,
                                            width: 400,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 7, top: 7),
                                                child: Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    // padding: const EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green,
                                                      border: Border.all(
                                                          color: Colors.black),
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
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                context
                                                        .watch<dbManager>()
                                                        .observationdoc![
                                                    'BotanicalName'],
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
            stream:
                FirebaseFirestore.instance.collection('observers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    String id = snapshot.data!.docs[index].id;
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('observers')
                            .doc(id)
                            .collection('projects')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> Projectssnapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
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
                                          .ChangeProjectDoc(Subprojectdata);
                                      Get.to(const Project(),
                                          arguments:
                                              Subprojectdata['ProjectName']);
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
                                          const Text(
                                            "Members:",
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ]),
                                    trailing: const Text("7"),
                                  ),
                                );
                              },
                            );
                          }
                        });
                  },
                );
              }
            })
      ]),
    );
  }

  // Future getProjectList() async {
  //   Map<String, dynamic> data = {};
  //   await FirebaseFirestore.instance
  //       .collection('observers')
  //       .doc()
  //       .collection('projects')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       setState(() {
  //         data = doc.data() as Map<String, dynamic>;
  //         project.add(data['ProjectName']);
  //         context.read<ManageRoute>().ProjectList(project);

  //         // noObservations.add(data['noObservation']);
  //         // context.read<ManageRoute>().NoObservationLIst(noObservations);
  //       });
  //     }
  //     setState(() {
  //       project = [];
  //     });
  //   });
  // }
}
