import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Theme;
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';

// pagina para capturar o elegir la imagen
class PhotoPage extends StatefulWidget {
  
  createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> with TickerProviderStateMixin{
  
  File _imageFile;
  String _useruid;
  bool _showAnimation = true;
  bool _isLoading = false;
  Animation _arrowAnimation;
  AnimationController  _arrowAnimationController;
  PreferenciasUsuario _prefs = PreferenciasUsuario();
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://dev-carpooling.appspot.com');

  @override
  void initState() { 
    super.initState();
    _useruid = _prefs.uid.toString();
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
  }

  @override
  void dispose() {
    _arrowAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              color: Theme.Colors.loginGradientEnd,
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
              color: Theme.Colors.loginGradientEnd,
            ),
          ],
        ),
      ),
      body: _isLoading 
      ? LoadingWidget()
      : Column(
        children: (_showAnimation) 
        ? <Widget>[
          SizedBox(height: _screenSize.height * 0.70),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Text("Agrega tu foto: \nCámara o galería?", textAlign: TextAlign.center, style: TextStyle(color: Theme.Colors.loginGradientEnd, fontSize: 17.0, fontFamily: "WorkSansBold")),
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
            child: _butonUploader()
          )
        ] :
        <Widget>[ Container() ]
      )
    );
  }

  // para la animacion de la flecha
  Widget _arrowDownAnimation() {
    return AnimatedBuilder(
      animation: _arrowAnimationController,
      builder: (context, child) {
        return Center(
          child: Container(
            child: Center(
              child: Icon(
                FontAwesomeIcons.arrowDown,
                color: Color(0XFF3B3E69),
                size: _arrowAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _butonUploader(){
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Theme.Colors.loginGradientEnd,
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
          splashColor: Theme.Colors.loginGradientEnd,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.0),
            child: Text("Continuar", style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansBold")),
          ),
          onPressed: _startUpload,
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
  Future<void> _startUpload() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String filePath = "${DateTime.now()}.png";
      StorageUploadTask uploadTask = _storage.ref().child(filePath).putFile(_imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      _dbRef.child("users").child(_useruid).update({
                "photo": downloadUrl,
      });
      Navigator.pushReplacementNamed(context, 'home');
    } catch (error) {
      print(error);
    }
  }

}