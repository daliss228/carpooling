import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_carpooling/src/utils/helpers.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/groups_model.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';

class AuthService {

  final _prefs = UserPreferences();
  final _auth = FirebaseAuth.instance; 
  final _dbRef = FirebaseFirestore.instance;

  Future<ValidatorResponse> createUser(UserModel user) async {
    try{
      await _dbRef.collection("users").doc(user.id).set(user.toJson());
      return ValidatorResponse(status: true, message: "Registro de usuario creado exitosamente", code: 2); 
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4); 
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> searchUserInGroups(String ci) async {
    try{
      final result = (await _dbRef.collection('users_groups').where("users.$ci", isEqualTo: false).get()).docs.map((doc) => doc.data()).toList();
      if(result.length != 0){
        return ValidatorResponse(status: true, message: 'Usuario pendiente encontrado', data: GroupModel.userModelList(result), code: 2);
      }else{
        return ValidatorResponse(status: false, message: 'Al parecer tu CI no esta asociada con ningún grupo de vecinos, comunícate con el administrador de tu localidad.', code: 3);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> registerUserInGroup(String ci) async {
    try{
      await _dbRef.collection('users_groups').doc(_prefs.uidGroup).update({"users.$ci": true});
      return ValidatorResponse(status: true, message: 'Usuario pendiente encontrado', code: 1);
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> singUp(String email, String password) async {
    try{
      final authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password); 
      _prefs.uid = authResult.user.uid;
      _prefs.token = await authResult.user.getIdToken();
      return ValidatorResponse(status: true, message: 'Usuario registrado correctamente', code: 2);
    } on FirebaseAuthException catch(e){
      return ValidatorResponse(status: false, message: firebaseErrorMessages(e.code), code: 4); 
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }

  }

  Future<ValidatorResponse> signIn(String email, String password) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(email: email, password: password); 
      _prefs.uid = authResult.user.uid;
      _prefs.token = await authResult.user.getIdToken();
      _prefs.uidGroup = (await _dbRef.collection("users").doc(authResult.user.uid).get()).data()["id_group"];
      return ValidatorResponse(status: true, message: "Inicio de sesión exitoso!", code: 2);
    } on FirebaseAuthException catch (e){
      return ValidatorResponse(status: false, message: firebaseErrorMessages(e.code), code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4);
    }
  } 

  Future<ValidatorResponse> reAuth(String email, String pass, String newPass) async {
    try {
      User user = _auth.currentUser;
      UserCredential authResult = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: pass,
        ),
      );
      if (authResult.user.uid.length != 0) {
        user.updatePassword(newPass);
        _prefs.token = await authResult.user.getIdToken();
        return ValidatorResponse(status: true, message: "Contraseña cambiada con éxito!", code: 1); 
      } else {
        throw "Se he producido un error"; 
      }
    } on FirebaseAuthException catch(e){ 
      return ValidatorResponse(status: false, message: firebaseErrorMessages(e.code), code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<void> signOut() async {
    _prefs.lat = '';
    _prefs.lng = '';
    _prefs.mode = '';
    _prefs.token = '';
    _prefs.uidGroup = '';
    await _auth.signOut(); 
  }

}