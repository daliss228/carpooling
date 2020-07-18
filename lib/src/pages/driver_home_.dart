import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/widgets/card_widget.dart';
import 'package:flutter_carpooling/src/utils/colors.dart'  as Tema;

class DriverHomePage extends StatefulWidget {

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> with WidgetsBindingObserver {

  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'viaje'),
        child: Icon(Icons.add, size: 35.0),
        backgroundColor: Color(0xFF0393A5),
        // elevation: 2.5,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: _screenSize.width,
            height: _screenSize.height * 0.55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100.0), 
              ),
              gradient: LinearGradient(
                colors: [
                  Tema.OurColors.lightBlue, 
                  Tema.OurColors.lightGreenishBlue
                ]
              )
            ),
          ),
          ListView(
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
            children: <Widget>[
              CardWidget(),
              CardWidget(),
              CardWidget(),
              CardWidget(),
              CardWidget(),
            ],
          ),
        ],
      ),
    );
  }
}