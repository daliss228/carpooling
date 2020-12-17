import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/pages/home_page.dart';
import 'package:flutter_carpooling/src/pages/mode_page.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/services/auth_service.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';

class AfterLayoutWidget extends StatelessWidget {

  final _prefs = UserPreferences();
  final _userService = UserService();
  
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return FutureBuilder(
      future: _userService.readUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['ok']) {
            userProvider.user = snapshot.data['value'];
            if (userProvider.user.coordinates != null) {
              _prefs.lat = userProvider.user.coordinates.lat.toString();
              _prefs.lng = userProvider.user.coordinates.lng.toString();
            }
            if(_prefs.mode.toString().isEmpty){
              return ModePage();
            }else if(_prefs.mode.toString() == 'PASAJERO'){
              return HomePage();
            }else {
              return HomePage();
            }
          } else {
            return AlertPage(message: snapshot.data['message']);
          }
        } else {
          return LoadingWidget();
        }
      }
    );
  }

}

class AlertPage extends StatelessWidget {
  final String message;
  AlertPage({@required this.message});

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = new Responsive(context); 
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            right: responsiveScreen.wp(75),
            child: FadeInLeft(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: responsiveScreen.hp(34)))
          ),
          Positioned(
            top: responsiveScreen.hp(1),
            right: responsiveScreen.wp(75),
            child: FadeInLeft(
              delay: Duration(milliseconds: 500),
              child: BackgoundWidget(sizeWidget: responsiveScreen.hp(30), colors: [OurColors.initialPurple, OurColors.finalPurple])
            )
          ),
          Positioned(
            top: responsiveScreen.hp(70),
            left: responsiveScreen.wp(75),
            child: FadeInRight(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: responsiveScreen.hp(30)))
          ),
          AlertWidget(
            title: 'Ups!', 
            icon: Icons.sentiment_very_dissatisfied,
            message: this.message,
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
      )
    );
  }
}