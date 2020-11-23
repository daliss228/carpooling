import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/models/car_model.dart';

class CarService {
  
  final _dbRef = FirebaseDatabase.instance.reference();

  Future<Map<String, dynamic>> createCar(String uid, CarModel car) async {
    try {
      await _dbRef.child('users/$uid/car').set(car.toJson());
      return {"ok": true, "message": "Carro creado con éxito."};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }

  Future<Map<String, dynamic>> searchCar(String uid) async {
    try {
      DataSnapshot findCar = await _dbRef.child('users/$uid/car').once();
      CarModel car = CarModel.fromJson(findCar.value);
      if (car != null) return {"ok": true, "carData": car};
      throw "No hay un automóvil registrado.";
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }
}
