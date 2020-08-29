import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/card_widget.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';

class PaxGroupRoutes extends StatefulWidget {

  PaxGroupRoutes({Key key}) : super(key: key);

  @override
  _PaxGroupRoutesState createState() => _PaxGroupRoutesState();
}

class _PaxGroupRoutesState extends State<PaxGroupRoutes> with AutomaticKeepAliveClientMixin {

  RouteService _routeService = RouteService();
  List<RouteModel> _routes = List<RouteModel>();

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _listRoutes()
        ],
      ),
    );
  }

  Widget _listRoutes() {
    return FutureBuilder(
      future: _routeService.readGroupRoute(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        } else {
          if (!snapshot.data["ok"]) {
            return AlertWidget(title: "Error", message: snapshot.data["message"]);
          } else {
            _routes = snapshot.data["value"];
            final seats = numAvalibleSeats(_routes);
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              itemCount: _routes.length,
              itemBuilder: (BuildContext context, int i) {
                return CardWidget(route: _routes[i], seatsAvailable: seats[i]);
              }
            );
          }
        }
      }
    );
  }

}