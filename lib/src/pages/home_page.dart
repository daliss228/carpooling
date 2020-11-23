import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/prefs/user_prefs.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
import 'package:flutter_carpooling/src/pages/pax_home_page.dart';
import 'package:flutter_carpooling/src/pages/driver_home_page.dart';
import 'package:flutter_carpooling/src/pages/pax_group_route_page.dart';
import 'package:flutter_carpooling/src/providers/arguments_provider.dart';

// homepage con el navigatorbar
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  
  int _currentIndex = 0;
  UserPreferences _prefs;
  Animation<double> _animation;
  AnimationController _animationController;
  final _pageController = PageController(initialPage: 0, keepPage: true);
  final _childrenPax = [
    PaxHomePage(),
    PaxGroupRoutes(),
    ProfilePage()
  ];
  final _childrenDriver = [
    DriverHomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    _prefs = UserPreferences();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _animation = Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(curve: Curves.ease, parent: _animationController));
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reverse();
      }  else if (_animationController.status == AnimationStatus.dismissed){
        _animationController.stop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool mode = _prefs.mode == 'CONDUCTOR';
    final responsiveScreen = Responsive(context);
    final argumentsInfo = Provider.of<ArgumentsInfo>(context);
    final showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      extendBody: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: showFab ? (mode
      ? FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, 'route')},
        child: Icon(Icons.add, size: responsiveScreen.ip(2.5)),
        backgroundColor: OurColors.darkPurple,
      )
      : FloatingActionButton(
        onPressed: () {
          argumentsInfo.backArrowUserRoute = true;
          Navigator.pushNamed(context, 'usualRoute');
        },
        child: Icon(
          Icons.search,
          size: responsiveScreen.ip(2.5),
        ),
        backgroundColor: OurColors.darkPurple,
      )) : null,
      bottomNavigationBar: mode ? _bottomAppBarDriver(responsiveScreen) : _bottomAppBarPax(responsiveScreen),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => pageChanged(index),
        children: mode ? _childrenDriver : _childrenPax,
      )
    );
  }

  Widget _bottomAppBarPax(Responsive responsiveScreen) {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          Expanded(child: SizedBox()),
          _bottomAppBarItem(FontAwesomeIcons.home, 0, responsiveScreen),
          _bottomAppBarItem(FontAwesomeIcons.route, 1, responsiveScreen),
          _bottomAppBarItem(FontAwesomeIcons.userAlt, 2, responsiveScreen),
          SizedBox(width: 15.0)
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: OurColors.grayishWhite,
    );
  }

  Widget _bottomAppBarDriver(Responsive responsiveScreen) {
    return BottomAppBar(
      child: Row(
        children: [
          Expanded(child: SizedBox()),
          _bottomAppBarItem(FontAwesomeIcons.home, 0, responsiveScreen),
          _bottomAppBarItem(FontAwesomeIcons.userAlt, 1, responsiveScreen),
          SizedBox(
            width: 15.0,
          )
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: OurColors.grayishWhite,
    );
  }

  Widget _bottomAppBarItem(IconData icon, int cant, Responsive responsiveScreen) {
    return IconButton(
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: (_currentIndex == cant) ? _animation.value : 1.0,
            child: Icon(icon,
              size: responsiveScreen.ip(2.8),
              color: (_currentIndex == cant)
              ? OurColors.lightGreenishBlue
              : OurColors.darkGray
            )
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
    _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }


}