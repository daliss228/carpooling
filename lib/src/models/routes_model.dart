import 'dart:convert';

Routes routesFromJson(String str) => Routes.fromJson(json.decode(str));

String routesToJson(Routes data) => json.encode(data.toJson());

class Routes {
    Routes({
        this.address,
        this.coordinates,
        this.driver,
        this.hour,
        this.schedule,
        this.status,
    });

    String address;
    Locality coordinates;
    String driver;
    String hour;
    Schedule schedule;
    String status;

    factory Routes.fromJson(Map<String, dynamic> json) => Routes(
        address: json["address"],
        coordinates: Locality.fromJson(json["coordinates"]),
        driver: json["driver"],
        hour: json["hour"],
        schedule: Schedule.fromJson(json["schedule"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "address": address,
        "coordinates": coordinates.toJson(),
        "driver": driver,
        "hour": hour,
        "schedule": schedule.toJson(),
        "status": status,
    };
}

class Locality {
    Locality({
        this.lat,
        this.lng,
    });

    double lat;
    double lng;

    factory Locality.fromJson(Map<String, dynamic> json) => Locality(
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

    factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
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
