import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/widgets/card_widget.dart';

class ListViewWidget extends StatelessWidget {

  final List<RouteModel> routes;
  final Future<void> Function() onRefresh;

  const ListViewWidget({@required this.routes, @required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final _responsiveScreen = Responsive(context);
    ScrollController _gridController = ScrollController();
    _gridController.addListener(() {
      if(_gridController.position.pixels == _gridController.position.maxScrollExtent){
        double spaceFinal;
        switch (this.routes.length) {
          case 1:
            spaceFinal = _gridController.position.maxScrollExtent - _responsiveScreen.hp(70);
            break;
          case 2:
            spaceFinal = _gridController.position.maxScrollExtent - _responsiveScreen.hp(45);
            break;
          case 3:
            spaceFinal = _gridController.position.maxScrollExtent - _responsiveScreen.hp(20);
            break;
          case 4:
            spaceFinal = _gridController.position.maxScrollExtent - _responsiveScreen.hp(5);
            break;
          default: 
            spaceFinal = _gridController.position.maxScrollExtent;
        }
        _gridController.animateTo(
          spaceFinal, 
          duration: Duration(milliseconds: 500), 
          curve: Curves.easeIn
        );
      }
    });
    
    return RefreshIndicator(
      onRefresh: this.onRefresh,
      color: OurColors.grayishWhite,
      backgroundColor: OurColors.initialPurple,
      child: ListView.builder(
        controller: _gridController,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
        itemCount: (this.routes != null) ? this.routes.length + 1 : 1,
        itemBuilder: (BuildContext context, int i){
          final seats = numAvalibleSeats(routes);
          if (this.routes.length == 0) {
            return thereAreNoRoutes(_responsiveScreen);
          } else if (i < this.routes.length) {
            return CardWidget(route: this.routes[i], seatsAvailable: seats[i]);
          } else {
            switch (this.routes.length) {
              case 1 :
                return Container(height: _responsiveScreen.hp(70));
              case 2 :
                return Container(height: _responsiveScreen.hp(45));
              case 3 :
                return Container(height: _responsiveScreen.hp(20));
              case 4 :
                return Container(height: _responsiveScreen.hp(5));
              default :
                return Container(height: _responsiveScreen.hp(0));
            }
          }
        },
      ),
    );
  }

  Widget thereAreNoRoutes(Responsive responsiveScreen) {
    return Container(
      height: responsiveScreen.hp(80),
      child: Center(
        child: Text(
          'Aún no hay rutas registradas...',
          style: TextStyle(
            fontSize: responsiveScreen.ip(2),
            fontFamily: 'WorkSansLight'
          ),
        )
      ),
    );
  }
}