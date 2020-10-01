import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Tema;
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/widgets/list_view_widget.dart';


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
            child: FadeInRight(child: BackgoundWidget(colors: [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(34),))
          ),
          Positioned(
            top: _responsiveScreen.hp(1),
            left: _responsiveScreen.wp(75),
            child: FadeInRight(
              delay: Duration(milliseconds: 500),
              child: BackgoundWidget(colors: [Tema.OurColors.initialPurple, Tema.OurColors.finalPurple], sizeWidget: _responsiveScreen.hp(30),)
            )
          ),
          Positioned(
            top: _responsiveScreen.hp(70),
            right: _responsiveScreen.wp(75),
            child: FadeInLeft(child: BackgoundWidget(colors: [Tema.OurColors.lightBlue, Tema.OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(30),))
          ),
          Container(
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

  Future<void> _getRoutesOfDriver() async {
    print('hola en Driver Home Page Pulsando Boton');
    // Map _readMyRoutes = await _routeService.readMyRegisteredRoutes();
    // print(_readMyRoutes['ok']);
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    final _routes = await _routeService.myCreatedRoutes();
    // final UserPreferences _prefs = new UserPreferences();
    // List<RouteModel> routes = _routes['value']; 
    // print(routes[0].address);
    // print(_routes['ok']);
    // print(_routes['value']);
    // print(_prefs.uidGroup.toString());

  }

}
