import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:flutter_carpooling/src/providers/arguments_provider/arguments_provider.dart';
import 'package:flutter_carpooling/src/services/locality_service.dart';
import 'package:flutter_carpooling/src/user_preferences/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/map_search_delegate.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Tema;
import 'package:provider/provider.dart';


class UsualRoutePage extends StatefulWidget {
  @override
  _UsualRoutePageState createState() => _UsualRoutePageState();
}

class _UsualRoutePageState extends State<UsualRoutePage> with AfterLayoutMixin {
  GoogleMapController mapController; 
  String searchAddress;
  String _description;
  Locality _geolocation;
  Set<Marker> _markers = {};
  String _departTime = "--:--";
  List<bool> _days = List<bool>.generate(7, (index) => false);
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(-0.179292, -78.486155), zoom: 12);
  final _localityService = new LocalityService();

  @override
  void afterFirstLayout(BuildContext context) {
    _adjustWhenSearch();
  }

  @override
  Widget build(BuildContext context) {
  final _responsiveScreen = Responsive(context);
  final _argumentsInfo = Provider.of<ArgumentsInfo>(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                _map(_responsiveScreen),
                _circularButtons(_responsiveScreen, _argumentsInfo),
              ],
            ),
            Expanded(
              child: FadeInUp(child: _containerInfo(_responsiveScreen)),
            )
          ],
        ),
      )
    );
  }

  Widget _map(Responsive responsiveScreen){
    return FadeIn(
      child: Container(
        width: responsiveScreen.wp(100),
        height: responsiveScreen.hp(90),
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.normal,
          mapToolbarEnabled: false,
          compassEnabled: false,
          rotateGesturesEnabled: false,
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              northeast: LatLng(0.028127, -78.279376),
              southwest: LatLng(-0.421166, -78.590519)
            )
          ),
          markers: _markers,
          onTap: (LatLng latLng){
            print('me presionan 😀 😃 😄 😁 😆 😅 😂'); 
            if (_geolocation != null) {
              _geolocation = null;
            }
            _geolocation = Locality(lat: latLng.latitude, lng: latLng.longitude);
            _markers.add(
              Marker(markerId: MarkerId("miMarker"), position: latLng)
            );
            setState(() {});
          },
        ),
      ),
    ); 
  }

  Widget _circularButtons(Responsive responsiveScreen, ArgumentsInfo argumentsInfo) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 20, right: 15, left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            argumentsInfo.getBackArrowUserRoute ? Container(
              child: CupertinoButton(
                padding: EdgeInsets.all(10.0),
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.black26,
                child: Icon(Icons.arrow_back, color: Colors.white, size: responsiveScreen.ip(2.5)),
                onPressed: () => Navigator.pushReplacementNamed(context, 'home'),
              ),
            ) : Container(),
            Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: OurColors.darkPurple,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () => showSearch(context: context, delegate: DataSearch(days: _days, hour: _departTime, route: 'usualRoute')),
                child: Icon(Icons.search, color: Colors.white, size: responsiveScreen.ip(2.5)),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerInfo(Responsive responsiveScreen){
    return Container(
      height: responsiveScreen.hp(10),
      width: responsiveScreen.wp(100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Tema.OurColors.initialPurple, Tema.OurColors.finalPurple],
          begin: FractionalOffset(0.0, 0.1),
          end: FractionalOffset(0.0, 0.99),
        ),
        borderRadius: BorderRadius.circular(25), 
        // borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            bottom: responsiveScreen.hp(8),
            left: responsiveScreen.wp(50),
            child: _saveButton(responsiveScreen)
          ),
          Positioned(
            top: responsiveScreen.hp(2),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: responsiveScreen.wp(100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FaIcon(FontAwesomeIcons.mapMarkerAlt, size: responsiveScreen.ip(3), color: Tema.OurColors.grayishWhite,),
                  SizedBox(width: responsiveScreen.wp(5),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('¿A dónde vas?', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.5), color: Tema.OurColors.grayishWhite)),
                      _address(context, responsiveScreen),
                    ],
                  ), 
                  
                ],
              ),
            ),
          ),
        ],
      ),
    ); 
  }

  Widget _address(BuildContext context, Responsive responsiveScreen) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: responsiveScreen.wp(80),
      child: (_geolocation != null) ? FutureBuilder(
        future: Geocoder.local.findAddressesFromCoordinates(Coordinates(_geolocation.lat, _geolocation.lng)),
        builder: (context, AsyncSnapshot<List<Address>> snapshot){
          if (snapshot.hasData) {
            final Address address = snapshot.data.first;
            _description = address.addressLine;
            return Text(_description, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.3), color: Tema.OurColors.grayishWhite));
          } else {
            _description = "";
            return Center(child: LoadingTwoWidget());
          }
        },
      ) : Text(
        'Ve al buscador y encuentra el lugar al que vas ...', 
        style: TextStyle(
          fontFamily: "WorkSansLight", 
          fontSize: responsiveScreen.ip(1.3), 
          color: Tema.OurColors.grayishWhite
        ),
        overflow: TextOverflow.ellipsis,
      ), 
    ); 
  }

  Widget _saveButton(Responsive responsiveScreen) {
    final _prefs = new UserPreferences();
    return Container(
      height: responsiveScreen.hp(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: OurColors.lightGreenishBlue,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0.0, 1.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: MaterialButton(
        // highlightColor: Colors.transparent,
        splashColor: OurColors.lightGreenishBlue,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.0),
          child: Text("GUARDAR", style: TextStyle( color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansBold")),
        ),
        onPressed: () async {
          if (_geolocation != null ){
            _localityService.localityDb(_geolocation);
            _prefs.lat = _geolocation.lat.toString();
            _prefs.lng = _geolocation.lng.toString();
            Navigator.pushReplacementNamed(context, 'selectMode'); 
          } else {
            mostrarAlerta(context, 'Ups!', 'Ingresa una ruta');
          }
        },
      ),
    );
  }


  void _adjustWhenSearch() {
    Map values = ModalRoute.of(context).settings.arguments;
    if (values != null) {
      _days = values['days'];
      _departTime = values['hour'];
      Locality location = values['locality'];
      _markers.add(Marker(markerId: MarkerId("miMarker"), position: LatLng(location.lat, location.lng)));
      _kGooglePlex = CameraPosition(
        target: LatLng(location.lat, location.lng),
        zoom: 16,
      );
      _geolocation = Locality(lat: location.lat, lng: location.lng);
      location = null;
      setState(() {});
    }
  }
}