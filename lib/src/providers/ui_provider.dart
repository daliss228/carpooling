import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class UIProvider with ChangeNotifier {

  String _image;
  bool _backArrow;
  CameraController _cameraCtrl;

  String get image => this._image;
  bool get backArrow => this._backArrow;
  CameraController get cameraCtrl => this._cameraCtrl;

  set image(String image) {
    this._image = image;
    notifyListeners();
  }

  set backArrow(bool backArrow){
    this._backArrow = backArrow;
    notifyListeners();
  }

  set cameraCtrl(CameraController cameraCtrl) {
    this._cameraCtrl = cameraCtrl;
    notifyListeners();
  }
  
}