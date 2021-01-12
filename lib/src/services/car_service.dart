import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_carpooling/src/models/car_model.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';

class CarService {
  
  final _dbRef = FirebaseFirestore.instance;

  Future<ValidatorResponse> createCar(String uid, CarModel car) async {
    try {
      await _dbRef.collection("users").doc(uid).update({"car": car.toJson()});
      return ValidatorResponse(status: true, message: "Carro creado con éxito.", code: 1);
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message.toString(), code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  // TODO: esta funcion es innecesaria porque la data del auto ya se encuentra cargada en UserProvider
  // Future<Map<String, dynamic>> searchCar(String uid) async {
  //   try {
  //     DataSnapshot findCar = await _dbRef.child('users/$uid/car').once();
  //     CarModel car = CarModel.fromJson(findCar.value);
  //     if (car != null) return {"ok": true, "carData": car};
  //     throw "No hay un automóvil registrado.";
  //   } on FirebaseException catch (e) {
  //     return {"ok": false, "message": e.message.toString()};
  //   } catch (e) {
  //     return {'ok': false, 'message': e.toString()}; 
  //   }
  // }
}
