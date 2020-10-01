import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/providers/user_provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carpooling/src/providers/type_user_provider/type_user_info_provider.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Tema;


class ProfilePage extends StatefulWidget {

  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  
  final TextStyle _styleTextHint = TextStyle(fontFamily: "WorkSansLight", fontSize: 16.0);
  final TextStyle _styleErrorText = TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935));
  final TextStyle _styleFAB = TextStyle(fontFamily: "WorkSansLight", fontSize: 14.0, color: Colors.black);
  final TextStyle _styleText = TextStyle(fontFamily: "WorkSansLight", fontSize: 16.0, color: Colors.black);
  final TextStyle _styleEditText = TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: 10.0);
  
  final UserService _userService = UserService();
  final UserService _authService = UserService();
  final UserPreferences _prefs = new UserPreferences(); 
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

  bool _keyboardOpen = false;
  bool _obscureTextPass = true;
  bool _activeEditPass = false;
  bool _activeEditName = false;
  bool _activeEditPhone = false;
  bool _activeEditLastname = false;

  @override
  void initState() {
    // visibilidad del teclado, lo que hace es detectar la visibilidad 
    // del teclado si es true oculta el FAB y si es false muestra el FAB
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() => _keyboardOpen = visible);
      },
    );
    super.initState();
  }

  @override
  void dispose() { 
    _ciController.clear();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _lastnameController.clear();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _screenSize = MediaQuery.of(context).size; 
    final _responsiveScreen = new Responsive(context);
    final _userInfo = Provider.of<UserInfoP>(context);
    UserModel _userModel = _userInfo.getUserModel;
    
    _ciController.text = _userModel.ci;
    _nameController.text = _userModel.name;
    _emailController.text = _userModel.email;
    _phoneController.text = _userModel.phone;
    _lastnameController.text = _userModel.lastName;

    return Scaffold(
      floatingActionButton: _keyboardOpen ? Container() : speedDial(_screenSize, context),
      body:Stack(
        children: [
          _backGround(_responsiveScreen),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      SizedBox(height: _responsiveScreen.hp(3),),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          FadeInRight(
                            child: Text(
                              'Mi Perfil', 
                              style: TextStyle(fontSize: _responsiveScreen.ip(4), fontFamily: 'WorkSansLight'),
                            ),
                          ),
                        ],
                      ),
                      _content(_responsiveScreen, _userModel, _userInfo)
                    ],
                  ),
                )
              ],
            ), 
          ),
        ],
      ),
      
       
    ); 
  }

  Widget _backGround(Responsive _responsiveScreen){
    return Container(
      height: _responsiveScreen.hp(100),
      width: _responsiveScreen.wp(100),
      child: Stack(
        children: [
          Positioned(
              right: _responsiveScreen.wp(75),
              child: FadeInLeft(child: BackgoundWidget(colors: [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(34),))
            ),
            Positioned(
              top: _responsiveScreen.hp(1),
              right: _responsiveScreen.wp(75),
              child: FadeInLeft(
                 delay: Duration(milliseconds: 500),
                child: BackgoundWidget(sizeWidget: _responsiveScreen.hp(30), colors: [Tema.OurColors.initialPurple, Tema.OurColors.finalPurple],)
              )
            ),
            Positioned(
              top: _responsiveScreen.hp(70),
              left: _responsiveScreen.wp(75),
              child: FadeInRight(child: BackgoundWidget(colors: [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(30),))
            ),
        ],
      ),
    );
  }

  Widget _content(Responsive _responsiveScreen, UserModel userModel, UserInfoP userInfo){
    return Expanded(
      child: Column(
        children: [
          Container(
            width: _responsiveScreen.wp(80),
            height: _responsiveScreen.hp(20),
            child: Row(
              children: [
                Expanded(child: Container()),
                FadeInRight(
                  child: Container(
                    height: _responsiveScreen.ip(11.2),
                    width: _responsiveScreen.ip(11.2),
                    child: Stack(
                      children: [
                        _photoUser(userModel, _responsiveScreen),
                        Positioned(
                          bottom: 1,
                          child: _camera(_responsiveScreen, userModel)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _body(_responsiveScreen, userInfo),
        ],
      )
    );
  }

  Widget speedDial(_screenSize, BuildContext context) {
    final typeUser = Provider.of<TypeUser>(context);
    return SpeedDial(
      marginRight: 8,
      marginBottom: 2,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 25.0, color: OurColors.lightGreenishBlue),
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Opciones',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.power_settings_new, color: Color(0XFFE90000)),
          backgroundColor: Colors.white,
          label: 'Cerrar Sesión',
          labelStyle: _styleFAB,
          onTap: () async {
            _prefs.uid = '';
            _prefs.token = '';
            _prefs.uidGroup = '';
            _prefs.mode = '';
            _prefs.lat = '';
            _prefs.lng = '';
            await _authService.signOut();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.account_circle, color: Color(0XFF00B900)),
          backgroundColor: Colors.white,
          label: typeUser.getTypeuser == 'CONDUCTOR' ? 'Ser pasajero' : 'Ser conductor',
          labelStyle: _styleFAB,
          onTap: () {
            _prefs.mode = '';
            Navigator.pushReplacementNamed(context, 'selectMode');
          }
        ),
        typeUser.getTypeuser == 'CONDUCTOR' ? SpeedDialChild(
          child: Icon(Icons.drive_eta, color: Color(0XFF0000B9)),
          backgroundColor: Colors.white,
          label: 'Mi auto',
          labelStyle: _styleFAB,
          onTap: () => {
            Navigator.pushNamed(context, 'regAuto', arguments: false)
          },
        ): SpeedDialChild(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ],
    );
  }

  // Widgets para los campos a recibir
  Widget _photoUser(UserModel userModel, Responsive responsiveScreen){
    return CircleAvatar(
      backgroundColor: Tema.OurColors.lightGreenishBlue,
      radius: responsiveScreen.ip(5.6),
      child: ClipOval(
        child: (userModel.photo != null) ? FadeInImage(
          image: NetworkImage(userModel.photo),
          placeholder: AssetImage('assets/img/ripple-loading.gif'),
          height: responsiveScreen.ip(11),
          width: responsiveScreen.ip(11),
          fit: BoxFit.cover,
        )
        : Container()
      ),
    );
  }

  Widget _camera(Responsive _responsiveScreen, UserModel userModel ){
    return CircleAvatar(
      radius: _responsiveScreen.ip(2),
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Positioned(
            top: _responsiveScreen.ip(4) - _responsiveScreen.ip(3.9),
            left: _responsiveScreen.ip(4) - _responsiveScreen.ip(3.9),
            child: CircleAvatar(
              radius: _responsiveScreen.ip(1.9),
              backgroundColor: Tema.OurColors.initialPurple,
            ),
          ),
          Positioned(
            bottom: (_responsiveScreen.ip(1.9)/2) - _responsiveScreen.ip(2),
            left: (_responsiveScreen.ip(1.9)/2) - _responsiveScreen.ip(2),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.camera, color: Tema.OurColors.grayishWhite, size: _responsiveScreen.ip(2)), 
              onPressed: () => Navigator.pushNamed(context, 'photo', arguments: userModel.photo),
            ),
          ),
        ],
      ) 
    );
  }

  Widget _nameUser(UserInfoP userInfo){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey1,
              child: TextFormField(
                controller: _nameController,
                enabled: _activeEditName,
                style: _styleText,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.user, color: OurColors.darkGray, size: 20.0),
                  errorStyle: _styleErrorText
                ),
                validator: (value) {
                  if (RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value) && value.length >= 3) {
                    return null;
                  }
                  return 'Nombre incorrecto!';
                },
              ),
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              userInfo.nameUser(_nameController.text); 
              _saveInputName();
            },
            child: Column(
              children: !_activeEditName ? <Widget>[
                Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                Text('Editar', style: _styleEditText),
              ]
              : <Widget>[ 
                Icon(FontAwesomeIcons.check, size: 18.0, color: Colors.green),
                Text('Ok', style: _styleEditText),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _lastnameUser(UserInfoP userInfo){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey2,
              child: TextFormField(
                controller: _lastnameController,
                enabled: _activeEditLastname,
                style: _styleText,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.user, color: OurColors.darkGray, size: 20.0),
                  errorStyle: _styleErrorText
                ),
                validator: (value) {
                  if (RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value) && value.length >= 3) {
                    return null;
                  }
                  return 'Apellido incorrecto!';
                },
              ),
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              userInfo.lastNameUser(_lastnameController.text);
              _saveInputLastname();
            },
            child: Column(
              children: !_activeEditLastname ? <Widget>[
                Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                Text('Editar', style: _styleEditText),
              ]
              : <Widget>[ 
                Icon(FontAwesomeIcons.check, size: 18.0, color: Colors.green),
                Text('Ok', style: _styleEditText),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneUser(UserInfoP userInfo){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey3,
              child: TextFormField(
                controller: _phoneController,
                enabled: _activeEditPhone,
                style: _styleText,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.mobileAlt, color: OurColors.darkGray, size: 20.0),
                  errorStyle: _styleErrorText,
                  counterText: null
                ),
                validator: (value) {
                  if (RegExp(r'^[0-9]+$').hasMatch(value) && value.length == 10) {
                    return null;
                  }
                  return 'Teléfono incorrecto!';
                },
              ),
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              userInfo.phoneUser(_phoneController.text);
              _saveInputPhone();
            },
            child: Column(
              children: !_activeEditPhone ? <Widget>[
                Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                Text('Editar', style: _styleEditText),
              ]
              : <Widget>[ 
                Icon(FontAwesomeIcons.check, size: 18.0, color: Colors.green),
                Text('Ok', style: _styleEditText),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _ciUser(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: TextField(
        controller: _ciController,
        enabled: false,
        style: _styleText,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.idCard, color: OurColors.darkGray, size: 20.0),
        ),
      ),
    );
  }

  Widget _emailUser(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: TextField(
        controller: _emailController,
        enabled: false,
        style: _styleText,
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.envelope, color: OurColors.darkGray, size: 20.0),
        ),
      ),
    );
  }

  Widget _passUser(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 3.0),
      child: Form(
        key: _formKey4,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _oldPassController,
                    enabled: _activeEditPass,
                    obscureText: true,
                    style: _styleText,
                    decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.lock, 
                        color: OurColors.darkGray,
                        size: 20.0,
                      ),
                      hintText: _activeEditPass ? 'Anterior Contraseña' : 'Mi Contraseña',
                      hintStyle: _activeEditPass ? _styleTextHint : _styleText,
                      errorStyle: _styleErrorText,
                    ),
                    validator: (value) {
                      if (value.length <= 6 && value != ""){
                        return 'Contraseña muy corta!';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () => _saveInputPass(),
                  child: Column(
                    children: !_activeEditPass ? <Widget>[
                      Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                      Text('Editar', style: _styleEditText),
                    ]
                    : <Widget>[ 
                      Icon(FontAwesomeIcons.check, size: 18.0, color: Colors.green),
                      Text('Ok', style: _styleEditText),
                    ]
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _activeEditPass,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 3.0),
                child: TextFormField(
                  controller: _newPassController,
                  obscureText: _obscureTextPass,
                  style: _styleText,
                  decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.lock, color: OurColors.darkGray,size: 20.0),
                    hintText: 'Nueva Contraseña',
                    hintStyle: _styleTextHint,
                    errorStyle: _styleErrorText,
                    suffixIcon: GestureDetector(
                      onTap: _showTextPass,
                      child: Icon(_obscureTextPass? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 15.0, color: Colors.black),
                    ),
                  ),
                  validator: (value) {
                    if (value != "" && value.length <= 6){
                      if (_oldPassController.text == value) {
                        return 'Contraseña muy corta!\nContraseñas no pueden ser iguales!';  
                      } else {
                        return 'Contraseña muy corta!';  
                      } 
                    } else if (value != "" && _oldPassController.text == value){
                      return 'Contraseñas no pueden ser iguales!';  
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 10.0)
          ],
        ),
      ),
    );
  }

  Widget _body(Responsive _responsiveScreen, UserInfoP userInfo){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: <Widget>[
            // Container(
            //   height: _responsiveScreen.hp(2),
            // ),
            Container(
              width: _responsiveScreen.wp(90),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 4.0),
                    spreadRadius: 3.0
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  _nameUser(userInfo), 
                  _lastnameUser(userInfo), 
                  _ciUser(),
                  _emailUser(),
                  _phoneUser(userInfo),
                  _passUser(),
                  SizedBox(height: 5.0)
                ]
              )
            )
          ],
        ),
      ),
    );
  }
  
  Future<void> _saveInputName() async {
    if (_formKey1.currentState.validate()) {
      setState(() {
        _activeEditName = !_activeEditName;
      });
      if (!_activeEditName) {
        await _uploadUser("name", _nameController.text);
      } 
    }
  }

  Future<void> _saveInputLastname() async {
    if (_formKey2.currentState.validate()) {
      setState(() {
        _activeEditLastname = !_activeEditLastname;
      });
      if (!_activeEditLastname) {
        await _uploadUser("lastName", _lastnameController.text);
      }
    }
  }

  Future<void> _saveInputPhone() async {
    if (_formKey3.currentState.validate()) {
      setState(() {
        _activeEditPhone = !_activeEditPhone;
      });
      if (!_activeEditPhone) {
        await _uploadUser("phone", _phoneController.text);
      }
    }
  }

  Future<void> _saveInputPass() async {
    if (_formKey4.currentState.validate()) { 
      setState(() {
        _activeEditPass = !_activeEditPass;
      });
      if (!_activeEditPass && _oldPassController.text != "" && _newPassController.text != "") {
        final response =  await _authService.reAuth(_emailController.text, _oldPassController.text, _newPassController.text);
        _oldPassController.clear();
        _newPassController.clear();
        if(response['ok'] == false){
          mostrarAlerta(context, 'Ups!', response['message']); 
        }
      } else if (_oldPassController.text != "" || _newPassController.text != "") {
        setState(() {
          _activeEditPass = true;
        });
      } else if (_oldPassController.text != "" && _newPassController.text != ""){
        setState(() {
          _activeEditPass = false;
        });
      }
    }
  }

  Future<void> _uploadUser(String property, String value) async {
    final result = await _userService.uploadUser(property, value);
    if (!result["ok"]) mostrarAlerta(context, "Error", result["message"]);
  }

  void _showTextPass() {
    setState(() {
      _obscureTextPass = !_obscureTextPass;
    });
  }

}