import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/CreateProject.dart';
import 'package:qarshi_app/Observer/Sepecies.dart';
import 'package:qarshi_app/authanticate/login.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import '../services/RouteManager.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.off(const Home());
  }

  // String acc = Get.arguments;
  int obn = 0;
  int rank = 0;

  List<Widget> accountSettings = [];
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 0,
          centerTitle: true,
          title: Visibility(
            // visible: acc == 'Observer',
            child: Text(
              'Observer',
              style: TextStyle(color: Colors.white),
            ),
            replacement: Text(
              'Profile',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  logout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            // width: MediaQuery.of(context).size.h,
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.width * 0.25,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(90)))),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                const Text(
                  'Name ABC',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Observations: $obn ',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      '|',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Rank: $rank ',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                Visibility(
                  visible:
                      'ObserverAcc' != context.watch<ManageRoute>().Profile,
                  child: ExpansionTile(
                    title: Text('Personal Setting'),
                    subtitle: Text('Change your personal settings.'),
                    children: <Widget>[
                      TextField(
                        decoration:
                            InputDecoration(hintText: 'Enter your Name'),
                      ),
                      TextField(
                        decoration:
                            InputDecoration(hintText: 'Enter your Email'),
                      ),
                      TextField(
                        decoration:
                            InputDecoration(hintText: 'Enter your Password'),
                      ),
                      TextField(
                        decoration:
                            InputDecoration(hintText: 'Enter Confirm Password'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Save Changes'),
                      )
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text('Observattions'),
                  // subtitle: Text('Ob'),
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () => Get.to(Sepecies(),
                                    arguments: ['Observe', 4]),
                                title: Text('Observation $index'),
                              ),
                            );
                          }),
                    )
                  ],
                ),
                ExpansionTile(
                  title: Text('Projects'),
                  // subtitle: Text('Ob'),
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  Get.to(Project());
                                  context
                                      .read<ManageRoute>()
                                      .ChangeProject('ProjectShow');
                                },
                                title: Text('Project $index'),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ]),
      );
    });
  }
}
