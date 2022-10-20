import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart ' as firebase_storage;
import 'package:firebase_core/firebase_core.dart ' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<void> uploadObserverFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('observers/$fileName ').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> uploadTempFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('TempScan/$fileName ').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> getImageFile(String fileName) async {
    String downloadUrl = await storage.ref().child(fileName).getDownloadURL();
    // print(downloadUrl);
    return downloadUrl;
  }

  Future<String> getTempFile(String fileName) async {
    String downloadUrl = await storage.ref().child(fileName).getDownloadURL();
    // print(downloadUrl);
    return downloadUrl;
  }
}
