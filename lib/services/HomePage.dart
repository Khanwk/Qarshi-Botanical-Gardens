import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/CreateProject.dart';
import 'package:qarshi_app/Observer/Message.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:qarshi_app/services/observers.dart';
import 'package:get/get.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:qarshi_app/accounts/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List sepecies = [];
List book = [];

List observation = [];

List observer = [];

// bool b = false;
// bool ob = false;
// bool obn = false;
// bool sep = true;

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> observerstream =
      FirebaseFirestore.instance.collection('observers').snapshots();
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
          Visibility(
            visible: 'Research' == context.watch<ManageRoute>().User,
            child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.05),
                child: IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Requests'),
                              contentPadding: EdgeInsets.zero,
                              content: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width * 1,
                                child: ListView.builder(
                                  // shrinkWrap: true,
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    return Card(

                                        // child: Padding(
                                        // padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                      onTap: (() {}),
                                      leading: Text('$index'),
                                      title: Text('List Item'),
                                      subtitle: Text('Observer'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.done,
                                                color: Colors.lightGreen,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            )),
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.red,
                      size: 32.0,
                    ))),
          ),
          Visibility(
              child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Messages'),
                        contentPadding: EdgeInsets.zero,
                        content: Container(
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
                                  Get.to(Message());
                                }),
                                title: Text('Message $index'),
                                subtitle: Text('Observer'),
                              ));
                            },
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ));
            },
            icon: Icon(Icons.message_sharp),
            color: Colors.red,
          ))
        ],
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        bottom: TabBar(
          isScrollable: true,
          labelColor: Colors.red,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.red,
          tabs: [
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  children: [
                    const Text('Observations'),
                    Text('${observation.length}')
                  ],
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  children: [
                    const Text('Observers'),
                    Text('${observer.length}')
                  ],
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  children: [
                    const Text('Sepecies'),
                    Text('${sepecies.length}')
                  ],
                )),
            Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  children: [const Text('Projects'), Text('${book.length}')],
                )),
          ],
        ),
      ),
      body: TabBarView(children: [
        ListView.builder(
          itemCount: observation.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: (() {
                  Get.to(Sepecies(), arguments: ['Observe', 4]);
                }),
                leading: Text(observation[index].rank.toString()),
                title: Text(observation[index].name.toString()),
                trailing: Text(observation[index].nObservations.toString()),
              ),
            );
          },
        ),
        ListView.builder(
          itemCount: observer.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: (() {
                  Get.to(Account(), arguments: 'Observer');
                  context.read<ManageRoute>().ChangeProfile('ObserverAcc');
                }),
                // leading: Text(observer[index].rank.toString()),
                title: Text(observer[index]['name'].toString()),
                trailing: Text(observer[index]['Observations'].toString()),
              ),
            );
          },
        ),
        ListView.builder(
          itemCount: sepecies.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Get.to(Sepecies(), arguments: ['Sepecies', 4]);
                },
                leading: Text(sepecies[index].rank.toString()),
                title: Text(sepecies[index].name.toString()),
                trailing: Text(sepecies[index].nObservations.toString()),
              ),
            );
          },
        ),
        ListView.builder(
          itemCount: book.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: (() {
                  Get.to(Project());
                  context.read<ManageRoute>().ChangeProject('Show Project');
                }),
                leading: Text(book[index].rank.toString()),
                title: Text(book[index].name.toString()),
                trailing: Text(book[index].nObservations.toString()),
              ),
            );
          },
        ),
      ]),
    );
  }
}
