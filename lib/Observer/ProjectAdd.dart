import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/services/dbManager.dart';

class ProjectAdd extends StatefulWidget {
  const ProjectAdd({Key? key}) : super(key: key);

  @override
  State<ProjectAdd> createState() => _ProjectAddState();
}

class _ProjectAddState extends State<ProjectAdd> {
  final TextEditingController _SearchQuerry = TextEditingController();
  List valid = Get.arguments;
  bool show = false;
  String querry = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Visibility(
          visible: valid[1] == 'member',
          child: TextField(
            controller: _SearchQuerry,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(width: 0.8)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                        width: 0.8, color: Theme.of(context).primaryColor)),
                hintText: "Search Observer",
                prefixIcon: const Icon(
                  Icons.search,
                  size: 30,
                ),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _SearchQuerry.clear();
                      setState(() {
                        show = false;
                      });
                    })),
          ),
          replacement: Text("Add Observation"),
        ),
        actions: [
          Visibility(
            visible: valid[1] == 'member',
            child: IconButton(
                onPressed: () {
                  setState(() {
                    show = true;
                  });
                },
                icon: const Icon(
                  Icons.search,
                )),
          )
        ],
      ),
      body: Visibility(
        visible: valid[1] == 'member',
        child: Visibility(
          visible: show,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('observers')
                  .snapshots()
                  .asBroadcastStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: [
                      ...snapshot.data!.docs
                          .where(
                        (QueryDocumentSnapshot<Object?> element) =>
                            element['name']
                                .toString()
                                .toLowerCase()
                                .contains(_SearchQuerry.text.toLowerCase()),
                      )
                          .map((QueryDocumentSnapshot data) {
                        String name = data['name'];
                        String uid = data['uid'];
                        List RequestList = data['ProjectRequest'];
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
                                      name,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    // Text(
                                    //   "Rank: ${index + 1}",
                                    //   style: const TextStyle(fontSize: 12),
                                    // )
                                  ]),
                              trailing: Visibility(
                                visible: !RequestList.contains(valid[0]),
                                child: IconButton(
                                  icon: Icon(Icons.person_add),
                                  onPressed: (() {
                                    // List l = valid[0];
                                    FirebaseFirestore.instance
                                        .collection("observers")
                                        .doc(uid)
                                        .update({
                                      "ProjectRequest":
                                          FieldValue.arrayUnion([valid[0]])
                                    });
                                    FirebaseFirestore.instance
                                        .collection('observers')
                                        .doc(uid)
                                        .collection('request')
                                        .doc(valid[0])
                                        .set({
                                      'message':
                                          "I would like you to join me on this project",
                                      "request": "",
                                      "ProjectName": valid[0].toString(),
                                      "observername": name
                                    });
                                  }),
                                ),
                                replacement: IconButton(
                                  icon: Icon(Icons.person_remove_alt_1),
                                  onPressed: (() {
                                    FirebaseFirestore.instance
                                        .collection("observers")
                                        .doc(uid)
                                        .update({
                                      "ProjectRequest":
                                          FieldValue.arrayRemove([valid[0]])
                                    });
                                    FirebaseFirestore.instance
                                        .collection('observers')
                                        .doc(uid)
                                        .collection('request')
                                        .doc(valid[0])
                                        .delete();
                                  }),
                                ),
                              )),
                        );
                      }),
                    ],
                  );
                  // return ListView.builder(
                  //   itemCount: snapshot.data!.docs.length,
                  //   itemBuilder: (context, index) {
                  //     DocumentSnapshot projectdata = snapshot.data!.docs[index];

                }
              }),
          replacement: Align(
              alignment: Alignment.center,
              child: Text("Results will be shown here")),
        ),
        replacement: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('observers')
                .where('uid',
                    isEqualTo:
                        FirebaseAuth.instance.currentUser!.uid.toString())
                .snapshots(),
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
                                  // List checkList = context
                                  //     .watch<dbManager>()
                                  //     .projectdoc!['observationList'];
                                  return Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
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

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 10),
                                            child: Text(
                                              obName,
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          // visible: checkList.contains(obName),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                List addList = [Projectid];
                                                final FirebaseAuth auth =
                                                    FirebaseAuth.instance;
                                                final User? user =
                                                    auth.currentUser;
                                                final userid = user!.uid;
                                                FirebaseFirestore.instance
                                                    .collection('observers')
                                                    .doc(userid)
                                                    .collection('projects')
                                                    .doc(valid[0])
                                                    .update({
                                                  "observationList":
                                                      FieldValue.arrayUnion(
                                                          [Projectid])
                                                });
                                              },
                                            ),
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
      ),
    );
  }
}
