import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {

  final Locality latLng;
  final int type;

  MapWidget({@required this.latLng, @required this.type});

  @override
  Widget build(BuildContext context) {

    CameraPosition _kGooglePlex = CameraPosition(target: LatLng(latLng.lat + ((type == 1) ? 0.001500 : 0), latLng.lng), zoom: 16);
    Set<Marker> _markers = {Marker(markerId: MarkerId("miMarker"), position: LatLng(latLng.lat, latLng.lng))};
    return GoogleMap(
      mapType: MapType.normal,
      compassEnabled: false,
      scrollGesturesEnabled: (type == 1) ? true : false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: (type == 1) ? true : false,
      rotateGesturesEnabled: false,
      initialCameraPosition: _kGooglePlex,
      cameraTargetBounds: CameraTargetBounds(
        LatLngBounds(
          northeast: LatLng(0.028127, -78.279376),
          southwest: LatLng(-0.421166, -78.590519)
        )
      ),
      markers: _markers,
      onTap: (LatLng latLng) {},
    );
  }
}
