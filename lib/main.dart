import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:get_it/get_it.dart';
import 'package:qarshi_app/services/RouteManager.dart';
import 'package:qarshi_app/services/dbManager.dart';
import 'package:qarshi_app/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => ManageRoute(),
    ),
    ChangeNotifierProvider(
      create: (_) => dbManager(),
    ),
    // ChangeNotifierProvider(
    //   create: (_) => (CRUDModel()),
    // )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
