import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/routes/routes.dart';
import 'package:flutter_carpooling/src/blocs/provider_bloc.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Thema;
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
        title: 'Carpooling',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Thema.Colors.loginGradientEnd,
          primarySwatch: Colors.blue,
        ),
        initialRoute: prefs.token.toString().isNotEmpty ? 'home': 'login',
        routes: getAplicationRoutes(),//llama al map de Rutas definido para el proyecto.
      ),
    );
  }
}