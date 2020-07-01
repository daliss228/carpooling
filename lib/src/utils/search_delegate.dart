import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_carpooling/src/models/routes_model.dart';
import 'package:google_maps_webservice/places.dart';

GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: "AIzaSyDGTNY3kaJaonzA8idDWA4lbxLvWJQDlNg");

class DataSearch extends SearchDelegate{

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
      future: searchPlaceByText(query),
      builder: (context, AsyncSnapshot<List<PlacesSearchResult>> snapshot){
        if(snapshot.hasData){
          var results = snapshot.data;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, int i){
              return ListTile(
                title: Text(results[i].name),
                onTap: (){
                  Location location = results[i].geometry.location;
                  // showResults(context);
                  // Navigator.pushNamed(context, 'viaje', arguments: '${results[i].geometry.location.lat}/${results[i].geometry.location.lng}/${results[i].name}');
                  Navigator.pushNamed(context, 'viaje', arguments: Locality(lat: location.lat, lng: location.lng));
                },
              );
            }
          );
        } else {
          return Center(child: CupertinoActivityIndicator(radius: 30.0));
        }
      },
    );
  }
  
}

Future<List<PlacesSearchResult>> searchPlaceByText(String destino) async {
  Location location = Location(-0.198964, -78.505659);
  final result = await places.searchByText(destino, location: location, radius: 25000, language: 'es');
  print(result);
  if (result.status == "OK") {
    return result.results;
  } else {
    return [];
  }
}