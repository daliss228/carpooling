import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/mode_page.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/photo_page.dart';
import 'package:flutter_carpooling/src/pages/login_page.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
import 'package:flutter_carpooling/src/pages/register_page.dart';
import 'package:flutter_carpooling/src/pages/ruta_usual_page.dart';
import 'package:flutter_carpooling/src/pages/route_detail_page.dart';
import 'package:flutter_carpooling/src/pages/registro_auto_page.dart';
import 'package:flutter_carpooling/src/pages/route_register_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes (){
  return <String, WidgetBuilder>{ 
    'home'      : (BuildContext context) => HomePage(),
    'login'     : (BuildContext context) => LoginPage(),
    'register'  : (BuildContext context) => RegisterPage(),
    'mode'      : (BuildContext context) => ModePage(),
    'rutaUsual' : (BuildContext context) => RutaUsualPage(),
    'profile'   : (BuildContext context) => ProfilePage(),
    'viaje'     : (BuildContext context) => RouteRegisterPage(),
    'regAuto'   : (BuildContext context) => RegistroAutoPage(),
    'route'     : (BuildContext context) => RouteDetailPage(),
    'photo'     : (BuildContext context) => PhotoPage()
  };
}
