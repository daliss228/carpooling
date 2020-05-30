import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/mode_page.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/viaje_page.dart';
// import 'package:flutter_carpooling/src/pages/image_page.dart';
import 'package:flutter_carpooling/src/pages/login_pages.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
import 'package:flutter_carpooling/src/pages/ruta_usual_page.dart';
import 'package:flutter_carpooling/src/pages/route_detail_page.dart';
import 'package:flutter_carpooling/src/pages/registro_auto_page.dart';



Map<String, WidgetBuilder> getAplicationRoutes (){
  return <String, WidgetBuilder>{ 
        '/'     : (BuildContext context) => HomePage(),
        'mode' : (BuildContext context) => ModePage(),
        'rutaUsual' : (BuildContext context) => RutaUsualPage(),
        'profile' : (BuildContext context) => ProfilePage(), 
        'login': (BuildContext context) => LoginPage(),
        'viaje' : (BuildContext context) => ViajesPage(),
        'regAuto' : (BuildContext context) => RegistroAutoPage(),
        'route': (BuildContext context) => RouteDetallePage()
        // 'image': (BuildContext context) => ImageCapturePage()
      };
}
