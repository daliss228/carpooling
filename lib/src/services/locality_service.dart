

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';

class LocalityService {
  final _dbRef = FirebaseDatabase.instance.reference(); 
  final _prefs = new UserPreferences();
  Future<bool> localityDb (LocalityModel coordinates) async {
    try{
      await _dbRef.child('users/${_prefs.uid}/coordinates').set(coordinates.toJson());
      return true;
    }on PlatformException catch (e){
      print(e);
      return false;
    }
  }
}