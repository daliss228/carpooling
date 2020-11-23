import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';

class AuthService {

  final _prefs = UserPreferences();
  final _auth = FirebaseAuth.instance; 
  final _dbRef = FirebaseDatabase.instance.reference(); 

  Future<Map<String, dynamic>> createUser(UserModel user) async {
    try{
      await _dbRef.child('users/${user.id}').set(user.toJson());
      return {"ok": true, "message": "Registro de usuario creado exitosamente"}; 
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()}; 
    }   
  }

  Future<Map<String, dynamic>> searchCi(String ci) async {
    try{
      DataSnapshot findCi = await _dbRef.child('pending_users').orderByKey().equalTo(ci).once();
      if(findCi.value != null){
        _prefs.uidGroup = findCi.value[ci].toString(); 
        return {'ok': true, 'message': 'Usuario pendiente encontrado'};
      }else{
        return {'ok': false, 'message': 'Al parecer tu CI no esta asociada con ningún grupo de vecinos, comunícate con el administrador de tu localidad.'};
      }
    } on FirebaseException catch (e) {
      return {'ok': false, 'message': e.message.toString()};
    }
  }

  Future<Map<String, dynamic>> singUp(String email, String password) async {
    try{
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password); 
      if(result.user != null){
        _prefs.token = await result.user.getIdToken();
        _prefs.uid = result.user.uid;
      }
      return {'ok': true, 'message': 'Usuario registrado correctamente'};
    } on FirebaseAuthException catch(e){
      return {'ok': false, 'message': e.message.toString()}; 
    }

  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    UserCredential authResult;
    try {
      authResult = await _auth.signInWithEmailAndPassword(email: email, password: password); 
      authResult.user.getIdToken().then((valueToken) {
        _prefs.token = valueToken;
      });
      _prefs.uid = authResult.user.uid.toString();
      return {"ok": true, "message": "Inicio de sesión exitoso!"}; 
    } on FirebaseAuthException catch (e){
      return {"ok": false, "message": firebaseErrorMessages(e.code)};
    }
  } 

  Future<Map<String, dynamic>> reAuth(String email, String pass, String newPass) async {
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
        authResult.user.getIdToken().then((token){
          _prefs.token = token;
        });
        return {"ok": true, "message": "Contraseña cambiada con éxito!"}; 
      } else {
        throw "Se he producido un error"; 
      }
    } on FirebaseAuthException catch(e){ 
      return {"ok": false, "message": firebaseErrorMessages(e.code)};
    }
  }

  Future<void> signOut() async {
    _auth.signOut(); 
    _prefs.lat = '';
    _prefs.lng = '';
    _prefs.mode = '';
    _prefs.token = '';
    _prefs.uidGroup = '';
  }

}