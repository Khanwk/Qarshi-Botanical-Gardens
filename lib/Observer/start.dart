import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Researchers/AddNew.dart';
import 'package:qarshi_app/accounts/account.dart';
import 'package:qarshi_app/Observer/userpage.dart';
import 'package:qarshi_app/services/RouteManager.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);
  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  String role = Get.arguments;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    context.read<ManageRoute>().ChangeUser(role);
    return Scaffold(
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
        ));
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
