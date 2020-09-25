
import 'package:flutter/material.dart';


import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/providers/arguments_provider/arguments_provider.dart';
import 'package:flutter_carpooling/src/providers/type_user_provider/type_user_info_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider/user_provider.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Tema;
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/rectangle_widget.dart';
import 'package:provider/provider.dart';

class ModePage extends StatefulWidget {
  @override
  _ModePageState createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  final UserPreferences _prefs = new UserPreferences(); 
  @override
  Widget build(BuildContext context) {
    final typeUser = Provider.of<TypeUser>(context);
    final responsiveScreen = new Responsive(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget> [
            _backgroundMode(responsiveScreen),
            Positioned(
              top: responsiveScreen.hp(50),
              child: Container(
                width: responsiveScreen.wp(100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      duration: Duration(milliseconds: 2000),
                      child: _botonesModoUsuario('pasajero.png', 'PASAJERO', context, responsiveScreen, Tema.OurColors.initialPurple, typeUser)
                    ),
                    SizedBox(width: responsiveScreen.wp(10),),
                    FadeInUp(
                      delay: Duration(milliseconds: 600),
                      duration: Duration(milliseconds: 2000),
                      child: _botonesModoUsuario('conductor.png', 'CONDUCTOR', context, responsiveScreen, Tema.OurColors.lightGreenishBlue, typeUser)
                    ),
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
              child: RectangleWidget(colors: [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue], height: responsiveScreen.hp(100), width: responsiveScreen.wp(50),)
            )
          ), 
          Positioned(
            left: responsiveScreen.wp(50),
            child: SlideInRight(
              duration: Duration(milliseconds: 800),
              child: RectangleWidget(colors: [Tema.OurColors.initialPurple, Tema.OurColors.finalPurple], height: responsiveScreen.hp(100), width: responsiveScreen.wp(50),)
            )
          ), 
          Positioned(
            left: responsiveScreen.wp(49.5),
            child: RectangleWidget(colors: [Tema.OurColors.grayishWhite, Tema.OurColors.grayishWhite], height: responsiveScreen.hp(100), width: responsiveScreen.wp(1),)
          ), 
        ],
      ),
    );
  }

  Widget _botonesModoUsuario(String imagen, String usuario, BuildContext context, Responsive responsiveScreen, Color colorBtn, TypeUser typeUser) {
    final _userInfo = Provider.of<UserInfoP>(context);
    final _argumentsInfo = Provider.of<ArgumentsInfo>(context);
    UserModel userModel;
    return GestureDetector(
      onTap: () async {
        typeUser.setTypeUser = usuario;
        _prefs.mode = usuario;
        if( typeUser.getTypeuser == 'CONDUCTOR' ){
          userModel = _userInfo.getUserModel;
          if(userModel.car != null){
            Navigator.pushReplacementNamed(context, 'home');
          }else{
            Navigator.pushReplacementNamed(context, 'regAuto', arguments: true);
          }
        }else{
          userModel = _userInfo.getUserModel;
          if(userModel.coordinates != null){
            _prefs.lat = userModel.coordinates.lat.toString();
            _prefs.lng = userModel.coordinates.lng.toString();
            Navigator.pushReplacementNamed(context, 'home');
          }else{
            _argumentsInfo.setBackArrowUserRoute = false;
            Navigator.pushReplacementNamed(context, 'usualRoute');
          }
        }
      },
      // 
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
    );
  }
}

