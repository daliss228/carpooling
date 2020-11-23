import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:flutter_carpooling/src/widgets/rectangle_widget.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';
import 'package:flutter_carpooling/src/providers/arguments_provider.dart';

class ModePage extends StatefulWidget {

  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {

  final _prefs = UserPreferences(); 

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget> [
            _backgroundMode(responsiveScreen),
            Positioned(
              top: responsiveScreen.hp(30),
              left: responsiveScreen.wp(35),
              child: FadeIn(
                duration: Duration(milliseconds: 800),
                child: Text('QUIERO SER:', style: TextStyle(fontSize: responsiveScreen.ip(2.0), fontFamily: "WorkSansBold", color: Colors.white))
              )
            ),
            Positioned(
              top: responsiveScreen.hp(50),
              child: Container(
                width: responsiveScreen.wp(100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    _userModeButton('pasajero.png', 'PASAJERO', OurColors.initialPurple, context, responsiveScreen),
                    SizedBox(width: responsiveScreen.wp(10)),
                    _userModeButton('conductor.png', 'CONDUCTOR', OurColors.lightGreenishBlue, context, responsiveScreen)
                  ],
                ),
              ),
            )
          ],
        )
      )
    ); 
  }

  Widget _backgroundMode(Responsive responsiveScreen){
    return Container(
      height: responsiveScreen.hp(100),
      width: responsiveScreen.wp(100),
      child: Stack(
        children: <Widget> [
          Positioned(
            child: SlideInLeft(
              duration: Duration(milliseconds: 800),
              child: RectangleWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], height: responsiveScreen.hp(100), width: responsiveScreen.wp(50),)
            )
          ), 
          Positioned(
            left: responsiveScreen.wp(50),
            child: SlideInRight(
              duration: Duration(milliseconds: 800),
              child: RectangleWidget(colors: [OurColors.initialPurple, OurColors.finalPurple], height: responsiveScreen.hp(100), width: responsiveScreen.wp(50),)
            )
          ), 
        ],
      ),
    );
  }

  Widget _userModeButton(String imagen, String usuario, Color colorBtn, BuildContext context, Responsive responsiveScreen) {
    final mapProvider = Provider.of<MapProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final argumentsInfo = Provider.of<ArgumentsInfo>(context);
    final routesProvider = Provider.of<RoutesProvider>(context);
    return FadeInUp(
      delay: Duration(milliseconds: 200),
      duration: Duration(milliseconds: 2000),
      child: GestureDetector(
        onTap: () async {
          _prefs.mode = usuario;
          mapProvider.clearValues();
          if (usuario == 'CONDUCTOR' ) {
            if (userProvider.user.car != null) {
              routesProvider.orderMyDriverRoutes();
              Navigator.pushReplacementNamed(context, 'home');
            } else {
              Navigator.pushReplacementNamed(context, 'regAuto', arguments: true);
            }
          } else {
            if(userProvider.user.coordinates != null){
              routesProvider.orderMyPaxRoutes();
              Navigator.pushReplacementNamed(context, 'home');
            }else{
              argumentsInfo.backArrowUserRoute = false;
              Navigator.pushReplacementNamed(context, 'usualRoute');
            }
          }
        },
        child: Container(
          height: responsiveScreen.hp(24),
          width: responsiveScreen.wp(39),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: (responsiveScreen.wp(38)/2) - (responsiveScreen.hp(13) /2),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: responsiveScreen.ip(6),
                  child: Image(
                    image: AssetImage('assets/img/$imagen'),
                    height: responsiveScreen.hp(13),
                  ),
                ),
              ),
              Positioned(
                top: responsiveScreen.hp(12),
                left: (responsiveScreen.wp(38)/2 - responsiveScreen.wp(35)/2),
                child: Container( 
                  height: responsiveScreen.hp(8),
                  width: responsiveScreen.wp(35),
                  margin: EdgeInsets.all(responsiveScreen.ip(0.5)),
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.5),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(0.0, 10.0)
                      )
                    ],
                    color: colorBtn,
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Center(child: Text(usuario, style: TextStyle(fontSize: responsiveScreen.ip(1.5), fontFamily: "WorkSansBold", color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}