import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';

class UserProvider with ChangeNotifier{

  UserModel _userModel;

  UserModel get user => this._userModel;

  set user(UserModel userModel) {
    this._userModel = userModel;
  }

  void clean() {
    this._userModel = null;
  }

}