import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:qarshi_app/Observer/userpage.dart';
import 'package:qarshi_app/Researchers/AddNew.dart';
import 'package:flutter/cupertino.dart';
import 'package:qarshi_app/accounts/account.dart';

import '../services/RouteManager.dart';

class ResearcherHome extends StatefulWidget {
  const ResearcherHome({Key? key}) : super(key: key);

  @override
  State<ResearcherHome> createState() => _ResearcherHomeState();
}

class _ResearcherHomeState extends State<ResearcherHome> {
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
          screens: const [UserPage(), ResearcherAddNew(), Account()],
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
          icon: const Icon(
            CupertinoIcons.home,
          )),
      // PersistentBottomNavBarItem(
      //     title: 'Search',
      //     activeColorPrimary: CupertinoColors.systemRed,
      //     inactiveColorPrimary: CupertinoColors.systemGrey,
      //     icon: const Icon(CupertinoIcons.search)),
      PersistentBottomNavBarItem(
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          icon: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
          )),
      // PersistentBottomNavBarItem(
      //     title: 'My Observations',
      //     activeColorPrimary: CupertinoColors.systemRed,
      //     inactiveColorPrimary: CupertinoColors.systemGrey,
      //     icon: const Icon(CupertinoIcons.news)),
      PersistentBottomNavBarItem(
          title: 'Profile',
          activeColorPrimary: CupertinoColors.systemRed,
          inactiveColorPrimary: CupertinoColors.systemGrey,
          icon: const Icon(CupertinoIcons.person)),
    ];
  }
}
