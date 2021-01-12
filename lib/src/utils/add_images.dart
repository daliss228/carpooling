import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:storage_path/storage_path.dart';
import 'package:flutter_carpooling/src/models/file_model.dart';

class AddImage {
  
  static final AddImage _instance = AddImage._internal();

  factory AddImage() => _instance;

  AddImage._internal();

  List<FileModel> listPath = List<FileModel>();
  List<CameraDescription> listCamera = List<CameraDescription>();

  Future<void> initImagesPath() async {
    if (listPath.length == 0) {
      listPath = await this._getImagesPath();
    }
  }

  Future<void> initCamerasDescrip() async {
    if (listCamera.length == 0) {
      listCamera = await this._getCamerasDescription();
    }
  }

  Future<List<FileModel>> _getImagesPath() async {
    try {
      final result = await StoragePath.imagesPath;
      final imagesPath = FileModel.fileModelFromJson(result);
      List<String> allPaths = List<String>();
      imagesPath.forEach((file) { allPaths.addAll(file.files);});
      imagesPath.insert(0 , FileModel(folderName: 'Galería', files: allPaths));
      return imagesPath;  
    } on PlatformException {
      return [];
    }
    
  }

  Future<List<CameraDescription>> _getCamerasDescription() async {
    try {
      List<CameraDescription> cameras = List<CameraDescription>(2);
      final result = await availableCameras();
      for (CameraDescription cameraDescription in result) {
        if (cameraDescription.lensDirection == CameraLensDirection.front) {
          cameras[0] = cameraDescription;
        } if (cameraDescription.lensDirection == CameraLensDirection.back) {
          cameras[1] = cameraDescription;
        }
      }
      return cameras;
    } on CameraException {
      return [];
    }
  }
  
}