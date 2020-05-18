import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes (){
  return <String, WidgetBuilder>{ 
        '/'       : (BuildContext context) => HomePage(),
        'profile' : (BuildContext context) => ProfilePage(), 
        

      };
}
