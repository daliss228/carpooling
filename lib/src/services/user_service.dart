
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';
import 'package:firebase_database/firebase_database.dart';

class UsuarioService {

  final _prefs = PreferenciasUsuario();
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  final DBRef = FirebaseDatabase.instance.reference(); 

  Future<bool> userDb(UserModel user) async {
    try{
      await DBRef.child('users/${user.uid}').set(
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
      Query findCi = await DBRef.child('pending_users').orderByKey().equalTo(ci).limitToFirst(1);
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

  Future<FirebaseUser> signIn(String email, String password) async {
    FirebaseUser user;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password); 
      user = result.user;
      return user; 
    }catch(e){
      print(e.toString()); 
      return null;
    }finally{
      if(user != null){
        user.getIdToken().then((token){
          _prefs.token = token.token;
        });
        _prefs.uid = user.uid.toString();
      }
    }
  }

  Future<void> signOut() async {
    _auth.signOut(); 
  }

}