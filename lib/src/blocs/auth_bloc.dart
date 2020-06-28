import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_carpooling/src/blocs/validators.dart';

class AuthBloc with Validators{

  final _emailController     = BehaviorSubject<String>(); 
  final _password1Controller = BehaviorSubject<String>();

  // Recuperar datos del Stream
  Stream<String> get emailStream     => _emailController.stream.transform(validarEmail); 
  Stream<String> get password1Stream => _password1Controller.stream.transform(validarPassword); 

  Stream<bool> get formValidStream =>
    CombineLatestStream.combine2(emailStream, password1Stream, (a, b) => true); 

  // Insertar datos al Stream  
  Function(String) get changeEmail     => _emailController.sink.add; 
  Function(String) get changePassword1 => _password1Controller.sink.add; 

  //Obtener el ultimo valor ingresado
  String get email => _emailController.value; 
  String get password1 => _password1Controller.value;

  dispose(){
    _emailController?.close();
    _password1Controller?.close();
  }
}