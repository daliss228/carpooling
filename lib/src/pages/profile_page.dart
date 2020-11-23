import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/services/auth_service.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {

  final _ciController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _lastnameController = TextEditingController();

  final _userService = UserService();
  final _authService = AuthService();
  final _prefs = UserPreferences();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

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
  bool get wantKeepAlive => true;

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
  Widget build(BuildContext context) {
    super.build(context);
    final responsiveScreen = Responsive(context);
    final mapProvider = Provider.of<MapProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    _ciController.text = userProvider.user.ci;
    _nameController.text = userProvider.user.name;
    _emailController.text = userProvider.user.email;
    _phoneController.text = userProvider.user.phone;
    _lastnameController.text = userProvider.user.lastname;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        floatingActionButton: _keyboardOpen ? Container() : _speedDial(responsiveScreen, _prefs.mode),
        body: Stack(
          children: [
            _background(responsiveScreen),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: responsiveScreen.hp(3)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: FadeInRight(
                        child: Text('Mi Perfil', style: TextStyle(fontSize: responsiveScreen.ip(4), fontFamily: 'WorkSansLight', color: OurColors.darkGray))
                      ),
                    ),
                    _content(responsiveScreen, userProvider, mapProvider)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _background(Responsive responsiveScreen) {
    return Container(
      width: responsiveScreen.wp(100),
      height: responsiveScreen.hp(100),
      child: Stack(
        children: [
          Positioned(
            right: responsiveScreen.wp(75),
            child: FadeInLeft(
              child: BackgoundWidget(
                colors: [OurColors.lightBlue, OurColors.lightGreenishBlue],
                sizeWidget: responsiveScreen.hp(34)
              )
            )
          ),
          Positioned(
            top: responsiveScreen.hp(1),
            right: responsiveScreen.wp(75),
            child: FadeInLeft(
              delay: Duration(milliseconds: 500),
              child: BackgoundWidget(
                sizeWidget: responsiveScreen.hp(30),
                colors: [OurColors.finalPurple, OurColors.initialPurple],
              )
            )
          ),
          Positioned(
            top: responsiveScreen.hp(70),
            left: responsiveScreen.wp(75),
            child: FadeInRight(
              child: BackgoundWidget(
                colors: [OurColors.lightBlue, OurColors.lightGreenishBlue],
                sizeWidget: responsiveScreen.hp(30),
              )
            )
          ),
        ],
      ),
    );
  }

  Widget _content(Responsive responsiveScreen, UserProvider userInfo, MapProvider mapProvider){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: responsiveScreen.hp(6), horizontal: responsiveScreen.wp(6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeInRight(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: responsiveScreen.ip(7.0) * 2,
                      height: responsiveScreen.ip(5.6) * 2,
                    ),
                    _photoUser(userInfo.user, responsiveScreen),
                    _camera(responsiveScreen, userInfo.user, mapProvider)
                  ],
                ),
              ),
            ],
          ),
        ),
        _body(responsiveScreen, userInfo.user),
        SizedBox(height: 50.0),
      ],
    );
  }

  Widget _speedDial(Responsive responsiveScreen, String typeUser) {
    return SpeedDial(
      elevation: 0.0,
      marginRight: 5,
      marginBottom: 0,
      overlayOpacity: 0.5,
      closeManually: false,
      shape: CircleBorder(),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      tooltip: 'Opciones',
      heroTag: 'speed-dial-hero-tag',
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: responsiveScreen.ip(3.0), color: Colors.white),
      children: [
        SpeedDialChild(
          child: Icon(Icons.power_settings_new, color: OurColors.red, size: responsiveScreen.ip(2.8)),
          backgroundColor: Colors.white,
          label: 'Cerrar Sesión',
          labelStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.6), color: Colors.black),
          onTap: () async {
            await _authService.signOut();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.account_circle, color: OurColors.blue, size: responsiveScreen.ip(2.8)),
          backgroundColor: Colors.white,
          label: 'Cambiar modo',
          labelStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.6), color: Colors.black),
          onTap: () {
            Navigator.pushReplacementNamed(context, 'mode');
          }
        ),
        typeUser == 'CONDUCTOR'
        ? SpeedDialChild(
            child: Icon(Icons.drive_eta, color: OurColors.green, size: responsiveScreen.ip(2.8)),
            backgroundColor: Colors.white,
            label: 'Mi auto',
            labelStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.6), color: Colors.black),
            onTap: () => {
              Navigator.pushNamed(context, 'regAuto', arguments: false)
            },
        )
        : SpeedDialChild(
            backgroundColor: Colors.transparent,
            elevation: 0,
        ),
      ],
    );
  }

  // Widgets para los campos a recibir
  Widget _photoUser(UserModel userModel, Responsive responsiveScreen) {
    return ClipOval(
      child: (userModel.photo != null)
      ? FadeInImage(
          image: NetworkImage(userModel.photo),
          placeholder: AssetImage('assets/img/ripple-loading.gif'),
          height: responsiveScreen.ip(11),
          width: responsiveScreen.ip(11),
          fit: BoxFit.cover,
        )
      : Container()
    );
  }

  Widget _camera(Responsive responsiveScreen, UserModel userModel, MapProvider mapProvider) {
    return Positioned(
      bottom: 0,
      right: responsiveScreen.ip(8.0),
      child: InkWell(
        onTap: () {
          mapProvider.auxiliary = true;
          Navigator.pushNamed(context, 'photo');
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: responsiveScreen.ip(2.3),
          child: CircleAvatar(
            radius: responsiveScreen.ip(2),
            backgroundColor: Colors.black12,
            child: Icon(FontAwesomeIcons.camera, color: OurColors.darkPurple, size: responsiveScreen.ip(2)),
          ),
        ),
      ),
    );
  }

  Widget _nameUser(UserModel user, Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey1,
              child: TextFormField(
                controller: _nameController,
                enabled: _activeEditName,
                style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.darkGray),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.user, color: OurColors.darkGray, size: responsiveScreen.ip(2)),
                  errorStyle: TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935))
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
              user.name = _nameController.text;
              _saveInputName();
            },
            child: Column(
              children: !_activeEditName
              ? <Widget>[
                Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                Text('Editar', style: TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: responsiveScreen.ip(1.2))),
                ]
              : <Widget>[
                Icon(FontAwesomeIcons.check, size: 18.0, color: OurColors.green),
                Text('Ok', style: TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: responsiveScreen.ip(1.2))),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _lastnameUser(UserModel user, Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey2,
              child: TextFormField(
                controller: _lastnameController,
                enabled: _activeEditLastname,
                style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.darkGray),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.user, color: OurColors.darkGray, size: responsiveScreen.ip(2)),
                  errorStyle: TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935))
                ),
                validator: (value) {
                  if (RegExp(r'^[A-Za-záéíóúÁÉÍÓÚ]+$').hasMatch(value) && value.length >= 3) return null;
                  return 'Apellido incorrecto!';
                },
              ),
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              user.lastname = _lastnameController.text;
              _saveInputLastname();
            },
            child: Column(
              children: !_activeEditLastname
              ? <Widget>[
                Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                Text('Editar', style: TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: responsiveScreen.ip(1.2))),
              ]
              : <Widget>[
                Icon(FontAwesomeIcons.check, size: 18.0, color: OurColors.green),
                Text('Ok', style: TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: responsiveScreen.ip(1.2))),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _phoneUser(UserModel user, Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _formKey3,
              child: TextFormField(
                controller: _phoneController,
                enabled: _activeEditPhone,
                style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.darkGray),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.mobileAlt, color: OurColors.darkGray, size: responsiveScreen.ip(2)),
                  errorStyle: TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935)),
                  counterText: null
                ),
                validator: (value) {
                  if (RegExp(r'^[0-9]+$').hasMatch(value) && value.length == 10) return null;
                  return 'Teléfono incorrecto!';
                },
              ),
            ),
          ),
          SizedBox(width: 10.0),
          GestureDetector(
            onTap: () {
              user.phone = _phoneController.text;
              _saveInputPhone();
            },
            child: Column(
              children: !_activeEditPhone
              ? <Widget>[
                Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                Text('Editar', style: TextStyle(fontFamily: "WorkSansMedium", color: OurColors.darkGray, fontSize: responsiveScreen.ip(1.2))),
              ]
              : <Widget>[
                Icon(FontAwesomeIcons.check, size: 18.0, color: OurColors.green),
                Text('Ok', style: TextStyle(fontFamily: "WorkSansMedium", color: OurColors.darkGray, fontSize: responsiveScreen.ip(1.2))),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _ciUser(Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: _ciController,
        enabled: false,
        style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.darkGray),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          icon: Icon(FontAwesomeIcons.idCard, color: OurColors.darkGray, size: responsiveScreen.ip(2)),
        ),
      ),
    );
  }

  Widget _emailUser(Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        enabled: false,
        controller: _emailController,
        style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.darkGray),
        decoration: InputDecoration(
          icon: Icon(FontAwesomeIcons.envelope, color: OurColors.darkGray, size: responsiveScreen.ip(2)),
        ),
      ),
    );
  }

  Widget _passUser(Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
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
                    style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.darkGray),
                    decoration: InputDecoration(
                      icon: Icon(FontAwesomeIcons.lock, color: OurColors.darkGray, size: responsiveScreen.ip(2)),
                      hintText: _activeEditPass ? 'Anterior Contraseña' : 'Mi Contraseña',
                      hintStyle: _activeEditPass ? TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2)) : TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: Colors.black),
                      errorStyle: TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935)),
                    ),
                    validator: (value) {
                      if (value.length <= 6 && value != "") {
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
                    children: !_activeEditPass
                    ? <Widget>[
                      Icon(Icons.edit, size: 18.0, color: OurColors.darkPurple),
                      Text('Editar', style: TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: responsiveScreen.ip(1.2))),
                    ]
                    : <Widget>[
                      Icon(FontAwesomeIcons.check, size: 18.0, color: OurColors.green),
                      Text('Ok', style: TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: responsiveScreen.ip(1.2))),
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
                  style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.darkGray),
                  decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.lock, color: OurColors.darkGray, size: responsiveScreen.ip(2)),
                    hintText: 'Nueva Contraseña',
                    hintStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2)),
                    errorStyle: TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935)),
                    suffixIcon: GestureDetector(
                      onTap: _showTextPass,
                      child: Icon(_obscureTextPass ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash, size: 15.0, color: OurColors.darkGray),
                    ),
                  ),
                  validator: (value) {
                    if (value != "" && value.length <= 6) {
                      if (_oldPassController.text == value) {
                        return 'Contraseña muy corta!\nContraseñas no pueden ser iguales!';
                      } else {
                        return 'Contraseña muy corta!';
                      }
                    } else if (value != "" &&
                        _oldPassController.text == value) {
                      return 'Contraseñas no pueden ser iguales!';
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }

  Widget _body(Responsive responsiveScreen, UserModel user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      margin: EdgeInsets.symmetric(horizontal: responsiveScreen.wp(6)),
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
          _nameUser(user, responsiveScreen),
          _lastnameUser(user, responsiveScreen),
          _ciUser(responsiveScreen),
          _emailUser(responsiveScreen),
          _phoneUser(user, responsiveScreen),
          _passUser(responsiveScreen)
        ]
      )
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
        final response = await _authService.reAuth(_emailController.text, _oldPassController.text, _newPassController.text);
        _oldPassController.clear();
        _newPassController.clear();
        if (response['ok'] == false) {
          showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, response['message']);
        } else {
          showAlert(context, 'Ups!', Icons.sentiment_satisfied, response['message']);
        }
      } else if (_oldPassController.text != "" || _newPassController.text != "") {
        setState(() {
          _activeEditPass = true;
        });
      } else if (_oldPassController.text != "" && _newPassController.text != "") {
        setState(() {
          _activeEditPass = false;
        });
      }
    }
  }

  Future<void> _uploadUser(String property, String value) async {
    final result = await _userService.updateUser(property, value);
    if (!result["ok"]) showAlert(context, "Error", Icons.sentiment_dissatisfied, result["message"]);
  }

  void _showTextPass() {
    setState(() {
      _obscureTextPass = !_obscureTextPass;
    });
  }

}
