import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/map_widget.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/providers/ui_provider.dart';
import 'package:flutter_carpooling/src/utils/search_delegate.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/widgets/geocoder_widget.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';

class UsualRoutePage extends StatefulWidget {
  @override
  _UsualRoutePageState createState() => _UsualRoutePageState();
}

class _UsualRoutePageState extends State<UsualRoutePage> {
  
  final _prefs = UserPreferences();
  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              _map(responsiveScreen),
              _circularButtons(responsiveScreen),
              _containerInfo(responsiveScreen),
              _saveButton(responsiveScreen)
            ],
          ),
        ],
      )
    );
  }

  Widget _address(Responsive responsiveScreen) {
    return Row(
      children: [
        FaIcon(FontAwesomeIcons.mapMarkerAlt, size: responsiveScreen.ip(3.0), color: Colors.white),
        SizedBox(width: responsiveScreen.wp(3.0)),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿A dónde vas?', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.7), color: OurColors.grayishWhite)),
              GeodecoderWidget(color: Colors.white),
            ],
          ),
        )
      ],
    );
  }

  Widget _map(Responsive responsiveScreen){
    return Container(
      width: double.infinity,
      height: responsiveScreen.hp(100),
      child: MapWidget()
    ); 
  }

  Widget _circularButtons(Responsive responsiveScreen) {
    return SafeArea(
      child: Consumer<UIProvider>(builder: (context, provider, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            provider.backArrow 
            ? Container(
              margin: EdgeInsets.all(15.0),
              child: CupertinoButton(
                color: Colors.black26,
                padding: EdgeInsets.all(10.0),
                borderRadius: BorderRadius.circular(30.0),
                child: Icon(Icons.arrow_back, color: Colors.white, size: responsiveScreen.ip(2.5)),
                onPressed: () => Navigator.pushReplacementNamed(context, 'home'),
              ),
            ) 
            : Container(),
            Container(
              margin: EdgeInsets.all(15.0),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: OurColors.darkPurple,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => showSearch(context: context, delegate: DataSearch()),
                child: Icon(Icons.search, color: Colors.white, size: responsiveScreen.ip(2.5)),
              )
            ),
          ],
        );
      }),
    );
  }

  Widget _containerInfo(Responsive responsiveScreen){
    return FadeInUp(
      child: Column(
        children: [
          Container(
            height: responsiveScreen.hp(86),
            width: double.infinity,
          ),
          Container(
            height: responsiveScreen.hp(14),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0)
              ),
              gradient: LinearGradient(
                colors: [OurColors.initialPurple, OurColors.finalPurple],
                begin: FractionalOffset(0.0, 0.1),
                end: FractionalOffset(0.0, 0.99),
              ),
            ),
            child: _address(responsiveScreen)
          ),
        ],
      ),
    ); 
  }

  Widget _saveButton(Responsive responsiveScreen) {
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: responsiveScreen.hp(83.5),
            width: double.infinity,
          ),
          Container(
            height: responsiveScreen.hp(5),
            decoration: BoxDecoration(
              color: OurColors.lightGreenishBlue,
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            child: Consumer3<MapProvider, RoutesProvider, UIProvider>(builder: (context, mapProvider, routesProvider, uiProvider, child) {
              return MaterialButton(
                highlightColor: Colors.transparent,
                splashColor: OurColors.lightGreenishBlue,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text("CONTINUAR", style: TextStyle( color: Colors.white, fontSize: responsiveScreen.ip(1.5), fontFamily: "WorkSansMedium")),
                ),
                onPressed: () async {
                  if (mapProvider.geolocation != null){
                    final result = await _userService.addLatLng2Pax(mapProvider.geolocation);
                    if (result["ok"]) {
                      _prefs.lat = mapProvider.geolocation.lat.toString();
                      _prefs.lng = mapProvider.geolocation.lng.toString();
                      await routesProvider.readGroupRoute();
                      if (uiProvider.backArrow) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        Navigator.pushReplacementNamed(context, 'after');
                      }
                    } else {
                      showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, result['message']);  
                    }
                  } else {
                    showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, 'Ingresa una ruta');
                  }
                }
              );
            })
          ),
        ],
      ),
    );
  }

}