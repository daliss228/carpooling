import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/driver_home_.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
// import 'package:flutter_carpooling/src/pages/pax_home_page.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/navigationbar_widget.dart';

// homepage con el navigatorbar
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final usuarioService = new UsuarioService();
  int _currentIndex = 0;

  // lista de widgets para mostrar en el apppbar
  final List<Widget> _children = [
    // mostrar pagina de las rutas
    // PaxHomePage(),
    DriverHomePage(),
    // mostrar la pagina del perfil de usuario
    ProfilePage()
 ];

  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();

    return Scaffold(
      // Solo estoy usando el app bar para obtener un boton mientras se desarrolla la interfaz
      appBar: AppBar(
        title: Text('Provisional BAR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app), 
            onPressed: () async {
              await usuarioService.signOut();
              setState(() {
                prefs.token = '';
                prefs.uid = '';
              });
              Navigator.pushReplacementNamed(context, 'login');
            }
          )
        ],
      ),
      bottomNavigationBar: BottomNavigator(_currentIndex, onTabTapped),
      body: SafeArea(child: _children[_currentIndex])
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}