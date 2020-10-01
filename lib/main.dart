import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/providers/arguments_provider/arguments_provider.dart';
import 'package:flutter_carpooling/src/providers/type_user_provider/type_user_info_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider/user_provider.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final initialPage = 'selectMode'; 
  @override
  Widget build(BuildContext context) {
  final prefs = new UserPreferences();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TypeUser()),
        ChangeNotifierProvider(create: (context) => UserInfoP()),
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