import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';

class MapWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (BuildContext context, MapProvider mapProvider, Widget child){
        return GoogleMap(
          padding: EdgeInsets.only(bottom: 30.0),
          mapType: MapType.normal,
          compassEnabled: false,
          mapToolbarEnabled: false,
          rotateGesturesEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: mapProvider.kGooglePlex,
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              northeast: LatLng(0.028127, -78.279376),
              southwest: LatLng(-0.421166, -78.590519)
            )
          ),
          markers: mapProvider.markers,
          onTap: (LatLng latLng) {
            mapProvider.auxiliary = false;
            mapProvider.geolocation = LocalityModel(lat: latLng.latitude, lng: latLng.longitude);
            mapProvider.setMarkers = LocalityModel(lat: latLng.latitude, lng: latLng.longitude);
          },
        );
      }
    );
  }
}