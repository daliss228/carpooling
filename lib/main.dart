import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/routes/routes.dart';
import 'package:flutter_carpooling/src/blocs/provider_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Thema;
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final prefs = new PreferenciasUsuario();
    return ProviderAuthBloc(
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
          primaryColor: Thema.OurColors.lightGreenishBlue,
          primarySwatch: Colors.blue,
        ),
        initialRoute: prefs.token.toString().isNotEmpty ? 'home': 'login',
        routes: getAplicationRoutes(),// llama al map de Rutas definido para el proyecto.
      ),
    );
  }
}