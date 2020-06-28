import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context, String titulo ,String mensaje){
  showDialog(
    context: context, 
    builder: (context){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), 
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          title: Text(
            titulo,
            style: TextStyle(fontSize: 20.0, fontFamily: 'WorkSansSemiBold', fontWeight: FontWeight.w300),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.sentiment_dissatisfied, size: 90.0,),
              SizedBox(height: 20.0,),
              Text(
                mensaje,
                style: TextStyle(fontSize: 15.0, fontFamily: 'WorkSans', fontWeight: FontWeight.w300),
              ),
              
            ],
          ),
          actions: <Widget>[
            FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('OK', style: TextStyle(fontSize: 20.0, fontFamily: 'WorkSansSemiBold', fontWeight: FontWeight.w300, color: Color(0xFF0393A5)),))
          ],
        ),
      ); 
    }
  );
}