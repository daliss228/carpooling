import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/pax_group_route_page.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
import 'package:flutter_carpooling/src/pages/pax_home_page.dart';
// import 'package:flutter_carpooling/src/pages/driver_home_page.dart';

// homepage con el navigatorbar
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  int _currentIndex = 0;
  AnimationController _animationController;
  Animation<double> _animation;

  final PageStorageBucket _bucket = PageStorageBucket();
  final PageController _pageController = PageController(initialPage: 0, keepPage: true);
  // lista de widgets para mostrar en el apppbar
  final List<Widget> _children = [
    // mostrar pagina de las rutas
    PaxHomePage(key: PageStorageKey('paxhome')), // home pasajero
    PaxGroupRoutes(key: PageStorageKey('paxgroup')),
    // DriverHomePage(), // home pasajero
    // mostrar la pagina del perfil de usuario
    ProfilePage()
  ];

  @override
  void initState() { 
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500), );
    _animation = Tween(begin: 1.0, end: 1.08).animate(CurvedAnimation(curve: Curves.ease, parent: _animationController));
    _animationController.addListener(() {
      print(_animationController.status);
    if (_animationController.status == AnimationStatus.completed){
      _animationController.reverse();
    }
    if (_animationController.status == AnimationStatus.dismissed){
      _animationController.stop();
    }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, 'route')},
        child: Icon(Icons.add, size: 35.0),
        backgroundColor: OurColors.darkPurple,
      ),
      bottomNavigationBar: _bottomAppBar(),
      body: SafeArea(
        child: PageStorage(
          bucket: _bucket,
          child: buildPageView()
        )
      )
    );
  }

  Widget buildPageView() {
    return PageView(
      physics: BouncingScrollPhysics(),
      controller: _pageController,
      onPageChanged: (index) => pageChanged(index),
      children: _children
    );
  }

  Widget _bottomAppBar() {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          Expanded(child: SizedBox()),
          _bottomAppBarItem(FontAwesomeIcons.home, 0),
          _bottomAppBarItem(FontAwesomeIcons.route, 1),
          _bottomAppBarItem(FontAwesomeIcons.userAlt, 2),
          SizedBox(width: 15.0)
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: OurColors.grayishWhite,
    );
  }

  Widget _bottomAppBarItem(IconData icon, int cant) {
    return IconButton(
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: (_currentIndex == cant) ? _animation.value : 1.0,
            child: Icon(icon, color: (_currentIndex == cant) ? OurColors.lightGreenishBlue : OurColors.darkGray)
          );
        },
      ),
      onPressed: () => bottomTapped(cant),
    );
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _animationController.forward();
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index, 
        duration: Duration(milliseconds: 1000), curve: Curves.ease
      );
      _animationController.forward();
    });
  }

}
