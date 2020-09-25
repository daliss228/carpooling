import 'package:flutter/material.dart';

class RectangleWidget extends StatelessWidget {

  final List<Color> colors;
  final double width, height; 

  const RectangleWidget({Key key, this.colors, this.width , this.height}) : super(key: key);

    @override
    Widget build(BuildContext context) {
    return Container(
       width: this.width,
       height: this.height,
       decoration: BoxDecoration(
         gradient: LinearGradient(
           begin: FractionalOffset(0.0, 1),
           end: FractionalOffset(0.0, 0.5),
           colors: this.colors
         )
       ),
     );
   }
}