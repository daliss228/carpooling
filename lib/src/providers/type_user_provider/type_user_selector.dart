import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/providers/user_provider/user_provider.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class TypeUserSelector extends StatefulWidget {
  @override
  UserSelectorState createState() => UserSelectorState();
}

class UserSelectorState extends State<TypeUserSelector> with AfterLayoutMixin {
  final UserPreferences _prefs = new UserPreferences();

  @override
  void afterFirstLayout(BuildContext context) {
    if( _prefs.mode.toString().isEmpty ){
      Navigator.pushReplacementNamed(context, 'mode');
    }else if(_prefs.mode.toString() == 'PASAJERO'){
      Navigator.pushNamed(context, 'home');
    }else if(_prefs.mode.toString() == 'CONDUCTOR'){
      Navigator.pushReplacementNamed(context, 'home');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfo>(context);
    _getUserFromDBtoProvider(userInfo);
    return LoadingWidget();
  }

  // carga toda la informacion del usuario en el estado
  _getUserFromDBtoProvider(UserInfo userInfo) async {
    final _userService = new UserService();
    final info = await _userService.readUser();
    UserModel user = info['value'];
    userInfo.setUserModel = user;
    _prefs.uidGroup = user.uidGroup;
  }

}