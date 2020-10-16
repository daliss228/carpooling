import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';

class DataSearch extends SearchDelegate{
  final String route;
  final String hour;
  final List<bool> days;
  final RouteService _routeService = RouteService();

  DataSearch({ this.route, @required this.days, @required this.hour});

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
    return IconButton(icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: (){
      close(context, null);
    });
  }

  // resultados que se va a mostrar
  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  // sugerencias que aparecen cuando la persona escribe
  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: _routeService.searchRouteByText(query),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot){
        if (!snapshot.hasData) {
          return Center(child: LoadingWidget());
        } else {
          if (!snapshot.data["ok"]) {
            return AlertWidget(title: "Error", message: snapshot.data["message"]);
          } else {
            final List<PlacesSearchResult> results = snapshot.data["value"];
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, int i){
                return ListTile(
                  title: Text(results[i].name),
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    print(this.days);
                    Location location = results[i].geometry.location;
                    Navigator.pushReplacementNamed(context, route , arguments: {
                      'days': this.days,
                      'hour': this.hour,
                      'locality' : LocalityModel(lat: location.lat, lng: location.lng)
                    });
                  },
                );
              }
            );    
          }
        }
      }
    );
  }
}