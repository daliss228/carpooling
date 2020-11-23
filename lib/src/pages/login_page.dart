import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/input_widget.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/services/auth_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final _authService = new AuthService();
  final _formLoginKey = GlobalKey<FormState>();
  bool _isloading = false; 
  String _password = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final _responsiveScreen = new Responsive(context);
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              right: _responsiveScreen.wp(50),
              top: _responsiveScreen.hp(60),
              child: FadeInLeft(
                child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [OurColors.lightBlue, OurColors.lightGreenishBlue.withOpacity(0.3)]))
            ),
            Positioned(
              right: _responsiveScreen.wp(30),
              top: _responsiveScreen.hp(75),
              child: FadeInLeft(
                delay: Duration(milliseconds: 1000),
                child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [OurColors.lightBlue, OurColors.lightGreenishBlue.withOpacity(0.6)]))
            ),
            Positioned(
              right: _responsiveScreen.wp(50),
              top: _responsiveScreen.hp(75),
              child: FadeInLeft(
                delay: Duration(milliseconds: 500),
                child: CircleWidget(radius: _responsiveScreen.wp(40), colors: [OurColors.initialPurple, OurColors.finalPurple.withOpacity(0.8)]))
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: _form(_responsiveScreen), 
              )
            ),
            _isloading ? LoadingWidget():Container(), 
          ],
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
                      style: TextStyle(fontSize: _responsiveScreen.ip(1.7), fontFamily: 'WorkSansLight'),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                )
              ],
            ),
            Expanded(child: Container())
          ],
        ),
        SizedBox(height: _responsiveScreen.hp(10)),
        Column(
          children: <Widget>[
            Center(
              child: Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)
                ),
                child: Container(
                  width: _responsiveScreen.wp(80),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Form(
                    key: _formLoginKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
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
                              return 'Ingrese un email válido';
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
              color: OurColors.lightGreenishBlue,
              highlightColor: Colors.transparent,
              splashColor: OurColors.lightGreenishBlue,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "INGRESAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _responsiveScreen.ip(1.5),
                    fontFamily: "WorkSansMedium"),
                ),
              ),
              onPressed: () async {
                await _login(context); 
                // setState(() {
                //   _isloading = true;
                // });
              }
            ),
            SizedBox(height: _responsiveScreen.hp(2),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¿Eres un usuario nuevo?',
                  style: TextStyle(
                    fontSize: _responsiveScreen.ip(1.7), 
                    fontFamily: "WorkSansLight",
                    color: Colors.black54, 
                  ),
                ), 
                CupertinoButton(
                  child: Text(
                    'Regístrate', 
                    style: TextStyle(
                      fontSize: _responsiveScreen.ip(1.7),
                      fontFamily: "WorkSansMedium",
                      color: OurColors.finalPurple
                    ),
                  ), 
                  onPressed: () {
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

  Future<void> _login(BuildContext context) async {
    if( !_formLoginKey.currentState.validate()) return;
    _formLoginKey.currentState.save();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() { _isloading = true; });
    final response =  await _authService.signIn(_email, _password);
    setState(() { _isloading = false; });
    if (response['ok'] == true) {
      Navigator.pushReplacementNamed(context, 'selectMode');
    } else {
      showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, response['message']); 
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