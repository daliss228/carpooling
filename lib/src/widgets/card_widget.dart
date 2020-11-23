import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/pages/route_detail_page.dart';
import 'package:flutter_carpooling/src/widgets/simple_map_widget.dart';

// card con las rutas de los destinos
class CardWidget extends StatefulWidget {

  final RouteModel route;
  final String seatsAvailable;

  CardWidget({@required this.route, @required this.seatsAvailable});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final responsiveScreen = new Responsive(context);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RouteDetailPage(route: widget.route, seatsAvailable: widget.seatsAvailable))),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(child: Text(widget.route.address, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.9), color: OurColors.darkGray))),
                  SizedBox(width: responsiveScreen.ip(0.5)),
                  Column(
                    children: <Widget>[
                      Text(widget.seatsAvailable, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(3.9), color: OurColors.darkPurple)),
                      Text(widget.seatsAvailable == '1' ? 'Asiento' : 'Asientos', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.6), color: OurColors.darkPurple)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: responsiveScreen.hp(12),
              width: double.infinity,
              child: SimpleMapWidget(latLng: widget.route.coordinates, type: 0)
            ),
            SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}