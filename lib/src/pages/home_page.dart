import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/pages/driver_home_page.dart';
import 'package:flutter_carpooling/src/providers/arguments_provider/arguments_provider.dart';
import 'package:flutter_carpooling/src/providers/type_user_provider/type_user_info_provider.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/pages/profile_page.dart';
import 'package:flutter_carpooling/src/pages/pax_home_page.dart';
import 'package:flutter_carpooling/src/pages/pax_group_route_page.dart';
import 'package:provider/provider.dart';

// homepage con el navigatorbar
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  
  int _currentIndex = 0;
  AnimationController _animationController;
  Animation<double> _animation;

  final _bucket = PageStorageBucket();
  final  _pageController = PageController(initialPage: 0, keepPage: true);

  final _childrenPax = [
    PaxHomePage(key: PageStorageKey('paxhome')),
    PaxGroupRoutes(key: PageStorageKey('paxgroup')),
    ProfilePage()
  ];

  final _childrenDriver = [
    DriverHomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(curve: Curves.ease, parent: _animationController));
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (_animationController.status == AnimationStatus.dismissed) {
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _typeUser = Provider.of<TypeUser>(context);
    final _argumentsInfo = Provider.of<ArgumentsInfo>(context);
    final _responsiveScreen = new Responsive(context);
    bool _mode = _typeUser.getTypeuser == 'CONDUCTOR';
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: _mode
      ? FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, 'route')},
        child: Icon(Icons.add, size: _responsiveScreen.ip(2.5)),
        backgroundColor: OurColors.initialPurple,
      )
      : FloatingActionButton(
        onPressed: () {
          _argumentsInfo.setBackArrowUserRoute = true;
          Navigator.pushNamed(context, 'usualRoute');
        },
        child: Icon(
          Icons.search,
          size: _responsiveScreen.ip(2.5),
        ),
        backgroundColor: OurColors.initialPurple,
      ),
      bottomNavigationBar: _mode ? _bottomAppBarDriver() : _bottomAppBarPax(),
      body: PageStorage(
        bucket: _bucket,
        child: PageView(
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) => pageChanged(index),
          children: _mode ? _childrenDriver : _childrenPax,
        )
      )
    );
  }

  Widget _bottomAppBarPax() {
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

  Widget _bottomAppBarDriver() {
    return BottomAppBar(
      child: Row(
        children: [
          Expanded(child: SizedBox()),
          _bottomAppBarItem(FontAwesomeIcons.home, 0),
          _bottomAppBarItem(FontAwesomeIcons.userAlt, 1),
          SizedBox(
            width: 15.0,
          )
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
            child: Icon(icon,
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
      _animationController.forward();
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 1000), curve: Curves.ease);
      _animationController.forward();
    });
  }
}

// https://github.com/flutter/flutter/issues/17555
