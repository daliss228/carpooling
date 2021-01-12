import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/models/report_model.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';

class RouteService {

  final _prefs = UserPreferences();
  final _userService = UserService();
  final _dbRef = FirebaseFirestore.instance;
  final _mapPlaces = GoogleMapsPlaces(apiKey: "AIzaSyDGTNY3kaJaonzA8idDWA4lbxLvWJQDlNg");

  Future<ValidatorResponse> searchRouteByText(String destination) async {
    try {
      final PlacesSearchResponse result = await _mapPlaces.searchByText(destination, location: Location(-0.198964, -78.505659), radius: 25000, language: 'es');
      if (result.status == "OK") {
        return ValidatorResponse(status: true, data: result.results, code: 2);
      } else {
        throw "Status code is different from OK";
      }
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4);
    }
  }

  Future<ValidatorResponse> createOrUpdateRoute(RouteModel route) async {
    try {
      if (await DataConnectionChecker().hasConnection) {
        if (route.id != null) {
          await _dbRef.collection("routes").doc(route.id).update(route.toJson());
          return ValidatorResponse(status: true, message: "Ruta actualizada con éxito", data: route.id, code: 1);
        } else {
          final result = _dbRef.collection("routes").doc();
          route.id = result.id;
          await _dbRef.collection("routes").doc(result.id).set(route.toJson());
          return ValidatorResponse(status: true, message: "Ruta creada con éxito", data: result.id, code: 1);
        }
      } else {
        return ValidatorResponse(status: false, message: "No tiene internet, compruebe la conexión.", code: 5);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> readGroupRoute() async {
    try {
      List<RouteModel> routes = List<RouteModel>();
      final result = (await _dbRef.collection("routes").where("id_group", isEqualTo: _prefs.uidGroup).where("status", isEqualTo: true).get()).docs.map((doc) => doc.data()).toList();
      if (result != null) {
        routes = RouteModel.routeModelList(result);
        for (RouteModel route in routes) {
          List<UserModel> users = List<UserModel>();
          if (route.idUsers != null) {
            for (String key in route.idUsers.keys) {
              final paxResult = await _userService.readUser(key);
              if (paxResult.status) {
                users.add(paxResult.data);
              } else {
                throw paxResult.message;
              }
            }
            route.users = users;
          }
        }
      }
      return ValidatorResponse(status: true, data: routes, code: 2);
    } on FirebaseException catch (e) {
      return ValidatorResponse(status:false, message: e.message, code: 4);
    } catch (e) {
      return ValidatorResponse(status:false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> createRegisterUserRoute(String routeUid) async {
    try {
      if (await DataConnectionChecker().hasConnection) {
        await _dbRef.collection("routes").doc(routeUid).update({'users.${_prefs.uid}': DateTime.now().toString()});
        return ValidatorResponse(status: true, message: "Pasajero registrado con éxito", code: 1);        
      } else {
        return ValidatorResponse(status: false, message: "No tiene internet, compruebe la conexión.", code: 5);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4);
    }
  }

  Future<ValidatorResponse> canceleRegisterUserRoute(String routeUid) async {
    try {
      if (await DataConnectionChecker().hasConnection) {
        await _dbRef.collection("routes").doc(routeUid).update({"users.${_prefs.uid}": FieldValue.delete()});
        return ValidatorResponse(status: true, message: "Pasajero canceló la ruta con éxito", code: 1);
      } else {
        return ValidatorResponse(status: false, message: "No tiene internet, compruebe la conexión.", code: 5);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

  Future<ValidatorResponse> removeRoute(String routeUid) async {
    try {
      if (await DataConnectionChecker().hasConnection) {
        await _dbRef.collection("routes").doc(routeUid).delete();
        return ValidatorResponse(status: true, message: "Ruta eliminada con éxito!", code: 1);  
      } else {
        return ValidatorResponse(status: false, message: "No tiene internet, compruebe la conexión.", code: 5);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4);
    }
  }

  Future<ValidatorResponse> createReportRoute(ReportModel report) async {
    try {
      if (await DataConnectionChecker().hasConnection) {
        await _dbRef.collection("reports").doc().set(report.toJson());
        return ValidatorResponse(status: true, message: "Reporte creado con éxito", code: 2);
      } else {
        return ValidatorResponse(status: false, message: "No tiene internet, compruebe la conexión.", code: 5);
      }
    } on FirebaseException catch (e) {
      return ValidatorResponse(status: false, message: e.message, code: 4);
    } catch (e) {
      return ValidatorResponse(status: false, message: e.toString(), code: 4); 
    }
  }

}
