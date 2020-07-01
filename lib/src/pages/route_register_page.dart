import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_carpooling/src/models/car_model.dart';
import 'package:flutter_carpooling/src/models/routes_model.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Thema;
import 'package:flutter_carpooling/src/utils/search_delegate.dart';
import 'package:flutter_carpooling/src/widgets/circle_widget.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';

class RouteRegisterPage extends StatefulWidget {

  @override
  _RouteRegisterPageState createState() => _RouteRegisterPageState();
}

class _RouteRegisterPageState extends State<RouteRegisterPage> {  

  bool _checkBoxMon;
  bool _checkBoxTue;
  bool _checkBoxWed;
  bool _checkBoxThu;
  bool _checkBoxFri;
  bool _checkBoxSat;
  bool _checkBoxSun;
  String _description;
  String _departTime;
  String _idCar;
  String useruid;
  Locality _geolocation;
  TimeOfDay _time;
  DateTime _selectedDate;
  DateFormat _dateFormat;
  Set<Marker> _markers;
  CameraPosition _kGooglePlex;
  GoogleMapController myMapCtrl;
  final dbRef = FirebaseDatabase.instance.reference();

  @override
  void initState() { 
    super.initState();
    final _prefs = PreferenciasUsuario();
    useruid = _prefs.uid.toString();
    getCar();
    _markers = {};
    _checkBoxMon = false;
    _checkBoxTue = false;
    _checkBoxWed = false;
    _checkBoxThu = false;
    _checkBoxFri = false;
    _checkBoxSat = false;
    _checkBoxSun = false;
    _selectedDate = DateTime.now();
    _dateFormat = DateFormat('HH:mm');
    _departTime = "--:--";
    _kGooglePlex = CameraPosition(target: LatLng(-0.208946, -78.467834), zoom: 12);
  }

  void getCar() async {
    final result = (await dbRef.child("users").child(useruid).child("car").once()).value;
    if(result != null){
      final car = new Car.fromJson(result);
      _idCar = car.id;
    } else {
      return;
    }
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
        colors: [Thema.Colors.loginGradientEnd, Thema.Colors.loginGradientStart]
      )
    );
  }

  void _adjustMap() {
    Locality location = ModalRoute.of(context).settings.arguments;
    if (location != null) {
      _markers.add(
        Marker(markerId: MarkerId("miMarker"), position: LatLng(location.lat, location.lng))
      );
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
    _adjustMap();
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
        onMapCreated: (controller) {
          myMapCtrl = controller;
          setState(() {});
        },
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

  Widget _address (BuildContext context) {
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
            return Center(child: CupertinoActivityIndicator());
          }
        },
      ) : Text('Elija un destino en el mapa!', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 16.0))
    );
  }

  Widget _schedule () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Días de recorrido: ', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 15.0)),
        Table(
          children: [
            TableRow(
              children: [
                Checkbox(
                  activeColor: Color(0XFF3B3E69),
                  value: _checkBoxMon, 
                  onChanged: (bool valor){
                    setState(() {
                      _checkBoxMon = valor;
                    });
                  }
                ),
                Checkbox(
                  activeColor: Color(0XFF3B3E69),
                  value: _checkBoxTue, 
                  onChanged: (bool value){
                    setState(() {
                      _checkBoxTue = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: Color(0XFF3B3E69),
                  value: _checkBoxWed, 
                  onChanged: (bool value){
                    setState(() {
                      _checkBoxWed = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: Color(0XFF3B3E69),
                  value: _checkBoxThu, 
                  onChanged: (bool value){
                    setState(() {
                      _checkBoxThu = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: Color(0XFF3B3E69),
                  value: _checkBoxFri, 
                  onChanged: (bool value){
                    setState(() {
                      _checkBoxFri = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: Color(0XFF3B3E69),
                  value: _checkBoxSat, 
                  onChanged: (bool value){
                    setState(() {
                      _checkBoxSat = value;
                    });
                  }
                ),
                Checkbox(
                  activeColor: Color(0XFF3B3E69),
                  value: _checkBoxSun, 
                  onChanged: (bool value){
                    setState(() {
                      _checkBoxSun = value;
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

  Widget _hour () {
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
                  Icon(Icons.access_time, size: 30.0, color: Color(0XFF3B3E69)),
                  SizedBox(width: 5),
                  Text(_departTime, style: TextStyle(fontFamily: 'WorkSansLight', fontSize: 15.0)),
              ],
            ),
            onTap: () async {
              await selecTime(context);
              if (_time == null) return;
              _selectedDate = DateTime(
                _selectedDate.year, 
                _selectedDate.month, 
                _selectedDate.day, 
                _time.hour,
                _time.minute
              );
              _departTime = _dateFormat.format(_selectedDate).toString();
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Future<void> selecTime(BuildContext context) async {
    _time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(), 
       builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child
        );
      },
    );
  }

  Widget _circularButtons () {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 10.0),
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
              color: Color(0XFF3B3E69),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black45,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: InkWell(
              onTap: () => showSearch(context: context, delegate: DataSearch()),
              child: Icon(Icons.search, color: Colors.white, size: 28.0),
            )
          ),
        ],
      ),
    );
  }

  Widget _saveButton () {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Thema.Colors.loginGradientEnd,
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
          splashColor: Thema.Colors.loginGradientEnd,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 42.0),
            child: Text(
              "Guardar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: () {
            if (_geolocation != null && _description != null && _departTime != "--:--" && atLeast1True() == true && _idCar != null){
              dbRef.child("routes").push().set({
                "address": _description,
                "driver": useruid,
                "coordinates": Locality(lat: _geolocation.lat, lng: _geolocation.lng).toJson(),
                "id_car": _idCar,
                "schedule": Schedule(monday: _checkBoxMon, tuesday: _checkBoxTue, wednesday: _checkBoxWed, thursday: _checkBoxThu, friday: _checkBoxFri, saturday: _checkBoxSat, sunday: _checkBoxSun).toJson(),
                "hour": _departTime,
                "status": "active"
              }).then((_) {
                Navigator.pushReplacementNamed(context, "home");
              }).catchError((onError) {
                print(onError);
              });
            } else {
              print('llene todas los campos');
            }
          },
        ),
      ),
    );
  }

  bool atLeast1True() {
    final List listchecks = [_checkBoxMon, _checkBoxTue, _checkBoxWed, _checkBoxThu, _checkBoxFri, _checkBoxSat, _checkBoxSun];
    bool value = false;
    for (var item in listchecks) {
      if (item == true) {
        value = true;
      }
    }
    return value;
  }

}