import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';

class InheretedRoutes extends InheritedWidget {

  final RoutesData routesData;
  InheretedRoutes({Key key, this.child}) : assert(child != null), routesData = RoutesData(),  super(key: key, child: child);

  final Widget child;

  static RoutesData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheretedRoutes>().routesData;
  }

  @override
  bool updateShouldNotify(InheretedRoutes oldWidget) => false;
}


class RoutesData {
  
  RouteService _routeService = RouteService();

  Future<Map<String, dynamic>> listRoutes() async {
    return await _routeService.readGroupRoute();
  }

}