import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RutaUsualPage extends StatefulWidget {
  @override
  _RutaUsualPageState createState() => _RutaUsualPageState();
}

class _RutaUsualPageState extends State<RutaUsualPage> {
  GoogleMapController mapController; 
  String searchAddress;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(-0.277369, -78.557692), 
              zoom: 15.0 
            ),
          ),
          Positioned(
            top: 50.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white, 
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "¿Cuál es tu ruta diaria?",
                  border: InputBorder.none, 
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0), 
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.blueAccent,), 
                    onPressed: (){},//searchandNavigate(),
                    iconSize: 30.0,
                  )
                ),
                onChanged: (val){
                  setState(() {
                    searchAddress = val;
                  });
                },
              ),
            ),
          )

        ],
      )
    );
  }


  //searchandNavigate() {
  //  Geolocator().placemarkFromAddress(searchAddress).then((result) {
  //    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //        target:
  //            LatLng(result[0].position.latitude, result[0].position.longitude),
  //        zoom: 10.0)));
  //  });
  //}




  void onMapCreated(controller){
    setState(() {
      mapController = controller; 
    });
  }



}