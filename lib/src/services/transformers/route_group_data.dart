import 'dart:async';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';

class RouteGroupData{

  final validateRoutesInMyGroup = StreamTransformer<List<RouteModel>, List<RouteModel>>.fromHandlers(
    handleData: (routesInMyGroup, sink) {
      final _prefs = new UserPreferences();
      List<RouteModel> _routesInMyGroup = new List();
      routesInMyGroup.forEach((routes) {
        if(routes.idDriver != _prefs.uid.toString() && routes.status){
          _routesInMyGroup.add(routes);
        }
      });
      _routesInMyGroup.forEach((routes) {
        routes.distance = getKilometers(double.tryParse(_prefs.lat), double.tryParse(_prefs.lng), routes.coordinates.lat, routes.coordinates.lng);
      });
      _routesInMyGroup..sort((a,b) => a.distance.compareTo(b.distance));
      sink.add(_routesInMyGroup..toSet());
    },
  );

  
}