import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';
import 'package:flutter_carpooling/src/widgets/list_view_widget.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Tema;


class PaxGroupRoutes extends StatefulWidget {

  PaxGroupRoutes({Key key}) : super(key: key);

  @override
  _PaxGroupRoutesState createState() => _PaxGroupRoutesState();
}

class _PaxGroupRoutesState extends State<PaxGroupRoutes> with AutomaticKeepAliveClientMixin {

  RouteService _routeService = RouteService();
  List<RouteModel> _routes = List<RouteModel>();


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _routeService.routesInMyGroup();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _responsiveScreen = Responsive(context); 
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
                            'Todas las Rutas',
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
        stream: _routeService.routesInMyGroupStream,
        builder: (_, AsyncSnapshot<List<RouteModel>> snapshot){
          if(snapshot.hasData){
            return ListViewWidget(routes: snapshot.data.toSet().toList(), moreData: _routeService.routesInMyGroup,);
          }else{
            return CircularProgressIndicator();
          }
        }
      ),
    );
  }
}