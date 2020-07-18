
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/utils/colors.dart' as Theme;
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/preferencias_usuario/user_prefs.dart';


class RouteDetailPage extends StatefulWidget {
  RouteDetailPage({Key key}) : super(key: key);

  @override
  _RouteDetailPageState createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {

  final _dbRef = FirebaseDatabase.instance.reference();

  TextEditingController _hourController = TextEditingController();
  TextEditingController _scheduleController = TextEditingController();
  TextEditingController _seatController = TextEditingController();
  TextEditingController _carController = TextEditingController();

  
  String useruid;
  String _idRoute = "-MB6ALHZWpTLUoupxMcc";
  bool _isloading = true;
  bool _userResgister = false;
  UserModel _user;
  RouteModel _route;
  Set<Marker> _markers = {};
  CameraPosition _kGooglePlex;
  GoogleMapController myMapCtrl;
  
  @override
  void initState() {
    getDataRoute();
    final _prefs = PreferenciasUsuario();
    useruid = _prefs.uid.toString();
    super.initState();
  }

  @override
  void dispose() {
    _hourController.clear();
    _scheduleController.clear();
    _seatController.clear();
    _carController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sizeScren = MediaQuery.of(context).size;
    return Scaffold(
        body: _isloading 
        ? LoadingWidget()
        : Stack(
          children: <Widget>[
            Container(
              width: _sizeScren.width,
              height: _sizeScren.height * 0.45,
              color: Theme.OurColors.lightGreenishBlue,
            ),
            _descriptionDriver(_sizeScren),
            _photoDriver(_sizeScren),
            _map(_sizeScren),
            _containerInputs(_sizeScren, context),
            _comebackbuton()
          ],
        ),
    );
  }

  Widget _comebackbuton(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: CupertinoButton(
        padding: EdgeInsets.all(10.0),
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.black26,
        child: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pushReplacementNamed(context, 'home')
      ),
    );
  }

