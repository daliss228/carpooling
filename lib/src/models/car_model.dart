// TODO: eliminar la propiedad seat
class CarModel {
  CarModel({
    this.brand,
    this.color,
    this.model,
    this.registry,
    this.seat,
  });

  String brand;
  String color;
  String model;
  String registry;
  int seat;

  factory CarModel.fromJson(Map<dynamic, dynamic> json) => CarModel(
    brand: json["brand"] == null ? null : json["brand"],
    color: json["color"] == null ? null : json["color"],
    model: json["model"] == null ? null : json["model"],
    registry: json["registry"] == null ? null : json["registry"],
    seat: json["seat"] == null ? null : json["seat"],
  );

  Map<dynamic, dynamic> toJson() => {
    "brand": brand == null ? null : brand,
    "color": color == null ? null : color,
    "model": model == null ? null : model,
    "registry": registry == null ? null : registry,
    "seat": seat == null ? null : seat,
  };
}