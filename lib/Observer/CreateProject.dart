// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/ProjectAdd.dart';
import 'package:qarshi_app/services/dbManager.dart';

class Project extends StatefulWidget {
  const Project({Key? key}) : super(key: key);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  String Projid = Get.arguments;
  List observationlist = [];
  List memberlist = [];
  // String id = "";
  RequestList() async {
    var collection = FirebaseFirestore.instance
        .collection('observers')
        .doc(Provider.of<dbManager>(context, listen: false).observerdoc['uid'])
        .collection('projects');
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
      // setState(() {
      //   id = queryDocumentSnapshot.id;
      // });
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if (queryDocumentSnapshot.id == Projid) {
        setState(() {
          observationlist = data['observationList'];
          memberlist = data['memberList'];
          // print(
          //     "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL:${observationlist},${memberlist}");
        });
      }

      // var phone = data['phone'];
    }
  }

  @override
  void initState() {
    RequestList();
    super.initState();
  }

  bool willpop() {
    observationlist = [];
    memberlist = [];
    return true;
  }

  DocumentSnapshot? obList;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return willpop();
      },
      child: Scaffold(
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
                        Get.to(const ProjectAdd(),
                            arguments: [Projid, 'observation']);
                        // Get.to(const ChatPage());
                      } else if (value == 1) {
                        Get.to(const ProjectAdd(),
                            arguments: [Projid, 'member']);
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
                        Get.to(const ProjectAdd(),
                            arguments: [Projid, 'observation']);
                        // Get.to(const ChatPage());
                      } else if (value == 1) {
                        Get.to(const ProjectAdd(),
                            arguments: [Projid, 'member']);
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
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: observationlist.isEmpty
                                ? const Center(
                                    child: Text("No Observations yet"),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: observationlist.length,
                                    itemBuilder: ((context, findex) {
                                      // print(
                                      //     "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL:${observationlist}");
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
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  String id = snapshot
                                                      .data!.docs[index].id;

                                                  DocumentSnapshot projectdata =
                                                      snapshot
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
                                                                  observationlist[
                                                                      findex])
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              Projectssnapshot) {
                                                        if (Projectssnapshot
                                                            .hasData) {
                                                          return ListView
                                                              .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount:
                                                                      Projectssnapshot
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
                                                                    String
                                                                        Projectid =
                                                                        Projectssnapshot
                                                                            .data!
                                                                            .docs[index]
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
                                                                        clipBehavior:
                                                                            Clip
                                                                                .antiAlias,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(24),
                                                                        ), // RoundedRectangleBorder
                                                                        child: Column(
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(image: DecorationImage(image: Image.network(context.watch<dbManager>().observationdoc['image1']).image, fit: BoxFit.cover)),
                                                                                height: 100,
                                                                                width: 400,
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
                                                                                          color: Colors.green,
                                                                                          border: Border.all(color: Colors.black),
                                                                                        )),
                                                                                  ),
                                                                                ),
                                                                              ), // Ink.image
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(left: 10),
                                                                                child: Align(
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    // context
                                                                                    //     .watch<dbManager>()
                                                                                    //     .projectdoc['observationList']
                                                                                    //     .length
                                                                                    //     .toString(),
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
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 5, left: 10),
                                                                                  child: Text(
                                                                                    obName,
                                                                                    style: const TextStyle(fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(top: 5, left: 10),
                                                                                  child: Text(
                                                                                    Subprojectdata['location'],
                                                                                    style: const TextStyle(fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Visibility(
                                                                                visible: projectdata['uid'] == context.watch<dbManager>().currentobserverdoc['uid'],
                                                                                child: Align(
                                                                                  alignment: Alignment.bottomRight,
                                                                                  child: IconButton(
                                                                                      onPressed: (() {
                                                                                        FirebaseFirestore.instance.collection('observers').doc(Provider.of<dbManager>(context, listen: false).projectdoc['admin']).collection("projects").doc(Projid).update({
                                                                                          "observationList": FieldValue.arrayRemove([Projectid])
                                                                                        });
                                                                                        RequestList();
                                                                                      }),
                                                                                      icon: const Icon(Icons.delete_sharp)),
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
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: memberlist.length,
                                itemBuilder: ((context, findex) {
                                  // List checkList = context
                                  //     .watch<dbManager>()
                                  //     .projectdoc['memberList'];

                                  return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('observers')
                                          .where('uid',
                                              isEqualTo: memberlist[findex])
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
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot projectdata =
                                                  snapshot.data!.docs[index];
                                              return Card(
                                                child: ListTile(
                                                    leading: Image(
                                                        width: 50,
                                                        image: Image.network(
                                                                projectdata[
                                                                    'image'])
                                                            .image), // Ink.image

                                                    title: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            projectdata['name'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          Text(
                                                            "observations: ${projectdata['noObservation']}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
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
                                                      replacement: Visibility(
                                                        visible: projectdata[
                                                                    'uid'] ==
                                                                context
                                                                        .watch<
                                                                            dbManager>()
                                                                        .currentobserverdoc[
                                                                    'uid'] &&
                                                            context
                                                                        .watch<
                                                                            dbManager>()
                                                                        .projectdoc[
                                                                    'admin'] !=
                                                                context
                                                                    .watch<
                                                                        dbManager>()
                                                                    .currentobserverdoc['uid'],
                                                        child: IconButton(
                                                          icon: const Icon(Icons
                                                              .logout_outlined),
                                                          onPressed: (() {
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
                                                                projectdata[
                                                                    'uid']
                                                              ])
                                                            });
                                                            RequestList();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Left this project !',
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
                                                                    Colors
                                                                        .white,
                                                                fontSize: 13.0);
                                                          }),
                                                        ),
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(Icons
                                                            .person_remove),
                                                        onPressed: (() {
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
                                                          });
                                                          RequestList();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'User Removed from Project !',
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
                                                        }),
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
          )),
    );
  }
}
