import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/services/dbManager.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messagecontroller = TextEditingController();
  String freindId = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg?fit=640,427"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        context.watch<dbManager>().observerdoc!['name'],
                        style: TextStyle(
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
                      .currentobserverdoc!['uid']
                      .toString())
                  .collection("messages")
                  .doc(
                      context.watch<dbManager>().observerdoc!['uid'].toString())
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
                    return Text("No Chat yet");
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Timestamp timestamp =
                              snapshot.data!.docs[index]['date'] as Timestamp;
                          final DateTime dateTime = timestamp.toDate();
                          final dateString =
                              DateFormat('K:mm (dd-MM)').format(dateTime);
                          return Container(
                            padding: EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                              alignment: (snapshot.data!.docs[index]
                                          ['senderid'] !=
                                      context
                                          .watch<dbManager>()
                                          .currentobserverdoc!['uid']
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: GestureDetector(
                                onLongPress: () {
                                  PopupMenuButton(
                                    child: FlutterLogo(),
                                    itemBuilder: (context) {
                                      return <PopupMenuItem>[
                                        new PopupMenuItem(child: Text('Delete'))
                                      ];
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: (snapshot.data!.docs[index]
                                                    ['senderid'] !=
                                                context
                                                    .watch<dbManager>()
                                                    .currentobserverdoc!['uid']
                                            ? Colors.grey[300]
                                            : Colors.red[200]),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        snapshot.data!.docs[index]['message'],
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Text(dateString,
                                        style: TextStyle(fontSize: 10))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }
              }),
          // ListView.builder(
          //   itemCount: messages.length,
          //   shrinkWrap: true,
          //   padding: EdgeInsets.only(top: 10, bottom: 10),
          //   physics: NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     return Container(
          //       padding:
          //           EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          //       child: Align(
          //         alignment: (messages[index].messageType == "receiver"
          //             ? Alignment.topLeft
          //             : Alignment.topRight),
          //         child: Container(
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20),
          //             color: (messages[index].messageType == "receiver"
          //                 ? Colors.grey[300]
          //                 : Colors.red[200]),
          //           ),
          //           padding: EdgeInsets.all(16),
          //           child: Text(
          //             messages[index].messageContent,
          //             style: TextStyle(fontSize: 15),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messagecontroller,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      String message = _messagecontroller.text;
                      _messagecontroller.clear();
                      String uid =
                          Provider.of<dbManager>(context, listen: false)
                              .currentobserverdoc!['uid'];

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
                      });
                    },
                    child: Icon(
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
