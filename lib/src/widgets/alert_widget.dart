import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';

void showAlert(BuildContext context, String title, IconData icon, String message){
  final responsiveScreen = Responsive(context);
  showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: responsiveScreen.ip(2), fontFamily: 'WorkSansSemiBold', color: OurColors.black),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: responsiveScreen.ip(10)),
            SizedBox(height: 20.0),
            Text(
              message,
              style: TextStyle(fontSize: responsiveScreen.ip(1.7), fontFamily: 'WorkSansRegular', color: OurColors.black),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(onPressed: ()=> Navigator.of(context).pop(), child: Text('OK', style: TextStyle(fontFamily: 'WorkSansSemiBold', color: OurColors.lightGreenishBlue, fontSize: responsiveScreen.ip(2))))
        ],
      ); 
    }
  );
}

class AlertWidget extends StatelessWidget {

  final String title;
  final String message;
  final IconData icon;
  final Function onPressed;
  AlertWidget({@required this.title, @required this.icon, @required this.message, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: AlertDialog(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: responsiveScreen.ip(2), fontFamily: 'WorkSansSemiBold'),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: responsiveScreen.ip(10)),
            SizedBox(height: 20.0),
            Text(
              message,
              style: TextStyle(fontSize: responsiveScreen.ip(1.7), fontFamily: 'WorkSansRegular'),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => this.onPressed(),
            child: Text('OK', style: TextStyle(fontFamily: 'WorkSansSemiBold', color: Color(0xFF0393A5), fontSize: responsiveScreen.ip(2)))
          )
        ],
      ),
    ); 
  }
}