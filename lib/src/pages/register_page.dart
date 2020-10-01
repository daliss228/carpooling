
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';


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

  final usuarioProvider = new UserService(); // Llamando al provider de usuario
  final user = new UserModel(); 
  final prefs = new UserPreferences();
  final formRegisterKey = GlobalKey<FormState>();// Declarando la llave del formulario
  String _password= ''; 
  bool isloading = false;



  @override
  Widget build(BuildContext context) {
    final _responsiveScreen = new Responsive(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: _responsiveScreen.wp(50),
              top: _responsiveScreen.hp(60),
              child: FadeInRight(
                child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [Tema.OurColors.initialPurple, Tema.OurColors.finalPurple.withOpacity(0.5)]))
            ),
            Positioned(
              left: _responsiveScreen.wp(30),
              top: _responsiveScreen.hp(75),
              child: FadeInRight(
                delay: Duration(milliseconds: 1000),
                child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [Tema.OurColors.initialPurple, Tema.OurColors.finalPurple.withOpacity(0.1)]))
            ),
            Positioned(
              left: _responsiveScreen.wp(50),
              top: _responsiveScreen.hp(75),
              child: FadeInRight(
                delay: Duration(milliseconds: 500),
                child: CircleWidget(radius: _responsiveScreen.wp(40), colors:  [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue.withOpacity(0.8)]))
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(_responsiveScreen),
                    _form(_responsiveScreen)
                  ],
                ) 
              ),
            ), 
            Positioned(
              left: _responsiveScreen.wp(5),
              top: _responsiveScreen.hp(5),
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
    );
  }

  Widget _header(Responsive _responsiveScreen){
    return Row(
      children: [
        Expanded(child: Container()),
        Column(
          children: <Widget>[
            SizedBox(height: _responsiveScreen.hp(5),),
            Container(
              width: _responsiveScreen.wp(70),
              child: FadeInRight(
                child: Text(
                  'Registrar usuario', 
                  style: TextStyle(fontSize: _responsiveScreen.ip(3.5), fontFamily: 'WorkSansMedium',), 
                  textAlign: TextAlign.end, 
                ),
              )),
            SizedBox(height: _responsiveScreen.hp(2.5),),
            Container(
              width: _responsiveScreen.wp(70),
              child: FadeInRight(
                child: Text(
                  'Bienvenido, ¿Sabías qué en Quito viajan 1.3 personas por auto?',
                  style: TextStyle(fontSize: _responsiveScreen.ip(1.5), fontFamily: 'WorkSansLight'),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: _responsiveScreen.wp(4),),
      ],
    );
  }

  Widget _form(Responsive _responsiveScreen){
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          SizedBox(height: _responsiveScreen.hp(4),),
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
                      width: _responsiveScreen.wp(80),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                              return 'Nombre de usuario invalido';
                            },
                          ),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          _separador(_responsiveScreen),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          InputWidget(
                            label: 'Apellido', 
                            textCapitalization: TextCapitalization.sentences,
                            icono: FontAwesomeIcons.user,
                            onSaved: (value) => user.lastName = value,
                            validator: (value){
                              if(RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value)){
                                return null;
                              }
                              return 'Apellido de usuario invalido';
                            },
                          ),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          _separador(_responsiveScreen),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          InputWidget(
                            label: 'Cédula', 
                            icono: FontAwesomeIcons.idCard,
                            inputType: TextInputType.number,
                            onSaved: (value) => user.ci = value,
                            validator: (value){
                              if(utils.isNumeric(value) && value.length == 10){
                                return null; 
                              }
                              return 'La cédula ingresada no es válida';
                            },
                          ),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          _separador(_responsiveScreen),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
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
                              return 'Ingrese un email válido';
                            },
                          ),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          _separador(_responsiveScreen),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          InputWidget(
                            label: 'Teléfono', 
                            icono: FontAwesomeIcons.list,
                            inputType: TextInputType.number,
                            onSaved: (value) => user.phone = value,
                            validator: (value){
                              if(utils.isNumeric(value) && value.length == 10){
                                return null; 
                              }
                              return 'El número ingresado no es válido';
                            },
                          ),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          _separador(_responsiveScreen),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          InputWidget(
                            label: 'Contraseña', 
                            icono: FontAwesomeIcons.lock,
                            obscureText: true, 
                            onSaved: (value)=>_password = value,
                            validator: (value){
                              if(value.length > 6 ){
                                _password = value; 
                                return null;
                              }
                              return 'Ingrese una contraseña mayor a 6 caracteres'; 
                            },
                          ),
                          SizedBox(height: _responsiveScreen.hp(0.5),),
                          _separador(_responsiveScreen),
                          SizedBox(height: _responsiveScreen.hp(0.5),), 
                          InputWidget(
                            label: 'Verifica tu contraseña', 
                            icono: FontAwesomeIcons.lock,
                            obscureText: true, 
                            validator: (value){
                              if(_password == value){
                                return null; 
                              }
                              return 'Las contraseñas no coinciden';
                            },
                          ), 
                          SizedBox(height: _responsiveScreen.hp(0.5),),

                        ],
                      ),
                    ),
                  )
                ), 
              ],
            ),
          ),
          SizedBox(height: _responsiveScreen.hp(5),),
          _botones(_responsiveScreen),
        ],
      )
    );
  }

  Widget _botones(Responsive _responsiveScreen){
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[  
            MaterialButton(
              color: Tema.OurColors.lightGreenishBlue,
              highlightColor: Colors.transparent,
              splashColor: Tema.OurColors.lightGreenishBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                child: Text(
                  "REGISTRAME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _responsiveScreen.ip(1.5),
                    fontFamily: "WorkSansMedium"
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
          
            SizedBox(height: _responsiveScreen.hp(2),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(
                    fontSize: _responsiveScreen.ip(1.4), 
                    fontFamily: "WorkSansLight",
                    color: Colors.black54,  
                  ),
                ), 
                CupertinoButton(
                  child: Text(
                    'Inicia Sesión', 
                    style: TextStyle(
                      fontSize: _responsiveScreen.ip(1.4),
                      fontFamily: "WorkSansMedium",
                      color: Tema.OurColors.grayishWhite
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

  Widget _separador(Responsive _responsiveScreen){
    return Container(
      width: _responsiveScreen.wp(70),
      height: _responsiveScreen.hp(0.1),
      color: Colors.grey,
    );
  }
}