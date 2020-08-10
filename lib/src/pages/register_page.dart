
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';


import 'package:flutter_carpooling/src/utils/utils.dart' as utils;
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/widgets/input_widget.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Tema;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final usuarioProvider = new UsuarioService(); // Llamando al provider de usuario
  final user = new UserModel(); 
  final prefs = new PreferenciasUsuario();
  final formRegisterKey = GlobalKey<FormState>();// Declarando la llave del formulario
  String _password= ''; 
  bool isloading = false;



  @override
  Widget build(BuildContext context) {
    

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: screenSize.width * 0.3,
                bottom: screenSize.width * 1.2,
                child: CircleWidget(radius: screenSize.width * 0.9, colors:  [Color(0xFF02d2ec), Color(0xFF0393A5)])
              ),
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(30.0),
                            width: screenSize.width * 0.8,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: screenSize.height * 0.05,),
                                Text('Registrar usuario', style: TextStyle(fontSize: 40.0, fontFamily: 'WorkSansSemiBold', fontWeight: FontWeight.w300), ),
                                SizedBox(height: screenSize.height * 0.004,),
                                Text(
                                  'Bienvenido, ¿Sabías qué en Quito viajan 1.3 personas por auto? Registrate y comparte con tus amigos y vecinos.',
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,),
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.04,),
                      Form(
                        key: formRegisterKey,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Card(
                                elevation: 2.0,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)
                                ),
                                child: Container(
                                  width: screenSize.width * 0.8,
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                    children: <Widget>[
                                      InputWidget(
                                        label: 'Nombre', 
                                        textCapitalization: TextCapitalization.sentences,
                                        icono: FontAwesomeIcons.user,
                                        onSaved: (value){ user.name = value;  },
                                        validator: (value){
                                          if(RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value)){
                                            return null;
                                          }
                                          return 'Nombre de usuario Invalido';
                                        },
                                      ),
                                      SizedBox(height: 10.0,),
                                      _separador(screenSize),
                                      InputWidget(
                                        label: 'Apellido', 
                                        textCapitalization: TextCapitalization.sentences,
                                        icono: FontAwesomeIcons.user,
                                        onSaved: (value) => user.lastName = value,
                                        validator: (value){
                                          if(RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value)){
                                            return null;
                                          }
                                          return 'Apellido de usuario Invalido';
                                        },
                                      ),
                                      SizedBox(height: 10.0,),
                                      _separador(screenSize),
                                      InputWidget(
                                        label: 'Cédula', 
                                        icono: FontAwesomeIcons.list,
                                        inputType: TextInputType.number,
                                        onSaved: (value) => user.ci = value,
                                        validator: (value){
                                          if(utils.isNumeric(value) && value.length == 10){
                                            return null; 
                                          }
                                          return 'La cedula ingresada no es valida';
                                        },
                                      ),
                                      SizedBox(height: 10.0,),
                                      _separador(screenSize),

                                      InputWidget(
                                        label: 'Email', 
                                        icono: FontAwesomeIcons.envelope, 
                                        inputType: TextInputType.emailAddress,
                                        onSaved: (value) => user.email = value ,
                                        validator: (value){
                                          Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regExp = new RegExp(pattern); 
                                          if(regExp.hasMatch(value)){
                                            return null; 
                                          }
                                          return 'Ingrese un email valido';
                                        },
                                      ),

                          
                                      SizedBox(height: 10.0,),
                                      _separador(screenSize), 

                                      InputWidget(
                                        label: 'Teléfono', 
                                        icono: FontAwesomeIcons.list,
                                        inputType: TextInputType.number,
                                        onSaved: (value) => user.phone = value,
                                        validator: (value){
                                          if(utils.isNumeric(value) && value.length == 10){
                                            return null; 
                                          }
                                          return 'El número ingresado no es valido';
                                        },
                                      ),
                                      SizedBox(height: 10.0,),
                                      _separador(screenSize),

                                      InputWidget(
                                        label: 'Contraseña', 
                                        icono: FontAwesomeIcons.lock,
                                        obscureText: true, 
                                        inputType: TextInputType.emailAddress,
                                        onSaved: (value)=>_password = value,
                                        validator: (value){
                                          if(value.length > 6 ){
                                            _password = value; 
                                            return null;
                                          }
                                          return 'Ingrese una contraseña mayor a 6 caracteres'; 
                                        },
                                      ),
                                      
                                      
                                      SizedBox(height: 10.0,),
                                      _separador(screenSize), 
                                      InputWidget(
                                        label: 'Verifica tu contraseña', 
                                        icono: FontAwesomeIcons.lock,
                                        obscureText: true, 
                                        inputType: TextInputType.emailAddress,
                                        validator: (value){
                                          if(_password == value){
                                            return null; 
                                          }
                                          return 'Las contraseñas no coinciden';
                                        },
                                      ), 
                                      SizedBox(height: 10.0,),

                                    ],
                                  ),
                                ),
                              )
                            ), 
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      _botones(),
                    ],
                  )
                ),
              ), 
              Positioned(
              left: 10.0,
              top: 10.0,
              child: SafeArea(
                child: CupertinoButton(
                  padding: EdgeInsets.all(10.0),
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.black26,
                  child: Icon(Icons.arrow_back, color: Colors.white,), 
                  onPressed: () => Navigator.pushReplacementNamed(context, 'login'),

                ),
              )
            ), 
              isloading? LoadingWidget(): Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botones(){
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[  
            MaterialButton(
              color: Color(0xFF0393A5),
              highlightColor: Colors.transparent,
              splashColor: Tema.OurColors.lightGreenishBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "REGISTRAME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "WorkSansBold"
                  ),
                ),
              ),
              onPressed: ()async{
                await _registrar();
                setState(() {
                  isloading = false;
                });
              }
            ),
          
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(
                    fontSize: 16.0, 
                    color: Colors.black54, 
                  ),
                ), 
                CupertinoButton(
                  child: Text(
                    'Inicia Sesión', 
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.deepPurple
                    ),
                  ), 
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, 'login');
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future _registrar() async{
    
    if(!formRegisterKey.currentState.validate()) return;
    if(isloading)return;
    formRegisterKey.currentState.save(); 
    Map info;
    setState(() {
      isloading = true; 
    });

    Map result = await usuarioProvider.searchCi(user.ci);

    if(result['ok']){
     info = await usuarioProvider.singUp(user.email, _password);
     user.uidGroup = result['uidGroup']; 
    } else{
      mostrarAlerta(context, 'Ups!', result['mensaje']); 
      return; 
    }

    setState(() {
      isloading = false; 
    });

    if(info['ok']){
      user.uid = prefs.uid; 
      usuarioProvider.userDb(user); 
      Navigator.pushReplacementNamed(context, 'photo', arguments: '');
    }else{
      mostrarAlerta(context, 'Ups!', info['mensaje']); 
    }
  }

  Widget _separador(Size screenSize){
    return Container(
      width: screenSize.width * 0.75,
      height: 1.0,
      color: Colors.grey,
    );
  }
}