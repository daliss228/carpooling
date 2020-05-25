import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Tema;

// appbar del home
class BottomNavigator extends StatelessWidget {
  final int _currentIndex;
  final Function(int) _onTabTapped;
  BottomNavigator(this._currentIndex, this._onTabTapped);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xfff6f6f6),
        primaryColor: Tema.Colors.loginGradientEnd
      ),
      child: BottomNavigationBar(
        onTap: _onTabTapped, 
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.car, size: 30.0),
            title: Container()
          ),
          // NO BORRAR SIRVE PARA PRÓXIMAS IMPLEMENTACIONES
          // BottomNavigationBarItem(
          //   icon: Icon(FontAwesomeIcons.bell),
          //   title: Container()
          // ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Container()
          ),
        ]
      ),
    );
  }
}