import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/widgets/list_view_widget.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';

class DriverHomePage extends StatefulWidget {

  const DriverHomePage({Key key}) : super(key: key);

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> with AutomaticKeepAliveClientMixin {

  final _routeService = new RouteService();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _routeService.myCreatedRoutes();
  }

  @override
  Widget build(BuildContext context) {
  final _responsiveScreen = Responsive(context); 
    super.build(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            left: _responsiveScreen.wp(75),
            child: FadeInRight(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(34),))
          ),
          Positioned(
            top: _responsiveScreen.hp(1),
            left: _responsiveScreen.wp(75),
            child: FadeInRight(
              delay: Duration(milliseconds: 500),
              child: BackgoundWidget(colors: [OurColors.initialPurple, OurColors.finalPurple], sizeWidget: _responsiveScreen.hp(30),)
            )
          ),
          Positioned(
            top: _responsiveScreen.hp(70),
            right: _responsiveScreen.wp(75),
            child: FadeInLeft(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(30),))
          ),
          SafeArea(
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: _responsiveScreen.hp(3),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: FadeInLeft(
                            child: Text(
                              'Mis Rutas',
                              style: TextStyle(
                                fontSize: _responsiveScreen.ip(4),
                                fontFamily: 'WorkSansLight'
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()) 
                      ],
                    ),
                    _listRoutes()
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listRoutes() {
    return Container(
      child: StreamBuilder(
        stream: _routeService.myCreatedRouteStream,
        builder: (_ , AsyncSnapshot<List<RouteModel>> snapshot){
          if(snapshot.hasData){
            return ListViewWidget(routes: snapshot.data, moreData: _routeService.myCreatedRoutes,);
          }else{
            return CircularProgressIndicator();
          }
        }
      ),
    );

  }

}
