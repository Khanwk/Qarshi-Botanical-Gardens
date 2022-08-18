import 'package:flutter/material.dart';
import 'package:qarshi_app/Observer/CreateProject.dart';
import 'package:qarshi_app/Observer/Message.dart';

class ManageRoute with ChangeNotifier {
  String _User = '';
  String _Message = '';
  String _Profile = '';
  String _Project = '';

  String get User => _User;
  String get Message => _Message;
  String get Profile => _Profile;
  String get Project => _Project;
  void ChangeUser(String a) {
    _User = a;
    notifyListeners();
  }

  void ChangeMessage(String a) {
    _Message = a;
    notifyListeners();
  }

  void ChangeProject(String a) {
    _Project = a;
    notifyListeners();
  }

  void ChangeProfile(String a) {
    _Profile = a;
    notifyListeners();
  }
}
