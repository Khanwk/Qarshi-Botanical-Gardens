import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class dbManager with ChangeNotifier {
  late DocumentSnapshot _observerdoc;
  late DocumentSnapshot _observationsdoc;
  late DocumentSnapshot _projectdoc;
  late DocumentSnapshot _currentobserverdoc;
  late String? _freindId;
  late String _p;

  DocumentSnapshot get observerdoc => _observerdoc;
  DocumentSnapshot get observationdoc => _observationsdoc;
  DocumentSnapshot get projectdoc => _projectdoc;
  DocumentSnapshot get currentobserverdoc => _currentobserverdoc;
  String? get freindId => _freindId;
  String get p => _p;

  void ChangeFreindId(String a) {
    _freindId = a;
    notifyListeners();
  }

  void ChangeP(String a) {
    _p = a;
    notifyListeners();
  }

  void ChangeObserverDoc(dynamic a) {
    _observerdoc = a;
    notifyListeners();
  }

  void ChangeCurrentObserverDoc(DocumentSnapshot a) {
    _currentobserverdoc = a;
    notifyListeners();
  }

  void ChangeObservationDoc(DocumentSnapshot a) {
    _observationsdoc = a;
    notifyListeners();
  }

  void ChangeProjectDoc(DocumentSnapshot a) {
    _projectdoc = a;
    notifyListeners();
  }
}
