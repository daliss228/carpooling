import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/models/report_model.dart';

class RouteService {

  final _prefs = UserPreferences();
  final _userService = UserService();
  final _dbRef = FirebaseDatabase.instance.reference();
  final _mapPlaces = GoogleMapsPlaces(apiKey: "AIzaSyDGTNY3kaJaonzA8idDWA4lbxLvWJQDlNg");

  Future<Map<String, dynamic>> searchRouteByText(String destination) async {
    try {
      final PlacesSearchResponse result = await _mapPlaces.searchByText(destination, location: Location(-0.198964, -78.505659), radius: 25000, language: 'es');
      if (result.status == "OK") {
        return {"ok": true, "value": result.results};
      } else {
        throw "Status code is different from OK";
      }
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> createOrUpdateRoute(RouteModel route) async {
    try {
      if (route.id != null) {
        await _dbRef.child("routes").child(route.id).update(route.toJson());
        return {"ok": true, "message": "Ruta actualizada con éxito", "value": route.id};
      } else {
        final routeUid = _dbRef.child("routes").push().key;
        route.id = routeUid;
        _dbRef.child("routes").child(routeUid).set(route.toJson());
        return {"ok": true, "message": "Ruta creada con éxito", "value": routeUid};
      }
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message};
    } catch (e) {
      return {'ok': false, 'message': e.toString()}; 
    }
  }

  Future<Map<String, dynamic>> readGroupRoute() async {
    try {
      List<RouteModel> routes = List<RouteModel>();
      final response = (await _dbRef.child("routes").orderByChild("group").equalTo(_prefs.uidGroup).once()).value;
      if (response != null) {
        routes = routeModelList(response);
        routes = routes.where((route) => route.status == true).toList();
        for (RouteModel route in routes) {
          List<UserModel> users = List<UserModel>();
          if (route.idUsers != null) {
            for (String key in route.idUsers.keys) {
              final paxResult = await _userService.readUser(key);
              if (paxResult["ok"]) {
                users.add(paxResult["value"]);
              } else {
                throw paxResult["message"];
              }
            }
            route.users = users;
          }
        }
      }
      return {"ok": true, "value": routes};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message};
    } catch (e) {
      return {'ok': false, 'message': e.toString()}; 
    }
  }

  Future<Map<String, dynamic>> createRegisterUserRoute(String routeUid) async {
    try {
      await _dbRef.child("routes").child(routeUid).child("users").update({"${_prefs.uid}": DateTime.now().toString()});
      return {"ok": true, "message": "Pasajero registrado con éxito"};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message};
    } catch (e) {
      return {'ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> canceleRegisterUserRoute(String routeUid) async {
    try {
      await _dbRef.child("routes").child(routeUid).child("users").child(_prefs.uid).remove();
      return {"ok": true, "message": "Pasajero canceló la ruta con éxito"};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message};
    } catch (e) {
      return {'ok': false, 'message': e.toString()}; 
    }
  }

  Future<Map<String, dynamic>> removeRoute(String routeUid) async {
    try {
      await _dbRef.child("routes").child(routeUid).remove();
      return {"ok": true};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message};
    }
  }

  Future<Map<String, dynamic>> createReportRoute(ReportModel report) async {
    try {
      if (report.type == 1) {
        report.type = null;
        await _dbRef.child("reports").child(_prefs.uidGroup).child("drivers").child(report.idRoute).push().set(report.toJson());
      } else {
        report.type = null;
        await _dbRef.child("reports").child(_prefs.uidGroup).child("paxs").child(report.idUser).push().set(report.toJson());
      }
      return {"ok": true};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message};
    } catch (e) {
      return {'ok': false, 'message': e.toString()}; 
    }
  }

}
