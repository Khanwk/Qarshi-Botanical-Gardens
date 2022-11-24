import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart%20';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/services/dbManager.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messagecontroller = TextEditingController();
  String freindId = Get.arguments;
  String url = "";

  getImage() async {
    String id = freindId + ".jpg".toString();

    url = await FirebaseStorage.instance
        .ref()
        .child('observers/$id ')
        .getDownloadURL();

    setState(() {});
  }

  @override
  void initState() {
    // init();
    getImage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(url),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        context.watch<dbManager>().observerdoc['name'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('observers')
                  .doc(context
                      .watch<dbManager>()
                      .currentobserverdoc['uid']
                      .toString())
                  .collection("messages")
                  .doc(context.watch<dbManager>().observerdoc['uid'].toString())
                  .collection('chats')
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data!.docs.length < 1) {
                    return Center(child: const Text("No Chat yet !"));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Timestamp timestamp =
                              snapshot.data!.docs[index]['date'] as Timestamp;
                          final DateTime dateTime = timestamp.toDate();
                          final dateString =
                              DateFormat('K:mm (dd-MM)').format(dateTime);
                          return GestureDetector(
                            onLongPress: () {
                              PopupMenuButton(
                                elevation: 20,
                                enabled: true,
                                onSelected: (value) {},
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    child: Text("Project"),
                                    value: "first",
                                  ),
                                  const PopupMenuItem(
                                    child: Text("Observation"),
                                    value: "Second",
                                  ),
                                ],
                                // ],
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment: (snapshot.data!.docs[index]
                                            ['senderid'] !=
                                        context
                                            .watch<dbManager>()
                                            .currentobserverdoc['uid']
                                    ? Alignment.topLeft
                                    : Alignment.topRight),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onLongPress: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: (snapshot.data!.docs[index]
                                                      ['senderid'] !=
                                                  context
                                                      .watch<dbManager>()
                                                      .currentobserverdoc['uid']
                                              ? Colors.grey[300]
                                              : Colors.red[200]),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          snapshot.data!.docs[index]['message'],
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Text(dateString,
                                        style: const TextStyle(fontSize: 10))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messagecontroller,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      String message = _messagecontroller.text;
                      _messagecontroller.clear();
                      String uid =
                          Provider.of<dbManager>(context, listen: false)
                              .currentobserverdoc['uid'];

                      FirebaseFirestore.instance
                          .collection('observers')
                          .doc(uid)
                          .collection('messages')
                          .doc(freindId)
                          .collection('chats')
                          .add({
                        'senderid': uid,
                        'reciverid': freindId,
                        'message': message,
                        'date': DateTime.now()
                      }).then((value) {
                        FirebaseFirestore.instance
                            .collection("observers")
                            .doc(uid)
                            .collection("messages")
                            .doc(freindId)
                            .set({"last_msg": message, 'time': DateTime.now()});
                      });
                      FirebaseFirestore.instance
                          .collection('observers')
                          .doc(freindId)
                          .collection('messages')
                          .doc(uid)
                          .collection('chats')
                          .doc()
                          .set({
                        'senderid': uid,
                        'reciverid': freindId,
                        'message': message,
                        'date': DateTime.now()
                      }).then((value) {
                        FirebaseFirestore.instance
                            .collection("observers")
                            .doc(freindId)
                            .collection("messages")
                            .doc(uid)
                            .set({"last_msg": message, 'time': DateTime.now()});
                      });
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.red,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
