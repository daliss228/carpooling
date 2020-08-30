import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/utils/search_delegate.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';

class RouteRegisterPage extends StatefulWidget {

  @override
  _RouteRegisterPageState createState() => _RouteRegisterPageState();
}

class _RouteRegisterPageState extends State<RouteRegisterPage> {  

  String _useruid;
  String _groupuid;
  String _description;
  TimeOfDay _time;
  Locality _geolocation;
  DateTime _selectedDate;
  Set<Marker> _markers = {};
  String _departTime = "--:--";
  RouteModel _route = RouteModel();
  RouteService _routeService = RouteService();
  List<bool> _days = List<bool>.generate(7, (index) => false);
  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(-0.179292, -78.486155), zoom: 12);

  @override
  void initState() {
    final _prefs = PreferenciasUsuario();
    _useruid = _prefs.uid;
    _groupuid = _prefs.uidGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              _map(_screen), 
              _circularButtons()
            ],
          ),
          Expanded(
            child: _contenedorInfo(_screen)
          )
        ],
      ), 
    ); 
  }

  Widget _circules(opacity, radius){
    return Opacity(
      opacity: opacity,
      child: CircleTwoWidget(
        radius: radius,
        colors: [OurColors.lightGreenishBlue, OurColors.lightBlue]
      )
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
  
  Widget _map(_screenSize){
    _adjustWhenSearch();
    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.6,
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
    ); 
  }

  Widget _contenedorInfo(_screen){
    return Container(
      height: _screen.height * 0.4,
      width: _screen.width,
      child: Stack(
        children: <Widget>[
          Positioned(left: _screen.width * 0.6, top: _screen.height * 0.28, child: _circules(0.5, 100.0)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _address(context),
                  Divider(),
                  _schedule(), 
                  _hour(), 
                  _saveButton(),
                  SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ],
      ),
    ); 
  }

  Widget _address(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: (_geolocation != null) ? FutureBuilder(
        future: Geocoder.local.findAddressesFromCoordinates(Coordinates(_geolocation.lat, _geolocation.lng)),
        builder: (context, AsyncSnapshot<List<Address>> snapshot){
          if (snapshot.hasData) {
            final Address address = snapshot.data.first;
            _description = address.addressLine;
            return Text(_description, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 16.0));
          } else {
            _description = "";
            return Center(child: LoadingTwoWidget());
          }
        },
      ) : Text('Elija un destino en el mapa!', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 16.0))
    );
  }

  Widget _schedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Días de recorrido: ', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 15.0)),
        Table(
          children: [
            TableRow(
              children: [
                Checkbox(
                  activeColor: OurColors.darkPurple,
                  value: _days[0], 
                  onChanged: (bool valor){
                    setState(() {
                      _days[0] = valor;
                    });
                  }
                ),
                Checkbox(
                  activeColor: OurColors.darkPurple,
                  value: _days[1], 
                  onChanged: (bool value){
                    setState(() {
                      _days[1] = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: OurColors.darkPurple,
                  value: _days[2], 
                  onChanged: (bool value){
                    setState(() {
                      _days[2] = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: OurColors.darkPurple,
                  value: _days[3], 
                  onChanged: (bool value){
                    setState(() {
                      _days[3] = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: OurColors.darkPurple,
                  value: _days[4], 
                  onChanged: (bool value){
                    setState(() {
                      _days[4] = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: OurColors.darkPurple,
                  value: _days[5], 
                  onChanged: (bool value){
                    setState(() {
                      _days[5] = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: OurColors.darkPurple,
                  value: _days[6], 
                  onChanged: (bool value){
                    setState(() {
                      _days[6] = value;
                    });
                  }
                ),
              ]
            ),
            TableRow(
              children: [
                Text('Lun', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 11.0), textAlign: TextAlign.center),
                Text('Mar', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 11.0), textAlign: TextAlign.center),
                Text('Mie', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 11.0), textAlign: TextAlign.center),
                Text('Jue', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 11.0), textAlign: TextAlign.center),
                Text('Vie', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 11.0), textAlign: TextAlign.center),
                Text('Sab', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 11.0), textAlign: TextAlign.center),
                Text('Dom', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 11.0), textAlign: TextAlign.center)
              ]
            )
          ],    
        )
      ],
    ); 
  }

  Widget _hour() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Hora de salida:', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 15.0)), 
          InkWell(
            child: 
              Row(
                children: <Widget>[
                  Icon(Icons.access_time, size: 30.0, color: OurColors.darkPurple),
                  SizedBox(width: 5),
                  Text(_departTime, style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 15.0)),
              ],
            ),
            onTap: () async {
              await _selecTime(context);
              setState(() {
                _selectedDate = DateTime.now();
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _time.hour, _time.minute);
                _departTime = DateFormat('HH:mm').format(_selectedDate);
              });
            },
          )
        ],
      ),
    );
  }

  Future<void> _selecTime(BuildContext context) async {
    _time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(), 
       builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: OurColors.lightGreenishBlue),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
    );
  }

  Widget _circularButtons() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: CupertinoButton(
              padding: EdgeInsets.all(10.0),
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black26,
              child: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pushReplacementNamed(context, 'home')
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 0.0, top: 15.0, bottom: 15.0, right: 15.0),
            padding: EdgeInsets.all(13.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
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
              onTap: () => showSearch(context: context, delegate: DataSearch(days: _days, hour: _departTime)),
              child: Icon(Icons.search, color: Colors.white, size: 28.0),
            )
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
          highlightColor: Colors.transparent,
          splashColor: OurColors.lightGreenishBlue,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.0),
            child: Text("Guardar", style: TextStyle( color: Colors.white, fontSize: 16.0, fontFamily: "WorkSansBold")),
          ),
          onPressed: () async {
            if (_geolocation != null && _description != null && _departTime != "--:--" && atLeast1True(_days) == true){
              _route.driverUid = _useruid;
              _route.group = _groupuid;
              _route.address = _description;
              _route.coordinates = Locality(lat: _geolocation.lat, lng: _geolocation.lng);
              _route.schedule = Schedule(monday: _days[0], tuesday: _days[1], wednesday: _days[2], thursday: _days[3], friday: _days[4], saturday: _days[5], sunday: _days[6]);
              _route.date = toBeginningOfSentenceCase(DateFormat.yMMMMEEEEd('es').format(DateTime.now()));
              _route.hour = _departTime;
              _route.status = true;
              final response = await _routeService.createRoute(_route);
              if(response['ok'] == false){
                mostrarAlerta(context, 'Error!', response['message']); 
              }
              Navigator.pushReplacementNamed(context, "home");
            } else {
              mostrarAlerta(context, 'Ups!', 'Llene todos los campos.');
            }
          },
        ),
      ),
    );
  }

}