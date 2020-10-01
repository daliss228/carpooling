import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/mode_page.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/photo_page.dart';
import 'package:flutter_carpooling/src/pages/login_page.dart';
import 'package:flutter_carpooling/src/pages/register_page.dart';
import 'package:flutter_carpooling/src/pages/usual_route_page.dart';
import 'package:flutter_carpooling/src/pages/registro_auto_page.dart';
import 'package:flutter_carpooling/src/pages/route_register_page.dart';
import 'package:flutter_carpooling/src/providers/type_user_provider/type_user_selector.dart';

Map<String, WidgetBuilder> getAplicationRoutes (){
  return <String, WidgetBuilder>{ 
    'home'      : (BuildContext context) => HomePage(),
    'login'     : (BuildContext context) => LoginPage(),
    'register'  : (BuildContext context) => RegisterPage(),
    'mode'      : (BuildContext context) => ModePage(),
    'usualRoute' : (BuildContext context) => UsualRoutePage(),
    'route'     : (BuildContext context) => RouteRegisterPage(),
    'regAuto'   : (BuildContext context) => RegistroAutoPage(),
    'photo'     : (BuildContext context) => PhotoPage(), 
    'selectMode': (BuildContext context) => TypeUserSelector(),
  };
}