  Widget _map(_sizeScren) {
    return Positioned(
      top: _sizeScren.height * 0.6,
      child: Container(
        width: _sizeScren.width,
        height: _sizeScren.height * 0.55,
        child: GoogleMap(
          mapType: MapType.normal,
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          rotateGesturesEnabled: false,
          initialCameraPosition: _kGooglePlex,
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
          },
        ),
      ),
    );
  }

  Widget _photoDriver(_sizeScren) {
    return Positioned(
      top: _sizeScren.height * 0.06,
      right: 15.0,
      child: Container(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 39.0,
          child: ClipOval(
            child: (_user?.photo != null) 
            ? FadeInImage(
              image: NetworkImage(_user?.photo),
              placeholder: AssetImage('assets/img/ripple-loading.gif'),
              height: 125.0,
              width: 125.0,
              fit: BoxFit.contain,
            )
            : Container()
          ),
        ),
      ),
    );
  }

  Widget _descriptionDriver(_sizeScren) {
    return Positioned(
      top: _sizeScren.height * 0.11,
      left: 15,
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${_user.name} ${_user.lastName}', style: TextStyle(fontFamily: 'WorkSansSemiBold', color: Colors.white, fontSize: 18.0)),
            Text(_user.phone, textAlign: TextAlign.left, style: TextStyle(fontFamily: 'WorkSansMedium', color: Colors.white, fontSize: 16.0)),
          ],
        ),
      ),
    );
  }

  Widget _containerInputs(_sizeScren, BuildContext context){
    return Column(
      children: <Widget>[
        Container(
          height: _sizeScren.height * 0.19,
        ),
        Container(
          width: _sizeScren.width,
          padding: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3.0,
                offset: Offset(0.0, 4.0),
                spreadRadius: 3.0
              )
            ]
          ),
          child: Column(
            children: <Widget>[
              _textPlace(),
              _carInput(),
              _scheduleInput(),
              _hourInput(),
              _seatInput(),
              _registerRouteButon(_sizeScren),
              SizedBox(height: 20.0)
            ],
          )
        )
      ],
    );
  }

  Widget _textPlace() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0, left: 50.0, right: 50.0),
      child: Text(_route.address, style: TextStyle(fontFamily: 'WorkSansSemiBold', color: Color(0XFF3B3E69), fontSize: 16.5), textAlign: TextAlign.center),
    );
  }

  Widget _hourInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.5),
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: Offset(0.0, 4.0),
            spreadRadius: 3.0
          )
        ]
      ),
      child: TextField(
        controller: _hourController,
        style: TextStyle(fontFamily: "WorkSansLight", fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.clock,
            color: Colors.black,
            size: 20.0,
          ),
          border: InputBorder.none
        ),
      ),
    );
  }

  Widget _scheduleInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.5),
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: Offset(0.0, 4.0),
            spreadRadius: 3.0
          )
        ]
      ),
      child: TextField(
        controller: _scheduleController,
        style: TextStyle(fontFamily: "WorkSansLight", fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.calendar,
            color: Colors.black,
            size: 20.0,
          ),
          border: InputBorder.none
        ),
      ),
    );
  }

  Widget _carInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.5),
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: Offset(0.0, 4.0),
            spreadRadius: 3.0
          )
        ]
      ),
      child: TextField(
        controller: _carController,
        style: TextStyle(fontFamily: "WorkSansLight", fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.car,
            color: Colors.black,
            size: 20.0,
          ),
          border: InputBorder.none
        ),
      ),
    );
  }

  Widget _seatInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.5),   
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: Offset(0.0, 4.0),
            spreadRadius: 3.0
          )
        ]
      ),
      child: TextField(
        controller: _seatController,
        style: TextStyle(fontFamily: "WorkSansLight", fontSize: 15.0, color: Colors.black),
        decoration: InputDecoration(
          icon: Icon(
            FontAwesomeIcons.chair,
            color: Colors.black,
            size: 20.0,
          ),
          border: InputBorder.none
        ),
      ),
    );
  }

  void _saveUserRoute() async {
    if(_userResgister == false) {
      await _dbRef.child("routes").child(_idRoute).child("users").update({
        useruid: true,
      });
    } else {
      await _dbRef.child("routes").child(_idRoute).child("users").update({
        useruid: false,
      });
    }
    
  }

  

  Widget _registerRouteButon(_sizeScren) {
    return Positioned(
      top: _sizeScren.height * 0.565,
      left: _sizeScren.width * 0.205,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Theme.OurColors.lightGreenishBlue,
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
            splashColor: Theme.OurColors.lightGreenishBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 42.0),
              child: Text(
                _userResgister ? "Cancelar" : "Registrarme",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "WorkSansBold"),
              ),
            ),
            onPressed: () => _saveUserRoute
          ),
        ),
      ),
    );
  }

  Future<void> getDataRoute() async {
    final resultRoute = (await _dbRef.child("routes").child(_idRoute).once()).value;
    final result = resultRoute["users"];
    List users;
    if(result != null){
      users = result.keys.toList();
      print(users);
      for (var user in users) {
        if(user == useruid){
          setState(() {
            _userResgister = true;
          });
        }
      }
    }
    setState(() {
      _route = RouteModel.fromJson(resultRoute);
    });
    final resultDriver = (await _dbRef.child("users").child(_route.idDriver).once()).value;
    setState(() {
      _user = UserModel.fromJson(resultDriver);
      _hourController.text = 'Hora de salida: ${_route.hour}';
      _scheduleController.text = _stringSchedule();
      _seatController.text = 'Asientos disponibles: ${_user.car.seat.toString()}';
      _carController.text = '${_user.car.brand}, ${_user.car.model}. ${_user.car.registry}';
      _isloading = false;
    });
    if (_route.coordinates != null) {
      _kGooglePlex = CameraPosition(target: LatLng(_route.coordinates.lat, _route.coordinates.lng), zoom: 16);
      _markers.add(Marker(markerId: MarkerId("miMarker"), position: LatLng(_route.coordinates.lat, _route.coordinates.lng)));
    }
  }

  String _stringSchedule() {
    String stringDays = "";
    if(_route.schedule.monday == true) {
      stringDays = "Lun - ";
    }
    if (_route.schedule.tuesday == true) {
      stringDays += "Mar - ";
    }
    if (_route.schedule.wednesday == true) {
      stringDays += "Mie - ";
    }
    if (_route.schedule.thursday == true) {
      stringDays += "Jue - ";
    }
    if (_route.schedule.friday == true) {
      stringDays += "Vie - ";
    }
    if (_route.schedule.saturday == true) {
      stringDays += "Sab - ";
    }
    if (_route.schedule.sunday == true) {
      stringDays += "Dom";
    } 
    if (stringDays.endsWith(" - ")) {
      print('asd');
      stringDays = stringDays.replaceRange(stringDays.length - 3, stringDays.length, "");
    }
    return stringDays;
  }


}