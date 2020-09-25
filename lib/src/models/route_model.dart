import 'dart:convert';

import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';

List<RouteModel> routeModelList(Map data) => List<RouteModel>.from(data.entries.map((x) => RouteModel.fromJson(x.value)));

RouteModel routeModelFromJson(String str) => RouteModel.fromJson(json.decode(str));

String routeModelToJson(RouteModel data) => json.encode(data.toJson());

class RouteModel {

  RouteModel({
    this.uid,
    this.address,
    this.date,
    this.group,
    this.coordinates,
    this.driverUid,
    this.hour,
    this.schedule,
    this.status,
    this.driver,
    this.users
  });

  String uid;
  String address;
  String date;
  String group;
  Locality coordinates;
  String driverUid;
  String hour;
  Schedule schedule;
  double distance;
  bool status;
  UserModel driver;
  List<UserModel> users;

  factory RouteModel.fromJson(Map<dynamic, dynamic> json) => RouteModel(
    uid: json["uid"] == null ? null : json["uid"],
    address: json["address"] == null ? null : json["address"],
    date: json["date"] == null ? null : json["date"],
    group: json["group"] == null ? null : json["group"],
    coordinates: json["coordinates"] == null ? null : Locality.fromJson(json["coordinates"]),
    driverUid: json["id_driver"] == null ? null : json["id_driver"],
    hour: json["hour"] == null ? null : json["hour"],
    schedule: json["schedule"] == null ? null : Schedule.fromJson(json["schedule"]),
    status: json["status"] == null ? null : json["status"],
    users: json["users"] == null ? null : userModelList(json["users"])
  );

  Map<String, dynamic> toJson() => {
    "uid": uid == null ? null : uid,
    "address": address == null ? null : address,
    "date": date == null ? null : date,
    "group" : group == null ? null : group,
    "coordinates": coordinates == null ? null : coordinates.toJson(),
    "id_driver": driverUid == null ? null : driverUid,
    "hour": hour == null ? null : hour,
    "schedule": schedule == null ? null : schedule.toJson(),
    "status": status == null ? null : status,
    "users": users == null ? null : List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class Schedule {
  Schedule({
    this.friday,
    this.monday,
    this.saturday,
    this.sunday,
    this.thursday,
    this.tuesday,
    this.wednesday,
  });

  bool friday;
  bool monday;
  bool saturday;
  bool sunday;
  bool thursday;
  bool tuesday;
  bool wednesday;

  factory Schedule.fromJson(Map<dynamic, dynamic> json) => Schedule(
    friday: json["friday"] == null ? null : json["friday"],
    monday: json["monday"] == null ? null : json["monday"],
    saturday: json["saturday"] == null ? null : json["saturday"],
    sunday: json["sunday"] == null ? null : json["sunday"],
    thursday: json["thursday"] == null ? null : json["thursday"],
    tuesday: json["tuesday"] == null ? null : json["tuesday"],
    wednesday: json["wednesday"] == null ? null : json["wednesday"],
  );

  Map<String, dynamic> toJson() => {
    "friday": friday == null ? null : friday,
    "monday": monday == null ? null : monday,
    "saturday": saturday == null ? null : saturday,
    "sunday": sunday == null ? null : sunday,
    "thursday": thursday == null ? null : thursday,
    "tuesday": tuesday == null ? null : tuesday,
    "wednesday": wednesday == null ? null : wednesday,
  };
}
