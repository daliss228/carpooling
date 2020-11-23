import 'dart:convert';

import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';

List<RouteModel> routeModelList(Map data) => List<RouteModel>.from(data.entries.map((x) => RouteModel.fromJson(x.value)));

class RouteModel {

  RouteModel({
    this.id,
    this.address,
    this.date,
    this.group,
    this.coordinates,
    this.idDriver,
    this.hour,
    this.schedule,
    this.status,
    this.idUsers,
    this.seat
  });

  String id;
  String address;
  String date;
  String group;
  LocalityModel coordinates;
  String idDriver;
  String hour;
  Schedule schedule;
  double distance;
  bool status;
  Map<String, String> idUsers;
  List<UserModel> users;
  int seat;

  factory RouteModel.fromJson(Map<dynamic, dynamic> json) => RouteModel(
    id: json["id"] == null ? null : json["id"],
    address: json["address"] == null ? null : json["address"],
    date: json["date"] == null ? null : json["date"],
    group: json["group"] == null ? null : json["group"],
    coordinates: json["coordinates"] == null ? null : LocalityModel.fromJson(json["coordinates"]),
    idDriver: json["id_driver"] == null ? null : json["id_driver"],
    hour: json["hour"] == null ? null : json["hour"],
    schedule: json["schedule"] == null ? null : Schedule.fromJson(json["schedule"]),
    status: json["status"] == null ? null : json["status"],
    idUsers: json["users"] == null ? null : Map.from(json["users"]).map((k, v) => MapEntry<String, String>(k, v)),
    seat: json["seat"] == null ? null : json["seat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "address": address == null ? null : address,
    "date": date == null ? null : date,
    "group" : group == null ? null : group,
    "coordinates": coordinates == null ? null : coordinates.toJson(),
    "id_driver": idDriver == null ? null : idDriver,
    "hour": hour == null ? null : hour,
    "schedule": schedule == null ? null : schedule.toJson(),
    "status": status == null ? null : status,
    "users": idUsers == null ? null : Map.from(idUsers).map((k, v) => MapEntry<String, String>(k, v)),
    "seat": seat == null ? null : seat,
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
