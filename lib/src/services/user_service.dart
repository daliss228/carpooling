import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';

class UserService {

  final _prefs = UserPreferences();
  final _dbRef = FirebaseDatabase.instance.reference(); 
  final _storeRef = FirebaseStorage.instanceFor(bucket: 'gs://dev-carpooling.appspot.com').ref();
  
  Future<Map<String, dynamic>> readUser([String userUid]) async {
    try {
      final result = (await _dbRef.child("users").child((userUid == null) ? _prefs.uid : userUid).once()).value;
      final user = UserModel.fromJson(result);
      return {"ok": true, "value": user}; 
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.toString()}; 
    }
  }

  Future<Map<String, dynamic>> updateUser(String property, String value) async {
    try {
      _dbRef.child("users").child(_prefs.uid).update({property: value});
      return {"ok": true}; 
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()}; 
    }
  }

  Future<Map<String, dynamic>> uploadPhotoUser(String oldPhoto, File imageFile) async {
    try {
      if (oldPhoto != null) {
        final nameImage = nameFromUrlPhoto(oldPhoto);
        await _storeRef.child(nameImage).delete();
      }
      String filePath = "${DateTime.now()}.png";
      UploadTask uploadTask = _storeRef.child(filePath).putFile(imageFile);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      await _dbRef.child("users").child(_prefs.uid).update({"photo": downloadUrl});
      return {"ok": true, "message": "Imagen registrada correctamente"}; 
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()}; 
    }
  }

  Future<Map<String, dynamic>> addLatLng2Pax(LocalityModel coordinates) async {
    try{
      await _dbRef.child('users/${_prefs.uid}/coordinates').set(coordinates.toJson());
      return {"ok": true, "message": "Coordenadas registradas correctamente"};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()}; 
    }
  }

  Future<Map<String, dynamic>> addOrUpdateRating2Driver(String idDriver, double value) async {
    try {
      if (value == 0) {
        await _dbRef.child('users/$idDriver/rate').set({'${_prefs.uid}': value});
      } else {
        await _dbRef.child('users/$idDriver/rate').update({'${_prefs.uid}': value});
      }
      return {"ok": true, "message": "Calificación registrada correctamente"};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()}; 
    }
  }

}