import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/widgets/navigationbar_widget.dart';

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
    // mostrar pagina de las rutas con el input search
    // ListView(
    //   padding: EdgeInsets.all(10.0),
    //   children: <Widget>[
    //     Container(padding: EdgeInsets.symmetric(vertical: 20.0), child: SearchTextFrom()),
    //     CardWidget(),
    //     // SizedBox(height: 10.0),
    //   ],
    // ),
    // mostrar la pagina del perfil de usuario
    // ProfilePage()
 ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NO BORRAR, INPUT DEL SEARCH OPCIONAL
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   centerTitle: false,
      //   title: Text('Carpooling', style: TextStyle(fontSize: 20.0, fontFamily: "WorkSansSemiBold", color: Tema.Colors.loginGradientEnd)),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.search),
      //       onPressed: (){},
      //     )
      //   ],
      //   iconTheme: IconThemeData(
      //     color: Tema.Colors.loginGradientEnd,
      //   ),
      // ),
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