import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Thema;

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

class LoadingTwoWidget extends StatelessWidget {

  final double size;

  LoadingTwoWidget({@required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDoubleBounce(
        color: Thema.OurColors.lightGreenishBlue,
        size: this.size,
      ),
    );
  }
  
}