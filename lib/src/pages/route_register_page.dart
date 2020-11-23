import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/widgets/map_widget.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:flutter_carpooling/src/widgets/geocoder_widget.dart';
import 'package:flutter_carpooling/src/utils/map_search_delegate.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';
import 'package:flutter_carpooling/src/widgets/num_inc_dec_widget.dart';

class RouteRegisterPage extends StatefulWidget {

  final String routeUid;

  RouteRegisterPage({this.routeUid});

  @override
  _RouteRegisterPageState createState() => _RouteRegisterPageState();
}

class _RouteRegisterPageState extends State<RouteRegisterPage> {  

  TimeOfDay _time;
  DateTime _selectedDate;
  final _route = RouteModel();
  final _routeService = RouteService();

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    final mapProvider = Provider.of<MapProvider>(context);
    final routesProvider = Provider.of<RoutesProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _map(responsiveScreen),
          _circularButtons(responsiveScreen, mapProvider),
          _draggableSheet(responsiveScreen, mapProvider, routesProvider, userProvider)
        ],
      ), 
    ); 
  }

  Widget _draggableSheet(Responsive responsiveScreen, MapProvider mapProvider, RoutesProvider routesProvider, UserProvider userProvider) {
    return FadeInUp(
      child: SizedBox.expand(
        child: DraggableScrollableSheet(
          maxChildSize: 0.54,
          minChildSize: 0.15,
          initialChildSize: 0.15,
          builder: (context, scrollController) {
            return Material(
              elevation: 20,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.0)
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 2.5,
                        color: Colors.grey,
                        margin: EdgeInsets.only(top: 10.0),
                      )
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        children: [
                          _address(responsiveScreen),
                          SizedBox(height: responsiveScreen.hp(1.7)),
                          Divider(),
                          SizedBox(height: responsiveScreen.hp(1)),
                          _schedule(responsiveScreen, mapProvider), 
                          _hour(responsiveScreen, mapProvider),
                          _seat(responsiveScreen, mapProvider),
                          _saveButton(responsiveScreen, mapProvider, routesProvider, userProvider)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        )
      ),
    );
  }

  Widget _map(Responsive responsiveScreen){
    return Container(
      width: double.infinity,
      height: responsiveScreen.hp(90),
      child: MapWidget(),
    ); 
  }

  Widget _address(Responsive responsiveScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FaIcon(FontAwesomeIcons.mapMarkerAlt, size: responsiveScreen.ip(3), color: OurColors.darkGray),
        SizedBox(width: responsiveScreen.wp(3)),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿A dónde vas?', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.7), color: OurColors.darkGray)),
              GeodecoderWidget(color: OurColors.darkPurple),
            ],
          ),
        )
      ],
    );
  }

  Widget _schedule(Responsive responsiveScreen, MapProvider mapProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Días de recorrido: ', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(1.7), color: OurColors.darkGray)),
          Table(
            children: [
              TableRow(
                children: [
                  _checkbox(mapProvider, 0),
                  _checkbox(mapProvider, 1),
                  _checkbox(mapProvider, 2),
                  _checkbox(mapProvider, 3),
                  _checkbox(mapProvider, 4),
                  _checkbox(mapProvider, 5),
                  _checkbox(mapProvider, 6),
                ]
              ),
              TableRow(
                children: [
                  Text('Lun', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.darkGray), textAlign: TextAlign.center),
                  Text('Mar', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.darkGray), textAlign: TextAlign.center),
                  Text('Mie', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.darkGray), textAlign: TextAlign.center),
                  Text('Jue', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.darkGray), textAlign: TextAlign.center),
                  Text('Vie', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.darkGray), textAlign: TextAlign.center),
                  Text('Sab', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.darkGray), textAlign: TextAlign.center),
                  Text('Dom', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.darkGray), textAlign: TextAlign.center)
                ]
              )
            ],    
          )
        ],
      ),
    ); 
  }

  Widget _hour(Responsive responsiveScreen, MapProvider mapProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Hora de salida:', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(1.7), color: OurColors.darkGray)), 
          InkWell(
            child: 
              Row(
                children: <Widget>[
                  Icon(Icons.access_time, size: responsiveScreen.ip(3.5), color: OurColors.darkGray),
                  SizedBox(width: 5),
                  Text((mapProvider.hour != null) ? mapProvider.hour : "--:--", style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.8), color: OurColors.darkGray)),
              ],
            ),
            onTap: () async {
              await _selecTime(context);
              if (_time == null) return;
              setState(() {
                _selectedDate = DateTime.now();
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _time.hour, _time.minute);
                mapProvider.hour = DateFormat('HH:mm').format(_selectedDate);
              });
            },
          )
        ],
      ),
    );
  }

  Widget _seat(Responsive responsiveScreen, MapProvider mapProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Asientos disponibles:', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(1.7), color: OurColors.darkGray)),
        NumIncDecWidget(
          value: mapProvider.seat != null ? mapProvider.seat : 1,
          onChanged: (value) {
            setState(() {
              mapProvider.seat = value;
            });
          }
        ),   
      ],
    );
  }

  Widget _checkbox(MapProvider mapProvider, int index) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: OurColors.darkGray
      ),
      child: Checkbox(
        activeColor: OurColors.lightGreenishBlue,
        value: mapProvider.days[index], 
        onChanged: (bool valor){
          setState(() {
            mapProvider.days[index] = valor;
          });
        }
      ),
    );
  }

  Widget _circularButtons(Responsive responsiveScreen, MapProvider mapProvider) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.0),
            child: CupertinoButton(
              padding: EdgeInsets.all(10.0),
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black26,
              child: Icon(Icons.arrow_back, color: Colors.white, size: responsiveScreen.ip(2.5)),
              onPressed: () {
                if (widget.routeUid != null) {
                  mapProvider.clearValues();
                }
                Navigator.pop(context);
              } 
            ),
          ),
          Container(
            margin: EdgeInsets.all(15.0),
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
              onTap: () => showSearch(context: context, delegate: DataSearch(route: 'route')),
              child: Icon(Icons.search, color: Colors.white, size: responsiveScreen.ip(2.5)),
            )
          ),
        ],
      ),
    );
  }

  Widget _saveButton(Responsive responsiveScreen, MapProvider mapProvider, RoutesProvider routesProvider, UserProvider userProvider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: MaterialButton(
          color: OurColors.lightGreenishBlue,
          highlightColor: Colors.transparent,
          splashColor: OurColors.lightGreenishBlue,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "GUARDAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: responsiveScreen.ip(1.5),
                fontFamily: "WorkSansMedium"
              ),
            ),
          ),
          onPressed: () async {
            if (mapProvider.geolocation != null && mapProvider.description != null && mapProvider.hour != null && atLeast1True(mapProvider.days) == true) {
              _route.id = widget.routeUid != null ? widget.routeUid : null;
              _route.status = true;
              _route.seat = mapProvider.seat;
              _route.hour = mapProvider.hour;
              _route.idDriver = userProvider.user.id;
              _route.group = userProvider.user.idGroup;
              _route.address = mapProvider.description;
              _route.date = DateTime.now().toString();
              _route.coordinates = LocalityModel(lat: mapProvider.geolocation.lat, lng: mapProvider.geolocation.lng);
              _route.schedule = Schedule(monday: mapProvider.days[0], tuesday: mapProvider.days[1], wednesday: mapProvider.days[2], thursday: mapProvider.days[3], friday: mapProvider.days[4], saturday: mapProvider.days[5], sunday: mapProvider.days[6]);
              if (mapProvider.numUsers != null) {
                if (mapProvider.seat < mapProvider.numUsers) {
                  showAlert(context, 'Número de asientos disponibles no válido!', Icons.sentiment_dissatisfied, 'No puede cambiar a un número menor del número de usuarios que están registrados en este viaje.');
                  return;
                }  
              }
              final result = await _routeService.createOrUpdateRoute(_route);
              if (result['ok']) {
                if (widget.routeUid == null) {
                  _route.id = result['value'];
                  routesProvider.addMyDriverRoutes = _route;
                } else {
                  routesProvider.editMyDriverRoutes = _route;
                }
              }
              Navigator.pushReplacementNamed(context, 'home');
              showAlert(context, 'Viaje ${(widget.routeUid == null) ? 'creado' : 'editado'} correctamente!', Icons.check_circle_outline, 'Viaje se ha ${(widget.routeUid == null) ? 'creado' : 'editado'} el día de hoy: ${readableDate(DateTime.now().toString())}.');
              mapProvider.clearValues();
            } else {
              showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, 'Llene todos los campos.');
            }
          },
        ),
      ),
    );
  }

  Future<void> _selecTime(BuildContext context) async {
    _time = await showTimePicker(
      context: context, 
      initialEntryMode: TimePickerEntryMode.input,
      helpText: 'INGRESE HORA DE SALIDA',
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

}