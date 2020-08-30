import 'package:google_maps_webservice/places.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';

class RouteService {

  final UserService _userService = UserService();
  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  final GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: "AIzaSyDGTNY3kaJaonzA8idDWA4lbxLvWJQDlNg");

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

}
