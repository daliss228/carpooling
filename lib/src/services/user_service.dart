
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';
import 'package:firebase_database/firebase_database.dart';

class UsuarioService {

  final _prefs = PreferenciasUsuario();
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final _dbRef = FirebaseDatabase.instance.reference(); 

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

// Funcion en desarrollo..... 

  Future<bool> searchCi(String ci) async {
    try{
      Query findCi = await _dbRef.child('pending_users').orderByKey().equalTo(ci).limitToFirst(1);
      print('==============================================================================');
      print(findCi.onValue);
      print('==============================================================================');
      if(findCi != null){
        return true;
      }else{
        return false;
      }
    } on PlatformException catch(e){
      print(e.message.toString());
      return false;
    }
  }

  Future<dynamic> singUp(String email, String password) async {
    FirebaseUser user;
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password); 
      user = result.user;
      return {'ok': true, 'user': user};
    } on PlatformException catch(e){
      print(e.message); 
      return {'ok': false,'mensaje': e.message.toString()}; 
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
      return {"ok": true, "message": "Inicio de sesión exitoso!"}; 
    } on PlatformException catch(e){
      if (e.code.toString() == "ERROR_WRONG_PASSWORD") {
        return {"ok": false, "message": "Contraseña o correo electronico no válidos!"}; 
      } else if (e.code.toString() == "ERROR_TOO_MANY_REQUESTS") {
        return {"ok": false, "message": "Demasiados intentos fallidos. \nPor favor, inténtelo de nuevo más tarde."}; 
      } else {
        return {"ok": false, "message": e.code.toString()}; 
      }
    }finally{
      if(authResult.user.uid.length != 0){
        authResult.user.getIdToken().then((token){
          _prefs.token = token.token;
        });
        _prefs.uid = authResult.user.uid.toString();
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
  }

}