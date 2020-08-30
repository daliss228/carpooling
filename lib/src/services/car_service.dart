import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/models/car_model.dart';

class CarService {
  
  final dbRef = FirebaseDatabase.instance.reference();

  Future<bool> carDb(String uid, CarModel car) async {
    try {
      await dbRef.child('users/$uid/car').set(car.toJson());
      return true;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<dynamic> carSearch(String uid) async {
    try {
      DataSnapshot findCar = await dbRef.child('users/$uid/car').once();
      //DataSnapshot findCar = await DBRef.child('users/7P5iZdrGRsO5gd1k3fRF4SToQye2/car').once();
      CarModel car = CarModel.fromJson(findCar.value);
      if (car != null) return {"ok": true, "carData": car};
      throw ('No hay un automóvil registrado.');
    } on PlatformException catch (e) {
      return {"ok": false, "message": e.code.toString()};
    } catch (e) {
      return {"ok": false, "message": e.code.toString()};
    }
  }
}
