import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';

class GeodecoderWidget extends StatelessWidget {

  final Color color;

  GeodecoderWidget({@required this.color});

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Consumer<MapProvider>(
      builder: (BuildContext context, MapProvider mapProvider, Widget child){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: (mapProvider.geolocation != null && !mapProvider.auxiliary) 
          ? FutureBuilder(
            future: Geocoder.local.findAddressesFromCoordinates(Coordinates(mapProvider.geolocation.lat, mapProvider.geolocation.lng)),
            builder: (BuildContext context, AsyncSnapshot<List<Address>> snapshot){
              if (snapshot.hasData) {
                mapProvider.description = snapshot.data.first.addressLine;
                return Text(mapProvider.description.length > 85 ? mapProvider.description.replaceRange(85, mapProvider.description.length, '...') : mapProvider.description, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.9), color: this.color));
              } else {
                return Center(child: LoadingTwoWidget(size: 25.0));
              }
            },
          ) 
          : ((mapProvider.geolocation != null && mapProvider.auxiliary) 
          ? Text(mapProvider.description, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.9), color: this.color))
          : Text(
            'Elije un destino en el mapa!', 
            style: TextStyle(
              fontFamily: "WorkSansMedium", 
              fontSize: responsiveScreen.ip(2), 
              color: this.color
            ),
          )),
        );
      }
    );
  }
}