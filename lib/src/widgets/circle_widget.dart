import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  
  final double radius; 
  final List<Color> colors;

  CircleWidget({Key key, @required this.radius, @required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(this.radius), 
        gradient: LinearGradient(
          colors: this.colors, 
          begin: Alignment.bottomLeft, 
          end: Alignment.topRight,
        )
      ),
    );
  }
}
