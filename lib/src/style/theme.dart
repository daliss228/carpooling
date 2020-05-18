import 'dart:ui';
import 'package:flutter/cupertino.dart';


class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFF02d2ec);//7845BD //7B68EE
  static const Color loginGradientEnd = const Color(0xFF0393A5);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: FractionalOffset(0.0, 0.8),
    end: FractionalOffset(0.0, 1.0),
  );
}
