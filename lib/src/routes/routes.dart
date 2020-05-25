import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
import 'package:flutter_carpooling/src/pages/login_pages.dart';
import 'package:flutter_carpooling/src/pages/ruta_usual_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes (){
  return <String, WidgetBuilder>{ 
        '/'         : (BuildContext context) => HomePage(),
        'rutaUsual' : (BuildContext context) => RutaUsualPage(),
        'profile' : (BuildContext context) => ProfilePage(), 
        'login': (BuildContext context) => LoginPage()
      };
}
