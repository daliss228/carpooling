import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/take_picture.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';

// pagina para capturar o elegir la imagen
class PhotoPage extends StatefulWidget {
  createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> with TickerProviderStateMixin{
  
  final _picker = ImagePicker();
  final _userService = UserService();

  Animation _arrowAnimation;
  AnimationController _arrowAnimationController;
  
  File _imageFile;
  String oldPhoto;
  bool _isLoading = false;
  bool _showAnimation = true;

  @override
  void initState() { 
    _arrowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _arrowAnimation = Tween(begin: 50.0, end: 65.0).animate(CurvedAnimation(curve: Curves.easeInOutCirc, parent: _arrowAnimationController));
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
    final responsiveScreen = Responsive(context);
    final mapProvider = Provider.of<MapProvider>(context);
    if (mapProvider.auxiliary) {
      oldPhoto = Provider.of<UserProvider>(context).user.photo;
    }
    return Scaffold(
      bottomNavigationBar: _isLoading ? BottomAppBar() : _bottomAppBar(responsiveScreen),
      body: _isLoading 
      ? LoadingWidget()
      : Stack(
        children: <Widget>[
          _background(responsiveScreen),
          _body(responsiveScreen, mapProvider),
          mapProvider.auxiliary ? _buttonComeback(context, responsiveScreen) : Container(),
        ],
      )
    );
  }

  Widget _bottomAppBar(Responsive responsiveScreen) {
    return BottomAppBar(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            color: OurColors.lightGreenishBlue,
            icon: Icon( FontAwesomeIcons.cameraRetro, size: responsiveScreen.ip(2.8)),
            onPressed: () {
              setState(() {
                _showAnimation = false;  
              });
              _takePicture(context);
            },
          ),
          IconButton(
            color: OurColors.lightGreenishBlue,
            icon: Icon(FontAwesomeIcons.solidImages, size: responsiveScreen.ip(2.8)),
            onPressed: () {
              setState(() {
                _showAnimation = false;
              });
              _pickImage();
            },
          ),
        ],
      ),
    );
  }

  Widget _background(Responsive responsiveScreen) {
    return Stack(
      children: [
        Positioned(
          left: responsiveScreen.wp(50),
          bottom: responsiveScreen.hp(55),
          child: FadeInRight(child: CircleWidget(radius: responsiveScreen.wp(60), colors: [OurColors.initialPurple, OurColors.finalPurple.withOpacity(0.5)]))
        ),
        Positioned(
          left: responsiveScreen.wp(60),
          bottom: responsiveScreen.hp(80),
          child: FadeInRight(
            delay: Duration(milliseconds: 500),
            child: CircleWidget(radius: responsiveScreen.wp(40), colors:  [OurColors.lightBlue, OurColors.lightGreenishBlue.withOpacity(0.8)])
          )
        ),
      ],
    );
  }

  Widget _body(Responsive responsiveScreen, MapProvider mapProvider) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _showAnimation
      ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Agrega tu foto: \nCámara o galería?", textAlign: TextAlign.center, style: TextStyle(color: OurColors.lightGreenishBlue, fontSize: responsiveScreen.ip(2.0), fontFamily: "WorkSansBold")),
          ),
          _arrowDownAnimation(),
          SizedBox(height: responsiveScreen.hp(1.5)),
        ],
      )
      : (_imageFile != null) ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: responsiveScreen.ip(35),
            height: responsiveScreen.ip(35),
            child: ClipOval(
              child: Image.file(_imageFile, fit: BoxFit.fill),
            )
          ),
          SizedBox(height: responsiveScreen.hp(4.0)),
          _butonUploader(responsiveScreen, mapProvider)
        ],
      ) : Container(),
    );
  }

  Widget _buttonComeback(BuildContext context, Responsive responsiveScreen) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: CupertinoButton(
          padding: EdgeInsets.all(10.0),
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.black26,
          child: Icon(Icons.arrow_back, color: Colors.white, size: responsiveScreen.ip(2.5)),
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

  Widget _butonUploader(Responsive responsiveScreen, MapProvider mapProvider){
    return Center(
      child: MaterialButton(
        color: OurColors.lightGreenishBlue,
        highlightColor: Colors.transparent,
        splashColor: OurColors.lightGreenishBlue,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
          child: Text(
            "CONTINUAR",
            style: TextStyle(
              color: Colors.white,
              fontSize: responsiveScreen.ip(1.5),
              fontFamily: "WorkSansMedium"
            ),
          ),
        ),
        onPressed: () => _uploadPhotoUser(mapProvider)
      )
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    CameraDescription camera;
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    for (CameraDescription cameraDescription in cameras) {
      if (cameraDescription.lensDirection == CameraLensDirection.front) {
        camera = cameraDescription;
        break;
      }
    }
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => TakePicture(camera: camera)
    ));
    if (result != null) {
      setState(() {
        _imageFile = File(result);
      });  
    }
  }

  // seleccionar una imagen de la galeria o abrir la camera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // subir la url de la imagen al realtime
  Future<void> _uploadPhotoUser(MapProvider mapProvider) async {
    setState(() {
      _isLoading = true;
    });
    mapProvider.auxiliary = false;
    final result = await _userService.uploadPhotoUser(oldPhoto, _imageFile);
    if (!result["ok"]) {
      showAlert(context, 'Error', Icons.sentiment_dissatisfied, result["message"]); 
    }
    Navigator.pushReplacementNamed(context, 'selectMode');
  }

}