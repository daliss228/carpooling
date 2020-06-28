import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; 

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SpinKitDoubleBounce(
          color: Color(0xFF0393A5),
          size: 70.0,
        ),
      ),  
    );
  }
}