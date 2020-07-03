import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Tema;

// funcionalidad para subir imagen a firebase
class UploaderImage extends StatefulWidget {

  final File file;
  UploaderImage({Key key, @required this.file}) : super(key: key);

  createState() => _UploaderImageState();
}

class _UploaderImageState extends State<UploaderImage> {

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://dev-carpooling.appspot.com');
  StorageUploadTask _uploadTask;
  String downloadUrl;

  // _startUpload() {
  //   String filePath = 'images/${DateTime.now()}.png';
  //   setState(() {
  //     _storage.ref().child(filePath).putFile(widget.file);
  //     print('Imagen subida');
  //     // Navigator.pushReplacementNamed(context, '/');
  //   });
  // }

  _startUpload() async {
    String _urlphoto;
    // try {
      String filePath = "${DateTime.now()}.png";
       _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
      StorageTaskSnapshot storageTaskSnapshot = await _uploadTask.onComplete;
      downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      print('Imagen subida');
      print(downloadUrl);
    // } catch (error) {
      
    // }
    // return _urlphoto;
  }

  @override
  Widget build(BuildContext context) {
    // Agregar un loading
    if (_uploadTask != null) {
      // return StreamBuilder<StorageTaskEvent>(
      //   stream: _uploadTask.events,
      //   builder: (context, snapshot) {
      //     var event = snapshot?.data?.snapshot;
      //     print('-------------------------------');
      //     print('event: $event');
      //     double progressPercent = event != null
      //       ? event.bytesTransferred / event.totalByteCount
      //       : 0;
      //     return Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         LinearProgressIndicator(value: progressPercent),
      //       ]
      //     );
      //   }
      // );
      return StreamBuilder<StorageTaskEvent>(
      stream: _uploadTask.events,
      builder: (BuildContext context, snapshot) {
        var asd = snapshot.hasData;
        if (asd) {
        //   StorageTaskEvent event = snapshot.data;
        //   print('---------------------');
        //   print('event: ${event.type}');
        //   return Container(
        //     child: (event.type == StorageTaskEventType.progress)
              
        //       ? Text('complete: $downloadUrl')
        //       : CircularProgressIndicator()
        //   );
        // } else {
          return Text('complete: $downloadUrl');

        } else {
          return CircularProgressIndicator();
        }
      },
    );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Continuar', style: TextStyle(fontSize: 18.0, fontFamily: "WorkSansMedium", color: Colors.white)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)
              ),
              color: Tema.Colors.loginGradientEnd,
              textColor: Colors.white,
              elevation: 5.0,
              onPressed: _startUpload,
            )
          ],
        ),
      );
    }
  }
}