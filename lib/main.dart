import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/providers/user_provider/user_provider.dart';
import 'package:flutter_carpooling/src/providers/arguments_provider/arguments_provider.dart';
import 'package:flutter_carpooling/src/providers/type_user_provider/type_user_info_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // name: 'carpooling-admin',
  //   options: FirebaseOptions(
  //     appId: '1:502370531875:web:4789d48f0eb2c1438d8f96',
  //     apiKey: 'AIzaSyCPhQNoAfJsuioyoB12GwKIqRH49cPCfAI',
  //     messagingSenderId: '502370531875',
  //     projectId: 'dev-carpooling'
  //   )
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final initialPage = 'selectMode'; 
  @override
  Widget build(BuildContext context) {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = new UserPreferences();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TypeUser()),
        ChangeNotifierProvider(create: (context) => UserInfo()),
        ChangeNotifierProvider(create: (context) => ArgumentsInfo()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'EC'),
        ],
        title: 'Carpooling',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: OurColors.lightGreenishBlue,
          primarySwatch: Colors.blue,
        ),
        initialRoute: prefs.token.toString().isNotEmpty ? 'selectMode': 'login',
        routes: getAplicationRoutes(),// llama al map de Rutas definido para el proyecto.
      ),
    );
  }
  
}