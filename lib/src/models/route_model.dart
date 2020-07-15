// To parse this JSON data, do
//
//     final routeModel = routeModelFromJson(jsonString);

import 'dart:convert';

List<RouteModel> routeModelFromJsonToList(dynamic data) => List<RouteModel>.from(data.toList().map((x) => RouteModel.fromJson(x)));

RouteModel routeModelFromJson(String str) => RouteModel.fromJson(json.decode(str));

String routeModelToJson(RouteModel data) => json.encode(data.toJson());

class RouteModel {
    RouteModel({
        this.address,
        this.coordinates,
        this.idDriver,
        this.hour,
        this.idCar,
        this.schedule,
        this.status,
    });

    String address;
    Coordinates coordinates;
    String idDriver;
    String hour;
    String idCar;
    Schedule schedule;
    String status;

    factory RouteModel.fromJson(Map<dynamic, dynamic> json) => RouteModel(
        address: json["address"],
        coordinates: Coordinates.fromJson(json["coordinates"]),
        idDriver: json["id_driver"],
        hour: json["hour"],
        idCar: json["id_car"],
        schedule: Schedule.fromJson(json["schedule"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "coordinates": coordinates.toJson(),
        "id_driver": idDriver,
        "hour": hour,
        "id_car": idCar,
        "schedule": schedule.toJson(),
        "status": status,
    };
}

class Coordinates {
    Coordinates({
        this.lat,
        this.lng,
    });

    double lat;
    double lng;

    factory Coordinates.fromJson(Map<dynamic, dynamic> json) => Coordinates(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
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
        friday: json["friday"],
        monday: json["monday"],
        saturday: json["saturday"],
        sunday: json["sunday"],
        thursday: json["thursday"],
        tuesday: json["tuesday"],
        wednesday: json["wednesday"],
    );

    Map<String, dynamic> toJson() => {
        "friday": friday,
        "monday": monday,
        "saturday": saturday,
        "sunday": sunday,
        "thursday": thursday,
        "tuesday": tuesday,
        "wednesday": wednesday,
    };
}
