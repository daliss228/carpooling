import 'dart:io';
import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/utils/add_images.dart';
import 'package:flutter_carpooling/src/providers/ui_provider.dart';
import 'package:flutter_carpooling/src/widgets/cardscam_widget.dart';

class CameraWidget extends StatefulWidget {

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> with SingleTickerProviderStateMixin {

  AddImage _addImage;
  CameraDescription _cameraSelected;
  AnimationController _animationCtrl;

  @override
  void initState() { 
    _addImage = AddImage();
    _cameraSelected = _addImage.listCamera.first;
    _animationCtrl = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _animationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final cameraPhotos = _addImage.listPath.where((path) => path.folderName == "Camera").toList();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(responsive.hp(6.0)),
        child: AppBar(
          backgroundColor: Colors.black,
          titleSpacing: 0,
          title: Text('Cámara', style: TextStyle(fontSize: responsive.ip(2.2), fontFamily: 'WorkSansRegular', color: Colors.white)),
          leading: Consumer<UIProvider>(builder: (context, provider, child) {
            return IconButton(
              onPressed: () {
                provider.cameraCtrl.dispose();
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, size: responsive.ip(2.4))
            );
          }),
        ),
        
      ),
      body: Consumer<UIProvider>(builder: (context, provider, child) {
        return Column(
          children: [
            (!provider.cameraCtrl.value.isInitialized) 
            ? Container()
            : AspectRatio(
              aspectRatio: provider.cameraCtrl.value.aspectRatio,
              child: CameraPreview(provider.cameraCtrl),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cameraPhotos.length != 0 
                  ? InkWell(
                    customBorder: CircleBorder(),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CardsCamWidget(images: cameraPhotos[0].files))),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0, color: Colors.white)
                      ),
                      child: ClipOval(
                        child: Image.file(
                          File(cameraPhotos[0].files[0]),
                          fit: BoxFit.cover,
                          width: responsive.ip(7.0),
                          height: responsive.ip(7.0),
                        ),
                      ),
                    ),
                  )
                  : InkWell(
                    onTap: () async {
                      await _addImage.initImagesPath();
                      setState(() {});
                    },
                    customBorder: CircleBorder(),
                    child: Container(
                      width: responsive.ip(7.0),
                      height: responsive.ip(7.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0, color: Colors.white)
                      ),
                      child: Icon(FontAwesomeIcons.solidImages, size: responsive.ip(2.6), color: Colors.white),
                    ),
                  ),
                  InkWell(
                    customBorder: CircleBorder(),
                    onTap: provider != null && provider.cameraCtrl.value.isInitialized
                      ? () => takePhotoButton(provider, context)
                      : null,
                    child: Container(
                      width: responsive.ip(9.0),
                      height: responsive.ip(9.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 4.0, color: Colors.white, style: BorderStyle.solid)
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(width: 4.0, color: OurColors.lightGreenishBlue, style: BorderStyle.solid)
                        ),
                      )
                    ),
                  ),
                  InkWell(
                    customBorder: CircleBorder(),
                    onTap: () => onNewCameraSelected(provider),
                    child: RotationTransition(
                      turns: Tween(begin: 0.0, end: 0.5).animate(_animationCtrl),
                      child: Container(
                        width: responsive.ip(7.0),
                        height: responsive.ip(7.0),
                        child: Icon(Icons.sync, size: responsive.ip(2.8), color: Colors.white),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(width: 2.0, color: Colors.white, style: BorderStyle.solid)
                        )
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Future<void> takePhotoButton(UIProvider provider, BuildContext context) async {
    try {
      final filePath = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
      await provider.cameraCtrl.takePicture(filePath);
      if (mounted) {
        provider.image = filePath;
        provider.cameraCtrl.dispose();
        Navigator.pushReplacementNamed(context, 'photo');
      }
    } on CameraException {
      return null;
    }
  }

  Future<void> onNewCameraSelected(UIProvider provider) async {
    if (_cameraSelected.lensDirection == CameraLensDirection.front) {
      _animationCtrl.forward();
      _cameraSelected = _addImage.listCamera.last; 
    } else {
      _animationCtrl.reverse();
      _cameraSelected = _addImage.listCamera.first;  
    }
    if (provider.cameraCtrl != null) {
      await provider.cameraCtrl.dispose();
    }
    provider.cameraCtrl = CameraController(_cameraSelected, ResolutionPreset.medium, enableAudio: false);
    provider.cameraCtrl.addListener(() {
      if (mounted) setState(() {});
      if (provider.cameraCtrl.value.hasError) {
        return null;
      }
    });
    try {
      await provider.cameraCtrl.initialize();
    } on CameraException {
      return null;
    }
    if (mounted) {
      setState(() {});
    }
  }
  
}