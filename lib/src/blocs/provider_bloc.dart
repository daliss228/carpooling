import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/blocs/Auth_bloc.dart';
export 'package:flutter_carpooling/src/blocs/Auth_bloc.dart';

class ProviderAuthBloc extends InheritedWidget{
  final authBloc = AuthBloc();

  ProviderAuthBloc({Key key, Widget child})
    :super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; // Al actualizarse debes notificar a sus hijos .?? aqui iria un condicional
  // hay que ocupar la instancia del Login Bloc, para que me regrese el estado de como esta el LoginBloc
  //Busca en dentro del contexto la instancia de LoginProvider 
  // Lo que va a hacer es tomar el contexto y dentro de el buscar un widget con el mismo provider 
  static AuthBloc of (BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProviderAuthBloc>().authBloc;
  }

}