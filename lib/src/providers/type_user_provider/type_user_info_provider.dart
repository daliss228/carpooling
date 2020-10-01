import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';

class TypeUser with ChangeNotifier {
  String _typeUser;
  final UserPreferences _prefs = new UserPreferences();

  TypeUser(){
    if(_prefs.mode.toString().isNotEmpty) _typeUser = _prefs.mode.toString();
  }

  get getTypeuser{
    return this._typeUser;
  }

  set setTypeUser(typeUser) {
    this._typeUser = typeUser;
  }

}