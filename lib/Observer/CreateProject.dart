import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/ProjectAdd.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:qarshi_app/Observer/chat.dart';
import 'package:qarshi_app/services/dbManager.dart';

import '../services/RouteManager.dart';

class Project extends StatefulWidget {
  const Project({Key? key}) : super(key: key);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  String Projid = Get.arguments;

  DocumentSnapshot? obList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Project'),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: [
            Visibility(
              visible: context
                      .watch<dbManager>()
                      .projectdoc['memberList']
                      .contains(context
                          .watch<dbManager>()
                          .currentobserverdoc['uid']) &&
                  context.watch<dbManager>().projectdoc['admin'] !=
                      context.watch<dbManager>().currentobserverdoc['uid'],
              child: PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  icon: const Icon(Icons.add),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Observation"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      Get.to(ProjectAdd(), arguments: [Projid, 'observation']);
                      // Get.to(const ChatPage());
                    } else if (value == 1) {
                      Get.to(const ProjectAdd(), arguments: [Projid, 'member']);
                    }
                  }),
            ),
            Visibility(
              visible: context.watch<dbManager>().projectdoc['admin'] ==
                  context.watch<dbManager>().currentobserverdoc['uid'],
              child: PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  icon: const Icon(Icons.add),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 0,
                        child: Text("Observation"),
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("Member"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      Get.to(ProjectAdd(), arguments: [Projid, 'observation']);
                      // Get.to(const ChatPage());
                    } else if (value == 1) {
                      Get.to(const ProjectAdd(), arguments: [Projid, 'member']);
                    }
                  }),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(children: [
                    const TabBar(
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.red,
                      tabs: [
                        Tab(child: Text("Observations")),
                        Tab(child: Text("Members"))
                      ],
                    ),
                    Expanded(
                      child: TabBarView(children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: context
                                  .watch<dbManager>()
                                  .projectdoc['observationList']
                                  .length,
                              itemBuilder: ((context, findex) {
                                // List checkList = context
                                //     .watch<dbManager>()
                                //     .projectdoc['observationList'];
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('observers')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      print(
                                          "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
                                      print(findex);
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
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
                                                    .collection('observations')
                                                    .where('uid',
                                                        isEqualTo: context
                                                                    .watch<dbManager>()
                                                                    .projectdoc[
                                                                'observationList']
                                                            [findex])
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        Projectssnapshot) {
                                                  if (!Projectssnapshot
                                                      .hasData) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
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
                                                          context
                                                              .read<dbManager>()
                                                              .ChangeObservationDoc(
                                                                  Subprojectdata);
                                                          String obName =
                                                              projectdata[
                                                                  'name'];
                                                          return Card(
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            24),
                                                              ), // RoundedRectangleBorder
                                                              child: Column(
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          image: DecorationImage(
                                                                              image: Image.network(context.watch<dbManager>().observationdoc['image1']).image,
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
                                                                          padding: const EdgeInsets.only(
                                                                              right: 7,
                                                                              top: 7),
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
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          // context
                                                                          //     .watch<dbManager>()
                                                                          //     .projectdoc['observationList']
                                                                          //     .length
                                                                          //     .toString(),
                                                                          context
                                                                              .watch<dbManager>()
                                                                              .observationdoc['BotanicalName'],
                                                                          style:
                                                                              const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Color(0xff050505),
                                                                            fontSize:
                                                                                18,
                                                                          ), // TextStyle
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          obName,
                                                                          style:
                                                                              const TextStyle(fontSize: 16),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                5,
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Text(
                                                                          Subprojectdata[
                                                                              'location'],
                                                                          style:
                                                                              const TextStyle(fontSize: 16),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Visibility(
                                                                      visible: projectdata[
                                                                              'uid'] ==
                                                                          context
                                                                              .watch<dbManager>()
                                                                              .currentobserverdoc['uid'],
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.bottomRight,
                                                                        child: IconButton(
                                                                            onPressed: (() => FirebaseFirestore.instance.collection('observers').doc(Provider.of<dbManager>(context, listen: false).projectdoc['admin']).collection("projects").doc(Projid).update({
                                                                                  "observationList": FieldValue.arrayRemove([
                                                                                    Projectid
                                                                                  ])
                                                                                })),
                                                                            icon: Icon(Icons.delete_sharp)),
                                                                      ),
                                                                    )
                                                                    // Padding(
                                                                    //   padding: const EdgeInsets.only(right: 281, top: 5),
                                                                    //   child: Text(
                                                                    //     '  Date ',
                                                                    //     style: TextStyle(fontSize: 16),
                                                                    //   ),
                                                                    // ),
                                                                    //
                                                                    // Text
                                                                  ]));
                                                        });
                                                  }
                                                });
                                          },
                                        );
                                      }
                                    });
                              })),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: context
                                  .watch<dbManager>()
                                  .projectdoc['memberList']
                                  .length,
                              itemBuilder: ((context, findex) {
                                List checkList = context
                                    .watch<dbManager>()
                                    .projectdoc['memberList'];

                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('observers')
                                        .where('uid',
                                            isEqualTo: checkList[findex])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot projectdata =
                                                snapshot.data!.docs[index];
                                            return Card(
                                              child: ListTile(
                                                  leading: const Image(
                                                    width: 50,
                                                    image: AssetImage(
                                                        'assets/Image/splash.png'),
                                                  ), // Ink.image

                                                  title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          projectdata['name'],
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18),
                                                        ),
                                                        Text(
                                                          "Rank: ${index + 1}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        )
                                                      ]),
                                                  trailing: Visibility(
                                                    visible: context
                                                                    .watch<
                                                                        dbManager>()
                                                                    .projectdoc[
                                                                'admin'] !=
                                                            projectdata[
                                                                'uid'] &&
                                                        context
                                                                    .watch<
                                                                        dbManager>()
                                                                    .projectdoc[
                                                                'admin'] ==
                                                            context
                                                                .watch<
                                                                    dbManager>()
                                                                .currentobserverdoc['uid'],
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons.person_remove),
                                                      onPressed: (() =>
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'observers')
                                                              .doc(Provider.of<
                                                                          dbManager>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .projectdoc['admin'])
                                                              .collection("projects")
                                                              .doc(Projid)
                                                              .update({
                                                            "memberList":
                                                                FieldValue
                                                                    .arrayRemove([
                                                              projectdata['uid']
                                                            ])
                                                          })),
                                                    ),
                                                  )),
                                            );
                                          },
                                        );
                                      }
                                    });
                              })),
                        ),
                      ]),
                    )
                  ])),
            ),
          ],
        ));
  }
}
