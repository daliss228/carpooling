import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';

class UserProvider with ChangeNotifier{

  UserModel _userModel;

  UserModel get user => this._userModel;

  set user(UserModel userModel) {
    this._userModel = userModel;
  }

  set name(String name) {
    this._userModel.name = name;
    notifyListeners();
  }

  set lastname(String lastName) {
    this._userModel.lastname = lastName;
    notifyListeners();
  }

  set phone(String phone) {
    this._userModel.phone = phone;
    notifyListeners();
  }

  set photo(String photo) {
    this._userModel.photo = photo;
    notifyListeners();
  }

}