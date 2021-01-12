import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/utils/add_images.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/providers/ui_provider.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/widgets/camera_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/gallery_widget.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';

// pagina para capturar o elegir la imagen
class PhotoPage extends StatefulWidget {
  createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> with TickerProviderStateMixin {
  
  final _addImage = AddImage();
  final _userService = UserService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Scaffold(
      bottomNavigationBar: _isLoading ? BottomAppBar() : _bottomAppBar(responsiveScreen),
      body: _isLoading 
      ? LoadingWidget()
      : Stack(
        children: <Widget>[
          _background(responsiveScreen),
          _body(responsiveScreen),
          _buttonComeback(responsiveScreen)
        ],
      )
    );
  }

  Widget _bottomAppBar(Responsive responsiveScreen) {
    return BottomAppBar(
      child: Consumer<UIProvider>(builder: (context, provider, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              color: OurColors.lightGreenishBlue,
              icon: Icon( FontAwesomeIcons.cameraRetro, size: responsiveScreen.ip(2.8)),
              onPressed: () async {
                await _addImage.initCamerasDescrip();
                provider.cameraCtrl = CameraController(_addImage.listCamera.first, ResolutionPreset.medium, enableAudio: false);
                try {
                  await provider.cameraCtrl.initialize();
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CameraWidget()));
                } catch (e) {
                  return;
                }
              },
            ),
            IconButton(
              color: OurColors.lightGreenishBlue,
              icon: Icon(FontAwesomeIcons.solidImages, size: responsiveScreen.ip(2.8)),
              onPressed: () async {
                await _addImage.initImagesPath();
                if (_addImage.listPath.length == 0) return;
                Navigator.push(context, MaterialPageRoute(builder: (_) => GalleryPage()));
              },
            ),
          ],
        );
      }),
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

  Widget _body(Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Consumer<UIProvider>(builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: responsiveScreen.hp(10.0)),
            Container(
              width: double.infinity,
              height: responsiveScreen.hp(60.0),
              decoration: BoxDecoration(
                color: OurColors.gray,
                borderRadius: BorderRadius.circular(50.0)
              ),
              child: provider.image == null 
              ? Center(child: Text('Agrega tu foto: \nCámara o galería?', textAlign: TextAlign.center, style: TextStyle(fontSize: responsiveScreen.ip(2.0), fontFamily: 'WorkSansMedium', color: OurColors.black))) 
              : ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.file(
                  File(provider.image),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              )
            ),
            SizedBox(height: responsiveScreen.hp(5.0)),
            provider.image != null ? _butonUploader(responsiveScreen) : Container()
          ],
        );
      }),
    );
  }

  Widget _buttonComeback(Responsive responsiveScreen) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Consumer<UIProvider>(builder: (context, provider, child) {
          return Visibility(
            visible: provider.backArrow,
            child: CupertinoButton(
              padding: EdgeInsets.all(10.0),
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black26,
              child: Icon(Icons.arrow_back, color: Colors.white, size: responsiveScreen.ip(2.5)),
              onPressed: () {
                provider.image = null;
                Navigator.pop(context);
              }
            ),
          );
        }),
      ),
    );
  }

  Widget _butonUploader(Responsive responsiveScreen){
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
        onPressed: () {
          _uploadPhotoUser();
        }
      )
    );
  }

  // subir la url de la imagen al realtime

  Future<void> _uploadPhotoUser() async {
    final uiProvider = Provider.of<UIProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() => _isLoading = true);
    final compressed = await FlutterNativeImage.compressImage(uiProvider.image, quality: 25);
    final result = await _userService.uploadPhotoUser(userProvider.user == null ? false : (userProvider.user.photo == null ? false : true), compressed);
    if (!result.status) {
      setState(() => _isLoading = false);
      showAlert(context, 'Ups!', ValidatorResponse.iconData(result.code), result.message); 
      return;
    }
    uiProvider.image = null;
    Navigator.pushReplacementNamed(context, 'after');
  }

}