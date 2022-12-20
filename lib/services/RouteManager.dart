// import 'package:cloud_firestore/cloud_firestore.dart';
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ManageRoute with ChangeNotifier {
  String _User = '';
  String _Message = '';
  String _Profile = '';
  String _Project = '';
  String _Sepecies = '';
  List _observer = [];
  List _project = [];
  List _noobservation = [];
  // late DocumentSnapshot _doc;

  String get User => _User;
  String get Message => _Message;
  String get Profile => _Profile;
  String get Project => _Project;
  String get Sepecies => _Sepecies;
  List get observer => _observer;
  List get noobservation => _noobservation;
  List get project => _project;
  // DocumentSnapshot get doc => _doc;

  void ChangeUser(String a) {
    _User = a;
    notifyListeners();
  }

  // void ChangeDoc(DocumentSnapshot a) {
  //   _doc = a;
  //   notifyListeners();
  // }

  void ChangeSepecies(String a) {
    _Sepecies = a;
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

  void ObserverLIst(List a) {
    _observer = a;
    notifyListeners();
  }

  void NoObservationLIst(List a) {
    _noobservation = a;
    notifyListeners();
  }

  void ProjectList(List a) {
    _project = a;
    notifyListeners();
  }
}
