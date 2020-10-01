
import 'dart:convert';

Locality localityModelFromJson(String str) => Locality.fromJson(json.decode(str));
String localityModelToJson(Locality data) => json.encode(data.toJson());

class Locality {
  Locality({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Locality.fromJson(Map<dynamic, dynamic> json) => Locality(
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    lng: json["lng"] == null ? null : json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat == null ? null : lat,
    "lng": lng == null ? null : lng,
  };
}