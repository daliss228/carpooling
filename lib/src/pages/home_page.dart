import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/pages/routes_list.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Tema;

// homepage con el navigatorbar
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _currentIndex = 0;
  // lista de widgets para mostrar en el apppbar
  final List<Widget> _children = [
    // mostrar pagina de las rutas
    RouteListPage(),
    // mostrar la pagina del perfil de usuario
    ProfilePage()
 ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigator(),
      body: SafeArea(
        // child: _children[_currentIndex]
        child: IndexedStack(
          index: _currentIndex,
          children: _children
        ),
      )
    );
  }

  Widget _bottomNavigator() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xfff6f6f6),
        primaryColor: Tema.Colors.loginGradientEnd
      ),
      child: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        }, 
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.car, size: 30.0),
            title: Container()
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Container()
          ),
        ]
      ),
    );
  }

}