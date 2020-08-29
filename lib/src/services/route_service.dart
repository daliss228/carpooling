import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';

class RouteService {

  
  final UserService _userService = UserService();
  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  // Future<Map<String, dynamic>> readRoute(String idRoute) async {
  //   try {
  //     final result = await dbRef.child("routes").child(idRoute).once();

  //     return {"ok": true, "data": '12'};
  //   } catch (e) {
  //     return {"ok": false, "message": e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> readGroupRoute() async {
    try {
      final response = (await _dbRef.child("routes").orderByChild("group").equalTo(_prefs.uidGroup).once()).value;
      List<RouteModel> routes = routeModelList(response);
      for (var i = 0; i < routes.length; i++) {
        final result = await _userService.readUser(driverUid: routes[i].driverUid);
        if (result["ok"]) {
          routes[i].driver = result["value"];
        } else {
          throw result["message"];
        }
      }
      return {"ok": true, "value": routes};
    } 
    catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> readMyRegisteredRoutes() async {
    try {
      final response = (await _dbRef.child("routes").orderByChild("group").equalTo(_prefs.uidGroup).once()).value;
      List<RouteModel> routes = routeModelList(response);
      for (var i = 0; i < routes.length; i++) {
        final result = await _userService.readUser(driverUid: routes[i].driverUid);
        if (result["ok"]) {
          routes[i].driver = result["value"];
        } else {
          throw result["message"];
        }
      }
      return {"ok": true, "value": routes};
    } 
    catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> createRegisterUserRoute(String routeUid) async {
    UserService userService = UserService();
    try {
      final result = await userService.readUser();
      if (result["ok"]) {
        UserModel user = UserModel();
        user = result["value"];
        await _dbRef.child("routes").child(routeUid).child("users").push().set(user.toJson());
      } else {
        throw result["message"];
      }
      return {"ok": true};
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

}
