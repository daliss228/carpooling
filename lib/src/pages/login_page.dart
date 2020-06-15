import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/blocs/provider_bloc.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/widgets/input_widget.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Tema;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final usuarioProvider = new UsuarioService();
  bool isloading = false; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = ProviderAuthBloc.of(context);
    final screenSize = MediaQuery.of(context).size; 
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: screenSize.width * 0.3,
                top: screenSize.width * 1.2,
                child: CircleWidget(radius: screenSize.width * 0.9, colors: [Color(0xFF02d2ec), Color(0xFF0393A5)])
              ),
              SingleChildScrollView(
                child: SafeArea(
                  child: _form(screenSize, loginBloc), 
                )
              ),
              isloading? LoadingWidget():Container(), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(Size screenSize, AuthBloc loginBloc){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              width: screenSize.width * 0.6,
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height * 0.05,),
                  Text('Inicio de Sesión', style: TextStyle(fontSize: 40.0, fontFamily: 'WorkSansSemiBold', fontWeight: FontWeight.w300),),
                  SizedBox(height: screenSize.height * 0.004,),
                  Text(
                    '¿Sabías qué Quito tiene un porcentaje de emisión (C02) mayor al de Guayaquil?',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300,),
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: screenSize.height * 0.04,),
        Column(
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
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      
                      StreamBuilder(
                        stream: loginBloc.emailStream ,
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          return InputWidget(
                            label: 'Email', 
                            icono: FontAwesomeIcons.envelope, 
                            inputType: TextInputType.emailAddress,
                            onChanged: (value) => loginBloc.changeEmail(value),
                            errorLabel: snapshot.error,
                          );
                        },
                      ),
                      SizedBox(height: 10.0,),
                      _separador(screenSize), 
                      StreamBuilder(
                        stream: loginBloc.password1Stream,
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          return InputWidget(
                            label: 'Contraseña', 
                            icono: FontAwesomeIcons.lock,
                            obscureText: true, 
                            onChanged: (value) => loginBloc.changePassword1(value),
                            errorLabel: snapshot.error,
                          );
                        },
                      ),
                      
                    ],
                  ),
                ),
              )
            ), 
          ],
        ),
        SizedBox(height: 30.0,),
        _botones(loginBloc), 
      ],
    );
  }

  Widget _botones(AuthBloc bloc){
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            StreamBuilder(
              stream: bloc.formValidStream ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return MaterialButton(
                  color: Color(0xFF0393A5),
                  highlightColor: Colors.transparent,
                  splashColor: Tema.Colors.loginGradientEnd,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "INGRESAR",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed: snapshot.hasData? (){ 
                    if(isloading) return; 
                    _login(context, bloc);
                  }: (){
                    mostrarAlerta(context, 'Error al iniciar sesion','Ingrese correctamente los datos'); 
                  },
                );
              },
            ),
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿Eres un usuario nuevo?',
                  style: TextStyle(
                    fontSize: 16.0, 
                    color: Colors.black54, 
                  ),
                ), 
                CupertinoButton(
                  child: Text(
                    'Regístrate', 
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.deepPurple
                    ),
                  ), 
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, 'register');
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }

 _login(BuildContext context, AuthBloc bloc) async {

   setState(() {
     isloading= true;
   });
   
   Map info = await usuarioProvider.login(bloc.email, bloc.password1);

   setState(() {
     isloading = false;
   });

   if(info['ok']){
     Navigator.pushReplacementNamed(context, 'home');
   }else{
     mostrarAlerta(context, 'Error al iniciar sesion', info['mensaje']); 
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