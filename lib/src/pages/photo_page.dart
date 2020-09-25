import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/providers/user_provider/user_provider.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';

import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

// pagina para capturar o elegir la imagen
class PhotoPage extends StatefulWidget {
  createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> with TickerProviderStateMixin{
  
  File _imageFile;
  String useruid;
  String _oldPhoto;
  bool _isLoading = false;
  bool _showAnimation = true;
  Animation _arrowAnimation;
  AnimationController _arrowAnimationController;
  UserService _usuarioService = UserService();

  @override
  void initState() { 
    final _prefs = UserPreferences();
    useruid = _prefs.uid;
    _arrowAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _arrowAnimation = Tween(begin: 50.0, end: 70.0).animate(CurvedAnimation(
        curve: Curves.easeInOutCirc, parent: _arrowAnimationController));
    _arrowAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _arrowAnimationController.repeat();
      }
    });
    _arrowAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _arrowAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _oldPhoto = ModalRoute.of(context).settings.arguments;
    final _screenSize = MediaQuery.of(context).size; 
    return Scaffold(
      bottomNavigationBar: (_isLoading) ? BottomAppBar() : BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 32,
              ),
              onPressed: () {
                setState(() {
                  _showAnimation = false;  
                });
                _pickImage(ImageSource.camera);
              },
              color: OurColors.lightGreenishBlue,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 32,
              ),
              onPressed: () {
                setState(() {
                  _showAnimation = false;
                });
                _pickImage(ImageSource.gallery);
              },
              color: OurColors.lightGreenishBlue,
            ),
          ],
        ),
      ),
      body: _isLoading 
      ? LoadingWidget()
      : Stack(
        children: <Widget>[
          _body(_screenSize, context),
          (_oldPhoto.isNotEmpty) ? _buttonComeback() : Container(),
        ],
      )
    );
  }

  Widget _body(Size _screenSize, BuildContext context) {
    return ListView(
      children: (_showAnimation) 
      ? <Widget>[
        SizedBox(height: _screenSize.height * 0.68),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Agrega tu foto: \nCámara o galería?", textAlign: TextAlign.center, style: TextStyle(color: OurColors.lightGreenishBlue, fontSize: 17.0, fontFamily: "WorkSansBold")),
        ),
        _arrowDownAnimation()
      ] 
      : (_imageFile != null) ? <Widget>[
        SizedBox(height: _screenSize.height * 0.1),
        Container(
          padding: EdgeInsets.all(32),
          child:  Image.file(_imageFile)
        ),
        Container(
          padding: EdgeInsets.only(right: 32, bottom: 32, left: 32),
          child: _butonUploader(context)
        )
      ] : <Widget>[ Container() ]
    );
  }

  Widget _buttonComeback() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: CupertinoButton(
          padding: EdgeInsets.all(10.0),
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.black26,
          child: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)
        ),
      ),
    );
  }

  // para la animacion de la flecha
  Widget _arrowDownAnimation() {
    return AnimatedBuilder(
      animation: _arrowAnimationController,
      builder: (context, child) {
        return Container(
          child: Icon(
            FontAwesomeIcons.arrowDown,
            color: OurColors.darkPurple,
            size: _arrowAnimation.value,
          ),
        );
      },
    );
  }

  Widget _butonUploader(BuildContext context){
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: OurColors.lightGreenishBlue,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0.0, 1.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: MaterialButton(
          highlightColor: Colors.transparent,
          splashColor: OurColors.lightGreenishBlue,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.0),
            child: Text("Continuar", style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansBold")),
          ),
          onPressed: _uploadPhotoUser,
        ),
      ),
    );
  }

  // seleccionar una imagen de la galeria o abrir la camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source, maxWidth: 500, maxHeight: 500);
    setState(() {
      _imageFile = selected;
    });
  }

  // subir la url de la imagen al realtime
  Future<void> _uploadPhotoUser() async {
    // final _userInfo = Provider.of<UserInfoP>(context);
    setState(() {
        _isLoading = true;
    });
    Map result = await _usuarioService.uploadPhotoUser(_oldPhoto, _imageFile, context);
    if (!result["ok"]) {
      mostrarAlerta(context, 'Error', result["message"]); 
    }
    // _userInfo.photoUser(result['link']);

    print(result['link']);
    print('######################😠 😡 🤬 🤯');
    if (_oldPhoto.isNotEmpty) {
      Navigator.pushReplacementNamed(context, 'selectMode');
    } else {
      Navigator.pushReplacementNamed(context, 'selectMode');
    }
    
  }

}