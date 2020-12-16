import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/helpers.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/widgets/input_widget.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/providers/ui_provider.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/services/auth_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _user = UserModel(); 
  final _prefs  = UserPreferences();
  final _authService = AuthService();
  final _formRegisterKey = GlobalKey<FormState>();

  String _password= ''; 
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
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
                left: responsiveScreen.wp(50),
                top: responsiveScreen.hp(60),
                child: FadeInRight(
                  child: CircleWidget(radius: responsiveScreen.wp(60), colors: [OurColors.initialPurple, OurColors.finalPurple.withOpacity(0.5)]))
              ),
              Positioned(
                left: responsiveScreen.wp(30),
                top: responsiveScreen.hp(75),
                child: FadeInRight(
                  delay: Duration(milliseconds: 1000),
                  child: CircleWidget(radius: responsiveScreen.wp(60), colors: [OurColors.initialPurple, OurColors.finalPurple.withOpacity(0.1)]))
              ),
              Positioned(
                left: responsiveScreen.wp(50),
                top: responsiveScreen.hp(75),
                child: FadeInRight(
                  delay: Duration(milliseconds: 500),
                  child: CircleWidget(radius: responsiveScreen.wp(40), colors:  [OurColors.lightBlue, OurColors.lightGreenishBlue.withOpacity(0.8)]))
              ),
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(responsiveScreen),
                      _form(responsiveScreen)
                    ],
                  ) 
                ),
              ), 
              SafeArea(
                child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: CupertinoButton(
                    padding: EdgeInsets.all(10.0),
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.black26,
                    child: Icon(Icons.arrow_back, color: Colors.white,), 
                    onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
                  ),
                ),
              ), 
              _isloading? LoadingWidget(): Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(Responsive responsiveScreen){
    return Row(
      children: [
        Expanded(child: Container()),
        Column(
          children: <Widget>[
            SizedBox(height: responsiveScreen.hp(3)),
            Container(
              width: responsiveScreen.wp(70),
              child: FadeInRight(
                child: Text(
                  'Registrar usuario', 
                  style: TextStyle(fontSize: responsiveScreen.ip(3.5), fontFamily: 'WorkSansMedium',), 
                  textAlign: TextAlign.end, 
                ),
              )),
            SizedBox(height: responsiveScreen.hp(2.5),),
            Container(
              width: responsiveScreen.wp(70),
              child: FadeInRight(
                child: Text(
                  'Bienvenido, ¿Sabías qué en Quito viajan 1.3 personas por auto?',
                  style: TextStyle(fontSize: responsiveScreen.ip(1.7), fontFamily: 'WorkSansLight'),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: responsiveScreen.wp(4),),
      ],
    );
  }

  Widget _form(Responsive responsiveScreen){
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[   
          SizedBox(height: responsiveScreen.hp(4)),
          Form(
            key: _formRegisterKey,
            child: Column(
              children: <Widget>[
                Center(
                  child: Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)
                    ),
                    child: Container(
                      width: responsiveScreen.wp(80),
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Column(
                        children: <Widget>[
                          InputWidget(
                            label: 'Nombre', 
                            textCapitalization: TextCapitalization.sentences,
                            icono: FontAwesomeIcons.user,
                            onSaved: (value){ _user.name = value;  },
                            validator: (value){
                              if(RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value)){
                                return null;
                              }
                              return 'El nombre no es válido';
                            },
                          ),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          _separator(responsiveScreen),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          InputWidget(
                            label: 'Apellido', 
                            textCapitalization: TextCapitalization.sentences,
                            icono: FontAwesomeIcons.user,
                            onSaved: (value) => _user.lastname = value,
                            validator: (value){
                              if(RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value)){
                                return null;
                              }
                              return 'El apellido no es válido!';
                            },
                          ),
                          SizedBox(height: responsiveScreen.hp(0.5)),
                          _separator(responsiveScreen),
                          SizedBox(height: responsiveScreen.hp(0.5)),
                          InputWidget(
                            label: 'Cédula', 
                            icono: FontAwesomeIcons.idCard,
                            inputType: TextInputType.number,
                            onSaved: (value) => _user.ci = value,
                            validator: (value){
                              if(isNumeric(value) && value.length == 10){
                                return null; 
                              }
                              return 'La cédula no es válida!';
                            },
                          ),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          _separator(responsiveScreen),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          InputWidget(
                            label: 'Email', 
                            icono: FontAwesomeIcons.envelope, 
                            inputType: TextInputType.emailAddress,
                            onSaved: (value) => _user.email = value ,
                            validator: (value){
                              Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern); 
                              if(regExp.hasMatch(value)){
                                return null; 
                              }
                              return 'El email no es válido!';
                            },
                          ),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          _separator(responsiveScreen),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          InputWidget(
                            label: 'Teléfono', 
                            icono: FontAwesomeIcons.list,
                            inputType: TextInputType.number,
                            onSaved: (value) => _user.phone = value,
                            validator: (value){
                              if(isNumeric(value) && value.length == 10){
                                return null; 
                              }
                              return 'El teléfono no es válido!';
                            },
                          ),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          _separator(responsiveScreen),
                          SizedBox(height: responsiveScreen.hp(0.5),),
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
                              return 'La contraseña es muy corta!'; 
                            },
                          ),
                          SizedBox(height: responsiveScreen.hp(0.5),),
                          _separator(responsiveScreen),
                          SizedBox(height: responsiveScreen.hp(0.5),), 
                          InputWidget(
                            label: 'Verifica tu contraseña', 
                            icono: FontAwesomeIcons.lock,
                            obscureText: true, 
                            validator: (value){
                              if(_password == value){
                                return null; 
                              }
                              return 'Las contraseñas no coinciden!';
                            },
                          ), 
                          SizedBox(height: responsiveScreen.hp(0.5),),
                        ],
                      ),
                    ),
                  )
                ), 
              ],
            ),
          ),
          SizedBox(height: responsiveScreen.hp(5),),
          _botones(responsiveScreen),
        ],
      )
    );
  }

  Widget _botones(Responsive responsiveScreen) {
    return Center(
      child: Column(
        children: <Widget>[  
          Consumer<UIProvider>(builder: (context, provider, child) {
            return MaterialButton(
              color: OurColors.lightGreenishBlue,
              highlightColor: Colors.transparent,
              splashColor: OurColors.lightGreenishBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                child: Text(
                  "REGISTRAME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsiveScreen.ip(1.5),
                    fontFamily: "WorkSansMedium"
                  ),
                ),
              ),
              onPressed: () async{
                await _userRegister(provider);
              }
            );
          }),
          SizedBox(height: responsiveScreen.hp(2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '¿Ya tienes una cuenta?',
                style: TextStyle(
                  fontSize: responsiveScreen.ip(1.7), 
                  fontFamily: "WorkSansLight",
                  color: Colors.black54,  
                ),
              ), 
              CupertinoButton(
                child: Text(
                  'Inicia Sesión', 
                  style: TextStyle(
                    fontSize: responsiveScreen.ip(1.7),
                    fontFamily: "WorkSansMedium",
                    color: OurColors.grayishWhite
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
    );
  }

  Future _userRegister(UIProvider uiProvider) async{
    if(!_formRegisterKey.currentState.validate()) return;
    _formRegisterKey.currentState.save(); 
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() { _isloading = true; });
    final resultCI = await _authService.searchCi(_user.ci);
    if(resultCI['ok']){
      _user.idGroup = _prefs.uidGroup; 
      final resultSingUp = await _authService.singUp(_user.email, _password);
      if (resultSingUp['ok']) {
        _user.status = true;
        _user.id = _prefs.uid; 
        _authService.createUser(_user); 
        final resultRegisterUser = await _authService.createUser(_user); 
        if (resultRegisterUser['ok']) {
          uiProvider.backArrow = false;
          Navigator.pushReplacementNamed(context, 'photo');
        } else {
          setState(() { _isloading = false; });
          showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, resultRegisterUser['message']);
        }
      } else {
        setState(() { _isloading = false; });
        showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, resultSingUp['message']); 
        return; 
      }
    } else{
      setState(() { _isloading = false; });
      showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, resultCI['message']); 
      return; 
    }
    setState(() {
      _isloading = false; 
    });
  }

  Widget _separator(Responsive responsiveScreen){
    return Container(
      width: responsiveScreen.wp(70),
      height: responsiveScreen.hp(0.1),
      color: Colors.grey,
    );
  }
}