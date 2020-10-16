import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';

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
    final _responsiveScreen = new Responsive(context);
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
          Positioned(
              left: _responsiveScreen.wp(50),
              bottom: _responsiveScreen.hp(55),
              child: FadeInRight(
                child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [OurColors.initialPurple, OurColors.finalPurple.withOpacity(0.5)]))
            ),
            // Positioned(
            //   left: _responsiveScreen.wp(30),
            //   bottom: _responsiveScreen.hp(70),
            //   child: FadeInRight(
            //     delay: Duration(milliseconds: 1000),
            //     child: CircleWidget(radius: _responsiveScreen.wp(60), colors: [OurColors.initialPurple, OurColors.finalPurple.withOpacity(0.1)]))
            // ),
            Positioned(
              left: _responsiveScreen.wp(60),
              bottom: _responsiveScreen.hp(80),
              child: FadeInRight(
                delay: Duration(milliseconds: 500),
                child: CircleWidget(radius: _responsiveScreen.wp(40), colors:  [OurColors.lightBlue, OurColors.lightGreenishBlue.withOpacity(0.8)]))
            ),
          _body(_screenSize, context, _responsiveScreen),
          (_oldPhoto.isNotEmpty) ? _buttonComeback() : Container(),
        ],
      )
    );
  }

  Widget _body(Size _screenSize, BuildContext context, Responsive _responsiveScreen) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: (_showAnimation) 
      ? <Widget>[
        SizedBox(height: _responsiveScreen.hp(68)),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Agrega tu foto: \nCámara o galería?", textAlign: TextAlign.center, style: TextStyle(color: OurColors.lightGreenishBlue, fontSize: _responsiveScreen.ip(2), fontFamily: "WorkSansBold")),
        ),
        _arrowDownAnimation()
      ] 
      : (_imageFile != null) ? <Widget>[
        SizedBox(height: _responsiveScreen.hp(7.5)),
        Container(
          padding: EdgeInsets.all(32),
          child:  Image.file(_imageFile)
        ),
        Container(
          padding: EdgeInsets.only(right: 32, bottom: 32, left: 32),
          child: _butonUploader(context, _responsiveScreen)
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

  Widget _butonUploader(BuildContext context, responsiveScreen){
    return Center(
      child: MaterialButton(
        color: OurColors.lightGreenishBlue,
        highlightColor: Colors.transparent,
        splashColor: OurColors.lightGreenishBlue,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
          child: Text("CONTINUAR", style: TextStyle(color: Colors.white, fontSize: responsiveScreen.ip(1.5), fontFamily: "WorkSansMedium"),
          ),
        ),
        onPressed: _uploadPhotoUser
      ),
    );
  }

  // seleccionar una imagen de la galeria o abrir la camera
  Future<void> _pickImage(ImageSource source) async {
    // File selected = await ImagePicker.pickImage(source: source, maxWidth: 500, maxHeight: 500);
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source, maxWidth: 500, maxHeight: 500);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  // subir la url de la imagen al realtime
  Future<void> _uploadPhotoUser() async {
    setState(() {
        _isLoading = true;
    });
    Map result = await _usuarioService.uploadPhotoUser(_oldPhoto, _imageFile);
    if (!result["ok"]) {
      mostrarAlerta(context, 'Error', result["message"]); 
    }
    Navigator.pushReplacementNamed(context, 'selectMode');
  }

}