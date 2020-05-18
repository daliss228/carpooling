import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Theme;
import 'package:flutter_carpooling/src/widgets/uploader_widget.dart';

// pagina para capturar o elegir la imagen
class ImageCapturePage extends StatefulWidget {
  createState() => _ImageCapturePageState();
}

class _ImageCapturePageState extends State<ImageCapturePage> {
  
  final estilo = TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansSemiBold");
  // archivo de imagen
  File _imageFile;

  // seleccionar una imagen de la galeria
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  // quitar imagen
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Theme.Colors.loginGradientEnd,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Theme.Colors.loginGradientEnd,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            if (_imageFile != null) ...[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Image.file(_imageFile)
                  ),
                  Positioned(
                    bottom: 32,
                    right: 32,
                    child: IconButton(
                      onPressed: _clear,
                      icon: Icon(Icons.delete, color: Colors.red, size: 32.0),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.only(right: 32, bottom: 32, left: 32),
                child: Uploader(
                  file: _imageFile,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}