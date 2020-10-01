import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';


class UserService {

  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final UserPreferences _prefs = UserPreferences();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference(); 
  final StorageReference _storeRef = FirebaseStorage(storageBucket: 'gs://dev-carpooling.appspot.com').ref();

  Future<bool> userDb(UserModel user) async {
    try{
      await _dbRef.child('users/${user.uid}').set(
        user.toJson()
      );
      return true; 
    } on PlatformException catch(e){
      print(e.message.toString());
      return false; 
    }   
  }

  Future<dynamic> searchCi(String ci) async {
    try{
      DataSnapshot findCi = await _dbRef.child('pending_users').orderByKey().equalTo(ci).once();
      if(findCi.value != null){
        _prefs.uidGroup = findCi.value[ci].toString(); 
        return {'ok': true, 'uidGroup': findCi.value[ci]};
      }else{
        return {'ok': false, 'mensaje': 'Al parecer tu CI no esta asociada con ningún grupo de vecinos, comunícate con el administrador de tu localidad.'};
      }
    } on PlatformException catch(e){
      return {'ok': false, 'mensaje': e.message.toString()};
    }
  }

  Future<dynamic> singUp(String email, String password) async {
    FirebaseUser user;
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password); 
      user = result.user;
      return {'ok': true, 'user': user};
    } on PlatformException catch(e){
      return {'ok': false, 'mensaje': e.message.toString()}; 
    }finally{
      if(user != null){
        user.getIdToken().then((token){
          _prefs.token = token.token;
        });
        _prefs.uid = user.uid;
      }
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    AuthResult authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(email: email, password: password); 
      authResult.user.getIdToken().then((valueToken) {
        _prefs.token = valueToken.token.toString();
      });
      _prefs.uid = authResult.user.uid.toString();
      return {"ok": true, "message": "Inicio de sesión exitoso!"}; 
    } on PlatformException catch(e){
      if (e.code.toString() == "ERROR_WRONG_PASSWORD") {
        return {"ok": false, "message": "Contraseña o correo electronico no válidos!"}; 
      } else if (e.code.toString() == "ERROR_TOO_MANY_REQUESTS") {
        return {"ok": false, "message": "Demasiados intentos fallidos. \nPor favor, inténtelo de nuevo más tarde."}; 
      } else {
        return {"ok": false, "message": e.code.toString()}; 
      }
    }
  }

  Future<dynamic> reAuth(String email, String pass, String newPass) async {
    try {
      FirebaseUser user = await _auth.currentUser();
      AuthResult authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.getCredential(
          email: email,
          password: pass,
        ),
      );
      if (authResult.user.uid.length != 0) {
        user.updatePassword(newPass);
        authResult.user.getIdToken().then((token){
          _prefs.token = token.token;
        });
        return {"ok": true, "message": "Contraseña cambiada con éxito!"}; 
      }
    } on PlatformException catch(e){ 
      if (e.code.toString() == "ERROR_WRONG_PASSWORD") {
        return {"ok": false, "message": "Contraseña no válida!"}; 
      } else if (e.code.toString() == "ERROR_TOO_MANY_REQUESTS") {
        return {"ok": false, "message": "Demasiados intentos fallidos. \nPor favor, inténtelo de nuevo más tarde."}; 
      } else {
        return {"ok": false, "message": e.code.toString()}; 
      }
    }
  }

  Future<void> signOut() async {
    _auth.signOut(); 
    _prefs.token = '';
    _prefs.uid = '';
  }

  Future<void> deleteCi(String ci) async {
    await _dbRef.child('pending_users').remove();
  }

  
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

  Future<Map<String, dynamic>> uploadPhotoUser(String oldPhoto, File imageFile, BuildContext context) async {
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