// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart ' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart ' as firebase_core;

// class Storage {
//   final firebase_storage.FirebaseStorage storage =
//       firebase_storage.FirebaseStorage.instance;
//   Future<void> uploadObserverFile(
//     String filePath,
//     String fileName,
//   ) async {
//     File file = File(filePath);

//     try {
//       await storage.ref('observers/$fileName ').putFile(file);
//     } on firebase_core.FirebaseException catch (e) {
//       print(e);
//     }
//     String downloadUrl = await storage.ref().child(fileName).getDownloadURL();
//     FirebaseFirestore.instance.collection('observers').doc(fileName).set({
//       "image": downloadUrl,
//     });
//   }

//   Future<void> uploadTempFile(
//     String filePath,
//     String fileName,
//   ) async {
//     File file = File(filePath);

//     try {
//       await storage.ref('TempScan/$fileName ').putFile(file);
//     } on firebase_core.FirebaseException catch (e) {
//       print(e);
//     }
//   }

//   Future<void> uploadObservationFile(
//     String filePath,
//     String id,
//     String fileName,
//   ) async {
//     File file = File(filePath);

//     try {
//       await storage.ref('observations/$id/$fileName ').putFile(file);
//     } on firebase_core.FirebaseException catch (e) {
//       print(e);
//     }
//   }

//   Future<String> getImageFile(String fileName) async {
//     String downloadUrl = await storage.ref().child(fileName).getDownloadURL();
//     // print(downloadUrl);
//     return downloadUrl;
//   }

//   Future<String> getTempFile(String fileName) async {
//     String downloadUrl = await storage.ref().child(fileName).getDownloadURL();
//     // print(downloadUrl);
//     return downloadUrl;
//   }
// }
