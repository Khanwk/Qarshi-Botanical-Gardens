import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Researchers/AddNew.dart';
import 'package:qarshi_app/accounts/account.dart';
import 'package:qarshi_app/Observer/userpage.dart';
import 'package:qarshi_app/authanticate/login.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);
  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  String role = Get.arguments;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                    alignment: Alignment.center,
                    child: Text("Do you want to exit?")),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  _deleteAppDir();
                                  _deleteCacheDir();
                                  context
                                      .read<ManageRoute>()
                                      .ChangeProfile("Profile");
                                  Navigator.of(context).pop();
                                  Get.off(const Home());
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade800),
                                child: const Text("Yes"),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                                child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: const Text("No",
                                  style: TextStyle(color: Colors.black)),
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ManageRoute>(context, listen: false).ChangeUser(role);
    return WillPopScope(
      onWillPop: () async {
        return showExitPopup(context);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: PersistentTabView(
            context,
            controller: _controller,
            screens: const [
              UserPage(),
              // Search(),
              ResearcherAddNew(),
              // MyObservation(),
              Account()
            ],
            items: navBarItems(),
            navBarStyle: NavBarStyle.style17,
          )),
    );
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
          title: 'Home',
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          icon: const Icon(Icons.home)),
      // PersistentBottomNavBarItem(
      //     title: 'Search',
      //     activeColorPrimary: CupertinoColors.systemRed,
      //     inactiveColorPrimary: CupertinoColors.systemGrey,
      //     icon: const Icon(CupertinoIcons.search)),
      PersistentBottomNavBarItem(
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      // PersistentBottomNavBarItem(
      //     title: 'My Observations',
      //     activeColorPrimary: CupertinoColors.systemRed,
      //     inactiveColorPrimary: CupertinoColors.systemGrey,
      //     icon: const Icon(CupertinoIcons.news)),
      PersistentBottomNavBarItem(
          // onPressed: context.watch<ManageRoute>().ChangeProfile('ShowProfile'),
          title: 'Profile',
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          icon: const Icon(Icons.person)),
    ];
  }

  // CupertinoTabScaffold(
  //   tabBar:
  //       CupertinoTabBar(activeColor: CupertinoColors.systemRed, items: const [
  //     BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
  //     BottomNavigationBarItem(
  //         icon: Icon(CupertinoIcons.search), label: 'Search'),
  //     BottomNavigationBarItem(
  //         icon: Icon(CupertinoIcons.news), label: 'My Observation'),
  //     BottomNavigationBarItem(
  //         icon: Icon(CupertinoIcons.person), label: 'Profile')
  //   ]),
  //   tabBuilder: (context, index) {
  //     switch (index) {
  //       case 0:
  //         return CupertinoTabView(
  //           builder: (context) => const UserPage(),
  //         );
  //       case 1:
  //         return CupertinoTabView(
  //           builder: (context) => Search(),
  //         );
  //       case 2:
  //         return CupertinoTabView(
  //           builder: (context) => MyObservation(),
  //         );
  //       case 3:
  //         return CupertinoTabView(
  //           builder: (context) => Account(),
  //         );
  //       default:
  //         return CupertinoTabView(
  //           builder: (context) => const UserPage(),
  //         );
  //     }
  //   },
  // );
}
