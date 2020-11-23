import 'dart:math' as math;
import 'package:flutter/material.dart';

class Responsive {

  double _width, _height, _inch; 

  Responsive(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height; 
    _inch = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2)); 
  }

  double wp(double percent) {
    return _width * percent/100;
  }

  double hp(double percent) {
    return _height * percent/100;
  }
  
  double ip(double percent) {
    return _inch * percent/100;
  }

}