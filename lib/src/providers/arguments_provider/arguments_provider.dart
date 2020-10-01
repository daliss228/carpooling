import 'package:flutter/material.dart';

class ArgumentsInfo with ChangeNotifier{
  bool _backArrowUsualRoute;

  get getBackArrowUserRoute{
    return this._backArrowUsualRoute;
  }

  set setBackArrowUserRoute( bool backArrowUsualRoute ){
    this._backArrowUsualRoute = backArrowUsualRoute;
  }
}