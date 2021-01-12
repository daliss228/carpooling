import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/routes/routes.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_carpooling/src/providers/ui_provider.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = new UserPreferences();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => RoutesProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => UIProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'EC'),
        ],
        title: 'Carpooling',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(cursorColor: OurColors.lightGreenishBlue, selectionHandleColor: OurColors.lightGreenishBlue, selectionColor: OurColors.lightGreenishBlue),
          primaryColor: OurColors.lightGreenishBlue,
          accentColor: OurColors.lightGreenishBlue
        ),
        initialRoute: prefs.token.toString().isNotEmpty ? 'after': 'login',
        routes: getAplicationRoutes(),// llama al map de Rutas definido para el proyecto.
      ),
    );
  }
  
}