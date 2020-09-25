import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_carpooling/src/services/transformers/route_in_my_group_data_transform.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';

class RouteService with RouteInMyGroupTransformer {

  final UserService _userService = UserService();
  final UserPreferences _prefs = UserPreferences();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  final GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: "AIzaSyDGTNY3kaJaonzA8idDWA4lbxLvWJQDlNg");

  int limitData = 0;
  int limitDataCompare = -20;

  Future<Map<String, dynamic>> searchRouteByText(String destino) async {
    try {
      final PlacesSearchResponse result = await places.searchByText(destino, location: Location(-0.198964, -78.505659), radius: 25000, language: 'es');
      if (result.status == "OK") {
        return {"ok": true, "value": result.results};
      } else {
        throw "Status code is different from OK";
      }
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<Map> createRoute(RouteModel _route) async {
    try {
      String routeUid = _dbRef.child("routes").push().key;
      _route.uid = routeUid;
      _dbRef.child("routes").child(routeUid).set(_route.toJson());
      return {"ok": true};
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

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
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> readMyRegisteredRoutes() async {
    try {
      List<RouteModel> myRoutes = List<RouteModel>();
      final response = await readGroupRoute();
      if (!response["ok"]) throw response["messaje"];
      List<RouteModel> routes = response["value"];
      for (RouteModel route in routes) {
        if (route.users != null) {
          for (UserModel user in route.users) {
            if (user.uid == _prefs.uid) {
              myRoutes.add(route);
              break;
            }
          }
        }
      }
      return {"ok": true, "value": myRoutes};
    } catch (e) {
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
        await _dbRef.child("routes").child(routeUid).child("users").child(_prefs.uid).update(user.toJson());
      } else {
        throw result["message"];
      }
      return {"ok": true};
    } catch (e) {
      return {"ok": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> canceleRegisterUserRoute(String routeUid) async {
    try {
      await _dbRef.child("routes").child(routeUid).child("users").child(_prefs.uid).remove();
      return {"ok": true};
    } catch (e) {
      return {"ok": false, "message": e.toString()};
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
      final uidMap = _myCreatedRoutes.map((e) => e.uid).toSet();
      _myCreatedRoutes.retainWhere((element) => uidMap.remove(element.uid)); 
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
      final uidMap = _routesInMyGroup.map((e) => e.uid).toSet();
      _routesInMyGroup.retainWhere((element) => uidMap.remove(element.uid)); 
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
