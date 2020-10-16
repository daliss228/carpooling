import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/card_widget.dart';

class ListViewWidget extends StatelessWidget {
  final List<RouteModel> routes;
  final moreData;

  const ListViewWidget({Key key, @required this.routes, this.moreData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _responsiveScreen = Responsive(context);
    final _gridController = new ScrollController();

    _gridController.addListener(() {
      if(_gridController.position.pixels == _gridController.position.maxScrollExtent){
        double spaceFinal;
        switch (routes.length) {
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
    
    return Expanded(
      child: routes.length > 0 ? RefreshIndicator(
        onRefresh: moreData,
        color: OurColors.grayishWhite,
        backgroundColor: OurColors.initialPurple,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: _gridController,
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          itemBuilder: (BuildContext context, int i){
            //final seats = numAvalibleSeats(routes);
            if(i < routes.length){
              return CardWidget(route: routes[i]);
            }else{
              switch (routes.length) {
                case 1 :
                  return Container(height: _responsiveScreen.hp(70));
                case 2 :
                  return Container(height: _responsiveScreen.hp(45));
                case 3 :
                  return Container(height: _responsiveScreen.hp(20));
                case 4 :
                  return Container(height: _responsiveScreen.hp(5));
                default:
                  return Container(height: _responsiveScreen.hp(0));
              }
            }
          },
          itemCount: routes.length + 1,
        ),
      ) : RefreshIndicator(
        onRefresh: moreData,
        color: Colors.white,
        backgroundColor: OurColors.initialPurple,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: _responsiveScreen.hp(55) - _responsiveScreen.ip(10),
                  ),
                  Center(
                    child: Text(
                      'Aún no hay rutas registradas ...',
                      style: TextStyle(
                        fontSize: _responsiveScreen.ip(2),
                        fontFamily: 'WorkSansLight'
                      ),
                    )
                  ),
                  Container(
                    height: _responsiveScreen.hp(55) - _responsiveScreen.ip(10),
                  ),
                ],
              )
            ),
          ],
        ),
      )     
    );
  }
}