import 'dart:convert';

Car carFromJson(String str) => Car.fromJson(json.decode(str));

String carToJson(Car data) => json.encode(data.toJson());

class Car {
    Car({
        this.id,
        this.brand,
        this.color,
        this.model,
        this.registry,
        this.seat,
    });

    String id;
    String brand;
    String color;
    String model;
    String registry;
    String seat;

    factory Car.fromJson(Map<dynamic, dynamic> json) => Car(
        id: json["id"],
        brand: json["brand"],
        color: json["color"],
        model: json["model"],
        registry: json["registry"],
        seat: json["seat"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "brand": brand,
        "color": color,
        "model": model,
        "registry": registry,
        "seat": seat,
    };
}
