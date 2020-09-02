import 'package:flutter/material.dart';
// import 'package:flutter_carpooling/src/utils/colors.dart';
// import 'package:flutter_carpooling/src/widgets/card_widget.dart';

class DriverHomePage extends StatefulWidget {

  const DriverHomePage({Key key}) : super(key: key);

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _listRoutes()
        ],
      ),
    );
  }

  Widget _listRoutes() {
    return Container();
    // return FutureBuilder(
    //   future: _routeService.readGroupRoute(),
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (!snapshot.hasData) {
    //       return LoadingWidget();
    //     } else {
    //       if (!snapshot.data["ok"]) {
    //         return AlertWidget(title: "Error", message: snapshot.data["message"]);
    //       } else {
    //         _routes = snapshot.data["value"];
    //         final seats = numAvalibleSeats(_routes);
    //         return ListView.builder(
    //           physics: BouncingScrollPhysics(),
    //           padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
    //           itemCount: _routes.length,
    //           itemBuilder: (BuildContext context, int i) {
    //             return CardWidget(route: _routes[i], seatsAvailable: seats[i]);
    //           }
    //         );
    //       }
    //     }
    //   }
    // );
  }

}
