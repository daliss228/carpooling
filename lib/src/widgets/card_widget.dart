import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
// import 'package:flutter_carpooling/src/widgets/map_widget.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/pages/route_detail_page.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';

// card con las rutas de los destinos
class CardWidget extends StatelessWidget {

  final RouteModel route;
  final String seatsAvailable;

  CardWidget({@required this.route, /*@required*/ this.seatsAvailable});

  @override
  Widget build(BuildContext context) {
    final _responsiveScreen = new Responsive(context);
    return GestureDetector(
      onTap: (){},//() => Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailPage(route: route, seatsAvailable: seatsAvailable))),
      child: Container( 
        height: _responsiveScreen.hp(25), 
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(child: Text(route.address, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 16.0, color: OurColors.darkGray))),
                    Center(
                      child: Column(
                        children: <Widget>[
                          //Text(seatsAvailable, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 25.0, color: OurColors.darkPurple)),
                          Text('Asientos', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 14.0, color: OurColors.darkPurple)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 115,
                // child: MapWidget(latLng: route.coordinates, type: 0)
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }

}