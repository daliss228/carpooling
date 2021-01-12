import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';

class DataSearch extends SearchDelegate {

  final String route;
  final _routeService = RouteService();

   DataSearch({@required this.route});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final responsiveScreen = Responsive(context);
    return theme.copyWith(
      textTheme: TextTheme(
        headline6: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2.1), color: Colors.white)
      ),
      primaryColor: OurColors.initialPurple,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2.1), color: Colors.white)
      )
    );
  }

  // acciones del appbar
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = '';
      }),
    ];
  }

  // icono a la izquierda del appbar
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
      ), 
      onPressed: () => close(context, null)
    );
  }

  // resultados que se va a mostrar
  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  // sugerencias que aparecen cuando la persona escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    final responsiveScreen = Responsive(context);
    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: _routeService.searchRouteByText(query),
      builder: (BuildContext context, AsyncSnapshot<ValidatorResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: LoadingWidget());
        } else {
          if (!snapshot.data.status) {
            return Center(child: Text("No se ha encontrado ninguna dirección...", style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(2), color: OurColors.black), textAlign: TextAlign.center));
          } else {
            final List<PlacesSearchResult> results = snapshot.data.data;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int i) {
                return Consumer<MapProvider>(builder: (context, provider, child) { 
                  return ListTile(
                    title: Text(results[i].name, style: TextStyle(fontFamily: "WorkSansRegular", fontSize: responsiveScreen.ip(1.8), color: OurColors.black)),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      provider.description = results[i].name;
                      Location location = results[i].geometry.location;
                      provider.auxiliary = true;
                      provider.setMarkers = LocalityModel(lat: location.lat, lng: location.lng);
                      provider.kGooglePlex = CameraPosition(target: LatLng(location.lat, location.lng), zoom: 16);
                      provider.geolocation = LocalityModel(lat: location.lat, lng: location.lng);
                      Navigator.pushNamed(context, this.route);
                    }
                  );
                });
              }
            );    
          }
        }
      }
    );
  }

}