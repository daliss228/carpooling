import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';

class BackgoundWidget extends StatelessWidget {
  final sizeWidget;
  final List<Color> colors;

  const BackgoundWidget({Key key, this.colors, this.sizeWidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return  Transform.rotate(
      angle: -pi / 4.0,
      child: Container(
        width: sizeWidget,
        height: sizeWidget,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: this.colors,
            begin: Alignment.bottomLeft, 
            end: Alignment.topRight,
          ), 
          borderRadius: BorderRadius.circular(responsiveScreen.ip(4)),

        ),
      ),
    );
  }
  
}
