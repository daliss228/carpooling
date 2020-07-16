import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  
  final double radius; 
  final List<Color> colors;
  const CircleWidget({Key key, @required this.radius, @required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            blurRadius: 3.0,
            offset: Offset(0.0, 5.0), 
            spreadRadius: 3.0
          )
        ],
        borderRadius: BorderRadius.circular(this.radius), 
        gradient: LinearGradient(
          colors: this.colors, 
          begin: Alignment.topCenter, 
          end: Alignment.bottomCenter,
        )
      ),
      child: Center(
        child: Container(
          height: radius * 1.3,
          width: radius * 1.3,
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black45, 
                blurRadius: 3.0, 
                offset: Offset(0.0, 5.0), 
                spreadRadius: 3.0
              )
            ],
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors:[Colors.white, Colors.white], 
            )
          ),
        )
      ),
    );
  }
}

class CircleTwoWidget extends StatelessWidget {
  
  final double radius; 
  final List<Color> colors;
  const CircleTwoWidget({Key key, @required this.radius, @required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(this.radius), 
        gradient: LinearGradient(
          colors: this.colors, 
          begin: Alignment.topCenter, 
          end: Alignment.bottomCenter,
        )
      ),
      child: Center(
        child: Container(
          height: radius * 1.3,
          width: radius * 1.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors:[Colors.white, Colors.white], 
            )
          ),
        )
      ),
    );
  }
}