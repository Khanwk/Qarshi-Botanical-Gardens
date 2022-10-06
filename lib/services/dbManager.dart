import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class dbManager with ChangeNotifier {
  DocumentSnapshot? _observerdoc;
  DocumentSnapshot? _observationsdoc;
  DocumentSnapshot? _projectdoc;
  DocumentSnapshot? _currentobserverdoc;
  String? _freindId;

  DocumentSnapshot? get observerdoc => _observerdoc;
  DocumentSnapshot? get observationdoc => _observationsdoc;
  DocumentSnapshot? get projectdoc => _projectdoc;
  DocumentSnapshot? get currentobserverdoc => _currentobserverdoc;
  String? get freindId => _freindId;

  void ChangeFreindId(String a) {
    _freindId = a;
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