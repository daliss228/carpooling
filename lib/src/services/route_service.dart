import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/models/report_route_model.dart';
import 'package:flutter_carpooling/src/services/transformers/route_group_data.dart';

class RouteService with RouteGroupData {

  final _prefs = UserPreferences();
  final _userService = UserService();
  final _dbRef = FirebaseDatabase.instance.reference();
  final _mapPlaces = GoogleMapsPlaces(apiKey: "AIzaSyDGTNY3kaJaonzA8idDWA4lbxLvWJQDlNg");

  int limitData = 0;
  int limitDataCompare = -20;

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
        _dbRef.child("routes").child(route.id).update(route.toJson());
        return {"ok": true, "message": "Ruta actualizada con éxito", "value": route.id};
      } else {
        final routeUid = _dbRef.child("routes").push().key;
        route.id = routeUid;
        _dbRef.child("routes").child(routeUid).set(route.toJson());
        return {"ok": true, "message": "Ruta creada con éxito", "value": routeUid};
      }
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }

  Future<Map<String, dynamic>> readGroupRoute() async {
    try {
      final response = (await _dbRef.child("routes").orderByChild("group").equalTo(_prefs.uidGroup).once()).value;
      List<RouteModel> routes = routeModelList(response);
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
      return {"ok": true, "value": routes};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }

  Future<Map<String, dynamic>> createRegisterUserRoute(String routeUid) async {
    try {
      await _dbRef.child("routes").child(routeUid).child("users").set({"${_prefs.uid}": DateTime.now().toString()});
      return {"ok": true, "message": "Pasajero registrado con éxito"};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }

  Future<Map<String, dynamic>> canceleRegisterUserRoute(String routeUid) async {
    try {
      await _dbRef.child("routes").child(routeUid).child("users").child(_prefs.uid).remove();
      return {"ok": true, "message": "Pasajero canceló la ruta con éxito"};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }

  Future<Map<String, dynamic>> removeRoute(String routeUid) async {
    try {
      await _dbRef.child("routes").child(routeUid).remove();
      return {"ok": true};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }

  Future<Map<String, dynamic>> createReportRoute(ReportModel report) async {
    try {
      await _dbRef.child("reports").child(_prefs.uidGroup).push().set(report.toJson());
      return {"ok": true};
    } on FirebaseException catch (e) {
      return {"ok": false, "message": e.message.toString()};
    }
  }

  // Start STREAM ---- readMyRegisteredRoutes

  List<RouteModel> _myCreatedRoutes = new List();

  final _myCreatedRoutesStream = StreamController<List<RouteModel>>.broadcast();

  Function(List<RouteModel>) get myCreatedRouteSink => _myCreatedRoutesStream.sink.add;
  Stream <List<RouteModel>> get myCreatedRouteStream => _myCreatedRoutesStream.stream; 

  // End STREAM ---- readMyRegisteredRoutes

  Future<Map<String, dynamic>> myCreatedRoutes() async {
    try{
      limitData += 20; 
      final resp = await _dbRef.child('routes').orderByChild('id_driver').equalTo(_prefs.uid).limitToLast(limitData).once();
      if(resp.value == null) throw FormatException('No tienes rutas registradas.');
      
      final myCreatedRoutes = routeModelList(resp.value);
      _myCreatedRoutes.addAll(myCreatedRoutes);
      final uidMap = _myCreatedRoutes.map((e) => e.id).toSet();
      _myCreatedRoutes.retainWhere((element) => uidMap.remove(element.id)); 
      myCreatedRouteSink(_myCreatedRoutes);
      return {"ok": true};  
    }on PlatformException catch (e){
      return {"ok": false}; 
    }on FormatException catch (e){
      limitData -= 20; 
      _myCreatedRoutes.addAll([]);
      myCreatedRouteSink(_myCreatedRoutes);
      return {"ok": false};
    }
  }

  // Start STREAM ---- 

  List<RouteModel> _routesInMyGroup = new List();

  final _routesInMyGroupStream = StreamController<List<RouteModel>>.broadcast(); 

  Function(List<RouteModel>) get routesInMyGroupSink => _routesInMyGroupStream.sink.add;
  Stream <List<RouteModel>> get routesInMyGroupStream => _routesInMyGroupStream.stream.transform(validateRoutesInMyGroup);
  
  // End STREAM ----

  Future<Map<String, dynamic>> routesInMyGroup() async {
    try{
      
      limitData += 20; 
      limitDataCompare += 20; 
      final resp = await _dbRef.child('routes').orderByChild('group').equalTo(_prefs.uidGroup).limitToLast(limitData).once();
      if(resp.value == null) throw FormatException('No tienes rutas registradas.');
      final routesInMyGroup = routeModelList(resp.value);
      _routesInMyGroup.addAll(routesInMyGroup);
      final uidMap = _routesInMyGroup.map((e) => e.id).toSet();
      _routesInMyGroup.retainWhere((element) => uidMap.remove(element.id)); 
      routesInMyGroupSink(_routesInMyGroup);
      return {"ok": true}; 
    }on PlatformException catch (e){
      return {"ok" : false};
    }on FormatException catch (e){
      limitDataCompare -= 20;
      limitData -= 20; 
      _routesInMyGroup.addAll([]);
      routesInMyGroupSink(_routesInMyGroup);
      return {"ok": false};
    }
  }

  // STREAMS Dispose
  void disposeStreams(){
    _myCreatedRoutesStream?.close(); 
    _routesInMyGroupStream?.close();
  }
}
