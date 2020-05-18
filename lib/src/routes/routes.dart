import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/login_pages.dart';

Map<String, WidgetBuilder> getAplicationRoutes (){
  return <String, WidgetBuilder>{ 
        '/': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => LoginPage()
      };
}
