import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';

class StyleWords {
  
  Responsive responsiveScreen;

  void init(BuildContext context) {
    responsiveScreen  = new Responsive(context);
  }

  static const styleTextHint = TextStyle(fontFamily: "WorkSansLight", fontSize: 16.0);
  static const styleErrorText = TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935));
  static const styleFAB = TextStyle(fontFamily: "WorkSansLight", fontSize: 14.0, color: Colors.black);
  static const styleText = TextStyle(fontFamily: "WorkSansLight", fontSize: 16.0, color: Colors.black);
  static const styleEditText = TextStyle(fontFamily: "WorkSansMedium", color: Colors.black, fontSize: 10.0);
 
}