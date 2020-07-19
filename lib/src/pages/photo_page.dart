import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Theme;
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';

// pagina para capturar o elegir la imagen
class PhotoPage extends StatefulWidget {
  
  createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> with TickerProviderStateMixin{
  
  File _imageFile;
  String _useruid;
  String _oldPhoto;
  bool _isLoading = false;
  bool _showAnimation = true;
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
    _oldPhoto = ModalRoute.of(context).settings.arguments;
    print(_oldPhoto);
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
              color: Theme.OurColors.lightGreenishBlue,
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
              color: Theme.OurColors.lightGreenishBlue,
            ),
          ],
        ),
      ),
      body: _isLoading 
      ? LoadingWidget()
      : Stack(
        children: <Widget>[
          _body(_screenSize),
          (_oldPhoto.isNotEmpty) ? _buttonComeback() : Container(),
        ],
      )
    );
  }

  Widget _body(Size _screenSize) {
    return ListView(
      children: (_showAnimation) 
      ? <Widget>[
        SizedBox(height: _screenSize.height * 0.68),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Agrega tu foto: \nCámara o galería?", textAlign: TextAlign.center, style: TextStyle(color: Theme.OurColors.lightGreenishBlue, fontSize: 17.0, fontFamily: "WorkSansBold")),
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
            color: Theme.OurColors.darkPurple,
            size: _arrowAnimation.value,
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
          color: Theme.OurColors.lightGreenishBlue,
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
          splashColor: Theme.OurColors.lightGreenishBlue,
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
    StorageReference storageReference = _storage.ref();
    try {
      setState(() {
        _isLoading = true;
      });
      if (_oldPhoto.isNotEmpty) {
        String nameImage = _oldPhoto
        .replaceAll(RegExp(r'https://firebasestorage.googleapis.com/v0/b/dev-carpooling.appspot.com/o/'), '').replaceAll('%20', ' ').replaceAll('%3A', ':').split('?')[0];
        print(nameImage);
        await storageReference.child(nameImage).delete().then((_) => print('Successfully deleted $nameImage storage item' ));
      }
      String filePath = "${DateTime.now()}.png";
      StorageUploadTask uploadTask = storageReference.child(filePath).putFile(_imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      _dbRef.child("users").child(_useruid).update({
        "photo": downloadUrl,
      });
      if (_oldPhoto.isNotEmpty) {
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        Navigator.pushReplacementNamed(context, 'mode');
      }
    } catch (error) {
      print(error);
    }
  }

}