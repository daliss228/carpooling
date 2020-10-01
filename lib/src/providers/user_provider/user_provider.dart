
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';

class UserInfoP with ChangeNotifier{
  UserModel userModel;

  get getUserModel {
    return this.userModel;
  }

  set setUserModel( UserModel userModel ) {
    this.userModel = userModel;
  }

  void nameUser(String name) {
    this.userModel.name = name;
    notifyListeners();
  }

  void lastNameUser(String lastName){
    this.userModel.lastName = lastName;
    notifyListeners();
  }

  void phoneUser(String phone){
    this.userModel.phone = phone;
    notifyListeners();
  }

  void photoUser(String photo){
    this.userModel.photo = photo;
    notifyListeners();
  }
}