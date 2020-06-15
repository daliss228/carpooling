import 'dart:convert';

import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  final String _firebaseToken = 'AIzaSyCPhQNoAfJsuioyoB12GwKIqRH49cPCfAI'; 
  final String _url = 'https://dev-carpooling.firebaseio.com'; 
  final _prefs = PreferenciasUsuario();


  Future<bool> crearUsuarioDb(UserModel user) async {
    final url = '$_url/users/${user.uid}.json'; 
    final resp = await http.put(
      url,
      body: userModelToJson(user)
    ); 
    final decodeData = json.decode(resp.body); 
    //print(decodeData);
    return true; 
  }

  Future<Map<String, dynamic>> login(String email, String password) async{
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    }; 

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    ); 

    Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp['localId']); 

    if(decodeResp.containsKey('idToken')){
      _prefs.uid = decodeResp['localId'];
      _prefs.token = decodeResp['idToken']; 
      return{'ok': true, 'token': decodeResp['idToken']};
    } else{
      return{'ok': false, 'mensaje': decodeResp['error']['message']}; 
    }

  }


  Future<dynamic> nuevousuario(String email, String password) async{
    final authData = {
      'email' : email, 
      'password': password, 
      'returnSecureToken': true
    }; 
    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    ); 

    Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp['localId']); 

    if(decodeResp.containsKey('idToken')){
      _prefs.uid = decodeResp['localId'];
      _prefs.token = decodeResp['idToken']; 
      return{'ok': true, 'token': decodeResp['idToken']};
    } else{
      return{'ok': false, 'mensaje': decodeResp['error']['message']}; 
    }

  }
}