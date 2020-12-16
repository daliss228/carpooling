import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/mode_page.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/photo_page.dart';
import 'package:flutter_carpooling/src/pages/login_page.dart';
import 'package:flutter_carpooling/src/pages/register_page.dart';
import 'package:flutter_carpooling/src/pages/usual_route_page.dart';
import 'package:flutter_carpooling/src/pages/auto_register_page.dart';
import 'package:flutter_carpooling/src/pages/route_register_page.dart';
import 'package:flutter_carpooling/src/widgets/after_layout_widget.dart';

Map<String, WidgetBuilder> getAplicationRoutes (){
  return <String, WidgetBuilder>{ 
    'home'      : (BuildContext context) => HomePage(),
    'login'     : (BuildContext context) => LoginPage(),
    'register'  : (BuildContext context) => RegisterPage(),
    'photo'     : (BuildContext context) => PhotoPage(), 
    'mode'      : (BuildContext context) => ModePage(),
    'after'     : (BuildContext context) => AfterLayoutWidget(),
    'usualRoute': (BuildContext context) => UsualRoutePage(),
    'route'     : (BuildContext context) => RouteRegisterPage(),
    'auto'      : (BuildContext context) => AutoRegisterPage(),
  };
}
