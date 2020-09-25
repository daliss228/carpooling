import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/widgets/input_widget.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Tema;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final usuarioService = new UserService(); // -------------------------
  final formRegisterKey = GlobalKey<FormState>();
  bool isloading = false; 
  String _password = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _responsiveScreen = new Responsive(context);
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
                right: _responsiveScreen.wp(50),
                top: _responsiveScreen.hp(60),
                child: FadeInLeft(
                  child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue.withOpacity(0.3)]))
              ),
              Positioned(
                right: _responsiveScreen.wp(30),
                top: _responsiveScreen.hp(75),
                child: FadeInLeft(
                  delay: Duration(milliseconds: 1000),
                  child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue.withOpacity(0.6)]))
              ),
              Positioned(
                right: _responsiveScreen.wp(50),
                top: _responsiveScreen.hp(75),
                child: FadeInLeft(
                  delay: Duration(milliseconds: 500),
                  child: CircleWidget(radius: _responsiveScreen.wp(40), colors: [Tema.OurColors.initialPurple, Tema.OurColors.finalPurple.withOpacity(0.8)]))
              ),
              SingleChildScrollView(
                child: SafeArea(
                  child: _form(_responsiveScreen), 
                )
              ),
              isloading? LoadingWidget():Container(), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(Responsive _responsiveScreen){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            SizedBox(width: _responsiveScreen.wp(5),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: _responsiveScreen.hp(10),),
                Container(child: FadeInLeft(child: Text('Inicio de Sesión', style: TextStyle(fontSize: _responsiveScreen.ip(3.5), fontFamily: 'WorkSansMedium'),))),
                SizedBox(height: _responsiveScreen.hp(3),),
                Container(
                  width: _responsiveScreen.wp(70),
                  child: FadeInLeft(
                    child: Text(
                      '¿Sabías qué Quito tiene un porcentaje de emisión (CO2) mayor al de Guayaquil?',
                      style: TextStyle(fontSize: _responsiveScreen.ip(1.5), fontFamily: 'WorkSansLight'),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: Container())
          ],
        ),

        SizedBox(height: _responsiveScreen.hp(10),),
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
                  width: _responsiveScreen.wp(80),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Form(
                    key: formRegisterKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: <Widget>[
                          InputWidget(
                            label: 'Email', 
                            icono: FontAwesomeIcons.envelope, 
                            inputType: TextInputType.emailAddress,
                            onSaved: (value) => _email = value,
                            validator: (value){
                              Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern);
                              if(regExp.hasMatch(value)) return null;
                              return 'Ingrese un email valido';
                            },
                          ),
                          SizedBox(height: _responsiveScreen.hp(1),),
                          _separador(_responsiveScreen), 
                          SizedBox(height: _responsiveScreen.hp(1),),
                          InputWidget(
                            label: 'Contraseña', 
                            icono: FontAwesomeIcons.lock,
                            obscureText: true,
                            onSaved: (value) => _password = value,
                            validator: (value){
                              if(value.length > 6){
                                return null;
                              }
                              return 'Ingrese una contraseña mayor a 6 caracteres'; 
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ), 
          ],
        ),
        SizedBox(height: _responsiveScreen.hp(5),),
        _botones(_responsiveScreen), 
      ],
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
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "INGRESAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _responsiveScreen.ip(1.5),
                    fontFamily: "WorkSansMedium"),
                ),
              ),
              onPressed: () async{
                await _login(context); 
                setState(() {isloading = false;});
              }
            ),
            SizedBox(height: _responsiveScreen.hp(2),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿Eres un usuario nuevo?',
                  style: TextStyle(
                    fontSize: _responsiveScreen.ip(1.4), 
                    fontFamily: "WorkSansLight",
                    color: Colors.black54, 
                  ),
                ), 
                CupertinoButton(
                  child: Text(
                    'Regístrate', 
                    style: TextStyle(
                      fontSize: _responsiveScreen.ip(1.4),
                      fontFamily: "WorkSansMedium",
                      color: Tema.OurColors.finalPurple
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

 _login(BuildContext context) async {
   if( !formRegisterKey.currentState.validate()) return;
   formRegisterKey.currentState.save();
   setState(() { isloading = true; });
   dynamic response =  await usuarioService.signIn(_email, _password);
   setState(() { isloading = false; });
   if(response['ok'] == true){
     Navigator.pushReplacementNamed(context, 'selectMode');
   }else{
     mostrarAlerta(context, 'Ups!', response['message']); 
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