import 'package:path/path.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';


class TakePicture extends StatefulWidget {
  final CameraDescription camera;
  TakePicture({@required this.camera});

  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {

  CameraController _cameraController;
  Future<void> _initilizeCameraController;

  @override
  void initState() { 
    _cameraController = CameraController(widget.camera, ResolutionPreset.medium);
    _initilizeCameraController = _cameraController.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Widget _buttonComeback(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: CupertinoButton(
          padding: EdgeInsets.all(10.0),
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.black26,
          child: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          }
        ),
      ),
    );
  }

  Future<void> _takePiture(BuildContext context) async {
    try {
      final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
      await _initilizeCameraController;
      await _cameraController.takePicture(path);
      Navigator.pop(context, path);
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final _responsiveScreen = new Responsive(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: OurColors.grayishWhite,
        child: Icon(Icons.camera, size: _responsiveScreen.ip(3.0), color: OurColors.darkPurple),
        onPressed: () => _takePiture(context),
      ),
      body: Stack(
        children: [
          FutureBuilder(
          future: _initilizeCameraController,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_cameraController);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
          ),
          _buttonComeback(context)
        ],
      ),
    );
  }
}