import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';

class UserService {

  final _prefs = UserPreferences();
  final _dbRef = FirebaseFirestore.instance;
  final _storeRef = FirebaseStorage.instanceFor(bucket: 'gs://dev-carpooling.appspot.com').ref();
  
  Future<ValidatorResponse> readUser([String userUid]) async {
    try {
      final result = (await _dbRef.collection("users").doc((userUid == null) ? _prefs.uid : userUid).get()).data();
      final user = UserModel.fromJson(result);
      if (user.status) {
        return ValidatorResponse(status: true, data: user, code: 2); 
      } else {
        throw("El usuario está deshabilitado!");
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4); 
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> updateUser(String property, String value) async {
    try {
      await _dbRef.collection("users").doc(_prefs.uid).update({property: value});
      return ValidatorResponse(status: true, message: "Usuario actualizado con éxito!", code: 1); 
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4); 
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> uploadPhotoUser(bool oldPhoto, File imageFile) async {
    try {
      if (await DataConnectionChecker().hasConnection) {
        if (oldPhoto == true) {
          await _storeRef.child("${_prefs.uid}.png").delete();
        }
        String filePath = "${_prefs.uid}.png";
        UploadTask uploadTask = _storeRef.child(filePath).putFile(imageFile);
        TaskSnapshot storageTaskSnapshot = await uploadTask;
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        await _dbRef.collection("users").doc(_prefs.uid).update({"photo": downloadUrl});
        return ValidatorResponse(status: true, message: "Imagen registrada correctamente", code: 1); 
      } else {
        return ValidatorResponse(status: false, message: "No tiene internet, compruebe la conexión.", code: 5);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4); 
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> addLatLng2Pax(LocalityModel coordinates) async {
    try{
      if (await DataConnectionChecker().hasConnection) {
        await _dbRef.collection("users").doc(_prefs.uid).update({"coordinates": coordinates.toJson()});
        return ValidatorResponse(status: true, message: "Coordenadas registradas correctamente", code: 2);
      } else {
        return ValidatorResponse(status: false, message: "No tiene internet, compruebe la conexión.", code: 5);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message.toString(), code: 4); 
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> addOrUpdateRating2Driver(String idDriver, double value) async {
    try {
      if (value == 0) {
        await _dbRef.collection("users").doc(idDriver).set({'rate.${_prefs.uid}': value});
      } else {
        await _dbRef.collection("users").doc(idDriver).update({'rate.${_prefs.uid}': value});
      }
      return ValidatorResponse(status: true, message: "Calificación registrada correctamente", code: 2);
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4); 
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

}