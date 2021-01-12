class LocalityModel {
  LocalityModel({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory LocalityModel.fromJson(Map<dynamic, dynamic> json) => LocalityModel(
    lat: json["lat"] == null ? null : json["lat"].toDouble(),
    lng: json["lng"] == null ? null : json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat == null ? null : lat,
    "lng": lng == null ? null : lng,
  };
}