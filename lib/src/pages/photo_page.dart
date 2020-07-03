import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Theme;
import 'package:flutter_carpooling/src/widgets/uploader_widget.dart';

// pagina para capturar o elegir la imagen
class PhotoPage extends StatefulWidget {
  
  createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  // archivo de imagen
  File _imageFile;

  // seleccionar una imagen de la galeria o abrir la camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source, maxWidth: 500, maxHeight: 500);
    setState(() {
      _imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size; 
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
      body: ListView(
        children: (_imageFile == null) ? <Widget>[] : <Widget>[
          SizedBox(height: _screenSize.height * 0.1),
          Container(
            padding: EdgeInsets.all(32),
            child:  Image.file(_imageFile)
          ),
          Container(
            padding: EdgeInsets.only(right: 32, bottom: 32, left: 32),
            child:  UploaderImage(
              file: _imageFile,
            ),
          )
        ]
      ),
    );
  }
}