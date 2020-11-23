import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';

class UserSelector extends StatefulWidget {
  @override
  _UserSelectorState createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> with AfterLayoutMixin {

  final _prefs = UserPreferences();
  final _userService = UserService();

  @override
  void afterFirstLayout(BuildContext context) {
    if(_prefs.mode.toString().isEmpty){
      Navigator.pushReplacementNamed(context, 'mode');
    }else if(_prefs.mode.toString() == 'PASAJERO'){
      Navigator.pushNamed(context, 'home');
    }else if(_prefs.mode.toString() == 'CONDUCTOR'){
      Navigator.pushReplacementNamed(context, 'home');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    _getDataUser(userProvider);
    return LoadingWidget();
  }

  // carga toda la informacion del usuario en el estado
  Future<void> _getDataUser(UserProvider userProvider) async {
    final userResult = await _userService.readUser();
    if (userResult['ok']) {
      userProvider.user = userResult['value'];
      _prefs.uidGroup = userProvider.user.idGroup;
      if (userProvider.user.coordinates != null) {
        _prefs.lat = userProvider.user.coordinates.lat.toString();
        _prefs.lng = userProvider.user.coordinates.lng.toString();
      }
    }
  }

}