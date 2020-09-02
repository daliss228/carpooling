import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';

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
  final UsuarioService _authService = UsuarioService();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

  UserModel _user;
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
    return Scaffold(
      floatingActionButton: _keyboardOpen ? Container() : speedDial(_screenSize),
      body: FutureBuilder(
        future: _userService.readUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingWidget();
          } else {
            if (!snapshot.data["ok"]) {
              return AlertWidget(title: "Error", message: snapshot.data["message"]);
            } else {
              _user = snapshot.data["value"];
              _ciController.text = _user.ci;
              _nameController.text = _user.name;
              _emailController.text = _user.email;
              _phoneController.text = _user.phone;
              _lastnameController.text = _user.lastName;
              return Stack(
                children: <Widget>[
                  _header(_screenSize),
                  _body(_screenSize),
                  _camera(_screenSize)
                ],
              );
            }
          }
        }
      )
    ); 
  }

  Widget speedDial(_screenSize) {
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
            await _authService.signOut();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.account_circle, color: Color(0XFF00B900)),
          backgroundColor: Colors.white,
          label: 'Ser pasajero',
          labelStyle: _styleFAB,
          onTap: () {}
        ),
        SpeedDialChild(
          child: Icon(Icons.drive_eta, color: Color(0XFF0000B9)),
          backgroundColor: Colors.white,
          label: 'Mi auto',
          labelStyle: _styleFAB,
          onTap: () => {
            Navigator.pushNamed(context, 'regAuto', arguments: false)
          },
        ),
      ],
    );
  }

  // Widgets para los campos a recibir
  Widget _photoUser(){
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 66.0,
        child: ClipOval(
          child: (_user?.photo != null) ? FadeInImage(
            image: NetworkImage(_user?.photo),
            placeholder: AssetImage('assets/img/ripple-loading.gif'),
            height: 125.0,
            width: 125.0,
            fit: BoxFit.fill,
          )
          : Container()
        ),
      ),
    );
  }

  Widget _camera(Size _screenSize){
    return Positioned(
      width: 265.0,
      height: _screenSize.height * 0.40,
      child: Align(
        alignment: Alignment.centerRight,
        child: CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 21.0,
            backgroundColor: Colors.black12,
            child: IconButton(
              icon: Icon(FontAwesomeIcons.camera, color: OurColors.darkPurple, size: 20.0), 
              onPressed: () => Navigator.pushNamed(context, 'photo', arguments: _user.photo),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(Size _screenSize){
    return Stack(
      children: <Widget>[
        Positioned(
          width: _screenSize.width,
          height: (_screenSize.height * 0.30),
          child: Center(
            child: _photoUser(),
          ),
        ),
      ],
    );
  }

  Widget _nameUser(){
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
            onTap: () => _saveInputName(),
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

  Widget _lastnameUser(){
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
            onTap: () => _saveInputLastname(),
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

  Widget _phoneUser(){
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
            onTap: () => _saveInputPhone(),
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

  Widget _body(Size _screenSize){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: <Widget>[
            Container(
              height: _screenSize.height * 0.25,
            ),
            Container(
              width: _screenSize.width * 0.85,
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
                  _nameUser(), 
                  _lastnameUser(), 
                  _ciUser(),
                  _emailUser(),
                  _phoneUser(),
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