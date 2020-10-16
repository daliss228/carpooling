import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
// import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
// import 'package:flutter_carpooling/src/models/route_model.dart';

// import 'package:flutter_carpooling/src/widgets/card_widget.dart';
// import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
// import 'package:flutter_carpooling/src/services/route_service.dart';
// import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';

class PaxHomePage extends StatefulWidget {

  const PaxHomePage({Key key}) : super(key: key);

  @override
  _PaxHomePageState createState() => _PaxHomePageState();
}

class _PaxHomePageState extends State<PaxHomePage> with AutomaticKeepAliveClientMixin {

  // RouteService _routeService = RouteService();
  // List<RouteModel> _routes = List<RouteModel>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final _responsiveScreen = new Responsive(context); 
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(_responsiveScreen),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      SizedBox(height: _responsiveScreen.hp(3),),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          FadeInRight(
                            child: Text(
                              'Mis Rutas', 
                              style: TextStyle(fontSize: _responsiveScreen.ip(4), fontFamily: 'WorkSansLight'),
                            ),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                )
              ],
            ), 
          ),
        ],
      ),
    );
  }

  Widget _background(Responsive _responsiveScreen){
    return Container(
      height: _responsiveScreen.hp(100),
      width: _responsiveScreen.wp(100),
      child: Stack(
        children: [
          Positioned(
              right: _responsiveScreen.wp(75),
              child: FadeInLeft(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(34),))
            ),
          Positioned(
            top: _responsiveScreen.hp(1),
            right: _responsiveScreen.wp(75),
            child: FadeInLeft(
                delay: Duration(milliseconds: 500),
              child: BackgoundWidget(sizeWidget: _responsiveScreen.hp(30), colors: [OurColors.initialPurple, OurColors.finalPurple],)
            )
          ),
          Positioned(
            top: _responsiveScreen.hp(70),
            left: _responsiveScreen.wp(75),
            child: FadeInRight(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(30),))
          ),
        ],
      ),
    );
  }

  // Widget _listRoutes() {
  //   return FutureBuilder(
  //     future: _routeService.readMyRegisteredRoutes(),
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       if (!snapshot.hasData) {
  //         return LoadingWidget();
  //       } else {
  //         if (!snapshot.data["ok"]) {
  //           return AlertWidget(title: "Error", message: snapshot.data["message"]);
  //         } else {
  //           _routes = snapshot.data["value"];
  //           final seats = numAvalibleSeats(_routes);
  //           return ListView.builder(
  //             physics: BouncingScrollPhysics(),
  //             padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
  //             itemCount: _routes.length,
  //             itemBuilder: (BuildContext context, int i) {
  //               return CardWidget(route: _routes[i], seatsAvailable: seats[i]);
  //             }
  //           );
  //         }
  //       }
  //     }
  //   );
  // }

}

