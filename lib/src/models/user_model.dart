import 'dart:convert';
import 'package:flutter_carpooling/src/models/car_model.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';

List<UserModel> userModelList(Map data) => List<UserModel>.from(data.entries.map((x) => UserModel.fromJson(x.value)));

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.uid,
    this.car,
    this.name,
    this.lastName,
    this.ci,
    this.email,
    this.photo,
    this.phone,
    this.status,
    this.coordinates,
    this.uidGroup,
  });

  String uid;
  CarModel car;
  String name;
  String lastName;
  String ci;
  String email;
  String photo;
  String phone;
  bool status;
  Locality coordinates;
  String uidGroup;

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
    uid:         json["uid"] == null ? null : json["uid"],
    car:         json["car"] == null ? null : CarModel.fromJson(json["car"]),
    name:        json["name"] == null ? null : json["name"],
    lastName:    json["lastName"] == null ? null : json["lastName"],
    ci:          json["ci"] == null ? null : json["ci"],
    email:       json["email"] == null ? null : json["email"],
    photo:       json["photo"] == null ? null : json["photo"],
    phone:       json["phone"] == null ? null : json["phone"],
    status:      json["status"] == null ? null : json["status"],
    coordinates: json["coordinates"] == null ? null : Locality.fromJson(json["coordinates"]),
    uidGroup:    json["uidGroup"] == null ? null : json["uidGroup"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid == null ? null : uid,
    "car": car == null ? null : car.toJson(),
    "name": name == null ? null : name,
    "lastName": lastName == null ? null : lastName,
    "ci": ci == null ? null : ci,
    "email": email == null ? null : email,
    "photo": photo == null ? null : photo,
    "phone": phone == null ? null : phone,
    "status": status == null ? null : status,
    "coordinates": coordinates == null ? null :coordinates.toJson(), 
    "uidGroup": uidGroup == null ? null : uidGroup,
  };
}
