import 'package:flutter/material.dart';

class ArgumentsInfo with ChangeNotifier {

  bool _backArrowUsualRoute;

  bool get backArrowUserRoute {
    return this._backArrowUsualRoute;
  }

  set backArrowUserRoute( bool backArrowUsualRoute ){
    this._backArrowUsualRoute = backArrowUsualRoute;
  }
  
}