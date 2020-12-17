// import 'dart:convert';
import 'package:flutter_carpooling/src/models/car_model.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';

List<UserModel> userModelList(Map data) => List<UserModel>.from(data.entries.map((x) => UserModel.fromJson(x.value)));

class UserModel {
  UserModel({
    this.id,
    this.car,
    this.name,
    this.lastname,
    this.ci,
    this.email,
    this.photo,
    this.phone,
    this.status,
    this.coordinates,
    this.idGroup,
    this.rate
  });

  String id;
  CarModel car;
  String name;
  String lastname;
  String ci;
  String email;
  String photo;
  String phone;
  bool status;
  LocalityModel coordinates;
  String idGroup;
  Map<String, double> rate;

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
    id: json["id"] == null ? null : json["id"],
    car: json["car"] == null ? null : CarModel.fromJson(json["car"]),
    name: json["name"] == null ? null : json["name"],
    lastname: json["lastname"] == null ? null : json["lastname"],
    ci: json["ci"] == null ? null : json["ci"],
    email: json["email"] == null ? null : json["email"],
    photo: json["photo"] == null ? null : json["photo"],
    phone: json["phone"] == null ? null : json["phone"],
    status: json["status"] == null ? null : json["status"],
    coordinates: json["coordinates"] == null ? null : LocalityModel.fromJson(json["coordinates"]),
    idGroup: json["id_group"] == null ? null : json["id_group"],
    rate: json["rate"] == null ? null : Map.from(json["rate"]).map((k, v) => MapEntry<String, double>(k, v.toDouble()))
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "car": car == null ? null : car.toJson(),
    "name": name == null ? null : name,
    "lastname": lastname == null ? null : lastname,
    "ci": ci == null ? null : ci,
    "email": email == null ? null : email,
    "photo": photo == null ? null : photo,
    "phone": phone == null ? null : phone,
    "status": status == null ? null : status,
    "coordinates": coordinates == null ? null :coordinates.toJson(), 
    "id_group": idGroup == null ? null : idGroup,
    "rate": rate == null ? null : Map.from(rate).map((k, v) => MapEntry<String, dynamic>(k, v))
  };
}
