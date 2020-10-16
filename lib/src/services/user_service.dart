import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';

class UserService {

  final UserPreferences _prefs = UserPreferences();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference(); 
  final StorageReference _storeRef = FirebaseStorage(storageBucket: 'gs://dev-carpooling.appspot.com').ref();
  
  Future<Map<String, dynamic>> readUser({driverUid}) async {
    try {
      final result = (await _dbRef.child("users").child((driverUid == null) ? _prefs.uid : driverUid).once()).value;
      final user = UserModel.fromJson(result);
      return {"ok": true, "value": user}; 
    } catch(e) { 
      return {"ok": false, "message": e.toString()}; 
    }
  }

  Future<Map<String, dynamic>> uploadUser(String property, String value) async {
    try {
      _dbRef.child("users").child(_prefs.uid).update({property: value});
      return {"ok": true}; 
    } catch (e) {
      return {"ok": false, "message": e.toString()}; 
    }
  }

  Future<Map<String, dynamic>> uploadPhotoUser(String oldPhoto, File imageFile) async {
    try {
      if (oldPhoto.isNotEmpty) {
        String nameImage = nameFromUrlPhoto(oldPhoto);
        await _storeRef.child(nameImage).delete();
      }
      String filePath = "${DateTime.now()}.png";
      StorageUploadTask uploadTask = _storeRef.child(filePath).putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      _dbRef.child("users").child(_prefs.uid).update({"photo": downloadUrl});
      
      return {"ok": false, "message": "Uploaded image", 'link': downloadUrl}; 
    } catch (e) {
      return {"ok": false, "message": e.toString()}; 
    }
  }

}