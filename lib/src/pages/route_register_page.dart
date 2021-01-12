import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/utils/helpers.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/widgets/map_widget.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/utils/search_delegate.dart';
import 'package:flutter_carpooling/src/models/locality_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:flutter_carpooling/src/widgets/geocoder_widget.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';
import 'package:flutter_carpooling/src/widgets/num_inc_dec_widget.dart';

class RouteRegisterPage extends StatelessWidget {
  final RouteModel route;
  RouteRegisterPage({this.route});

  final _route = RouteModel();
  final _routeService = RouteService();

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Scaffold(
      body: FutureBuilder(
        future: DataConnectionChecker().hasConnection,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Stack(
                children: <Widget>[
                  _map(responsiveScreen),
                  _circularButtons(responsiveScreen, context),
                  _draggableSheet(responsiveScreen)
                ],
              );
            } else {
              return AlertWidget(
                title: 'Ups!',
                icon: ValidatorResponse.iconData(5),
                message: "No tiene internet, compruebe la conexión",
                onPressed: () => Navigator.pop(context),
              );
            }
          } else {
            return Container(); 
          }
        }
      ), 
    ); 
  }

  Widget _draggableSheet(Responsive responsiveScreen) {
    return FadeInUp(
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
                      width: 50.0,
                      height: 3.5,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50.0)
                      ),
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
                        _schedule(responsiveScreen), 
                        _hour(responsiveScreen),
                        _seat(responsiveScreen),
                        _saveButton(responsiveScreen)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
        FaIcon(FontAwesomeIcons.mapMarkerAlt, size: responsiveScreen.ip(3), color: OurColors.black),
        SizedBox(width: responsiveScreen.wp(3)),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿A dónde vas?', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.7), color: OurColors.black)),
              GeodecoderWidget(color: OurColors.darkPurple),
            ],
          ),
        )
      ],
    );
  }

  Widget _schedule(Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Días de recorrido: ', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(1.7), color: OurColors.black)),
          CheckBoxesWidget()
        ],
      ),
    ); 
  }

  Widget _hour(Responsive responsiveScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Hora de salida:', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(1.7), color: OurColors.black)), 
          Consumer<MapProvider>(builder: (context, provider, child) {
            return InkWell(
              child: Row(
                children: <Widget>[
                  Icon(Icons.access_time, size: responsiveScreen.ip(3.5), color: OurColors.black),
                  SizedBox(width: 5),
                  Text((provider.hour != null) ? provider.hour : "--:--", style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.8), color: OurColors.black)),
                ],
              ),
              onTap: () async {
                final _time = await showTimePicker(
                  context: context, 
                  initialEntryMode: TimePickerEntryMode.input,
                  helpText: 'INGRESE HORA DE SALIDA',
                  initialTime: TimeOfDay.now(), 
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      child: child,
                      data: ThemeData.light().copyWith(
                        colorScheme: ColorScheme.light(primary: OurColors.lightGreenishBlue),
                        buttonTheme: ButtonThemeData(
                          textTheme: ButtonTextTheme.primary
                        ),
                      ),
                    );
                  },
                );
                if (_time == null) return;
                DateTime _selectedDate = DateTime.now();
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _time.hour, _time.minute);
                provider.hour = DateFormat('HH:mm').format(_selectedDate);
              },
            );
          })
        ],
      ),
    );
  }

  Widget _seat(Responsive responsiveScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Asientos disponibles:', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(1.7), color: OurColors.black)),
        Consumer<MapProvider>(builder: (context, provider, child) {
          return NumIncDecWidget(
            initValue: provider.seat - (provider.idUsers != null ? provider.idUsers.length : 0),
            difValue: provider.idUsers != null ? provider.idUsers.length : 0,
            onChanged: (value) {
              if (this.route == null) {
                provider.seat = value;
              } else {
                provider.seat = (provider.idUsers != null ? provider.idUsers.length : 0) + value;
              }
            }
          );
        }),   
      ],
    );
  }

  Widget _circularButtons(Responsive responsiveScreen, BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.0),
            child: Consumer<MapProvider>(builder: (context, provider, child) {
              return CupertinoButton(
                padding: EdgeInsets.all(10.0),
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.black26,
                child: Icon(Icons.arrow_back, color: Colors.white, size: responsiveScreen.ip(2.5)),
                onPressed: () {
                  if (this.route != null) {
                    provider.clean();
                  }
                  Navigator.pop(context);
                } 
              );
            }),
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

  Widget _saveButton(Responsive responsiveScreen) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Consumer3<MapProvider, RoutesProvider, UserProvider>(builder: (context, mapProvider, routesProvider, userProvider, child) {
          return MaterialButton(
            color: OurColors.lightGreenishBlue,
            highlightColor: Colors.transparent,
            splashColor: OurColors.lightGreenishBlue,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
              child: Text("GUARDAR", style: TextStyle(color: Colors.white, fontSize: responsiveScreen.ip(1.5), fontFamily: "WorkSansMedium")),
            ),
            onPressed: () async {
              if (mapProvider.geolocation != null 
                && mapProvider.description != null 
                && mapProvider.hour != null 
                && atLeast1True(mapProvider.days) == true 
              ) {
                bool newRoute = this.route == null ? true : false;
                if (!newRoute) {
                  if (this.route.idUsers == null && mapProvider.seat == 0) {
                    showAlert(context, 'Número de asientos no válido!', Icons.sentiment_dissatisfied, 'El  número de asientos disponibles no puede ser cero.');
                    return;
                  }
                  _route.id = this.route.id;
                  _route.idUsers = mapProvider.idUsers;
                  _route.users = this.route.users;
                } else {
                  if (mapProvider.seat == 0) {
                    showAlert(context, 'Número de asientos no válido!', Icons.sentiment_dissatisfied, 'El  número de asientos disponibles no puede ser cero.');
                    return;
                  }
                }
                _route.status = true;
                _route.seat = mapProvider.seat;
                _route.hour = mapProvider.hour;
                _route.idDriver = userProvider.user.id;
                _route.idGroup = userProvider.user.idGroup;
                _route.address = mapProvider.description;
                _route.date = DateTime.now().toString();
                _route.coordinates = LocalityModel(lat: mapProvider.geolocation.lat, lng: mapProvider.geolocation.lng);
                _route.schedule = Schedule(monday: mapProvider.days[0], tuesday: mapProvider.days[1], wednesday: mapProvider.days[2], thursday: mapProvider.days[3], friday: mapProvider.days[4], saturday: mapProvider.days[5], sunday: mapProvider.days[6]);
                final result = await _routeService.createOrUpdateRoute(_route);
                if (result.status) {
                  if (_route.id == null) {
                    _route.id = result.data;
                    routesProvider.addMyDriverRoutes = _route;
                  } else {
                    routesProvider.editMyDriverRoutes = _route;
                  }
                  Navigator.pushReplacementNamed(context, 'home');
                  showAlert(context, 'Viaje ${newRoute ? 'creado' : 'editado'} correctamente!', ValidatorResponse.iconData(result.code), 'Viaje se ha ${newRoute ? 'creado' : 'editado'} el día de hoy: ${readableDate(DateTime.now().toString())}.');
                  mapProvider.clean();
                } else {
                  showAlert(context, 'Ups!', ValidatorResponse.iconData(result.code), result.message);
                }
              } else {
                showAlert(context, 'Ups!', Icons.sentiment_dissatisfied, 'Llene todos los campos.');
              }
            },
          );
        }),
      ),
    );
  }
}

class CheckBoxesWidget extends StatefulWidget {

  @override
  _CheckBoxesWidgetState createState() => _CheckBoxesWidgetState();
}

class _CheckBoxesWidgetState extends State<CheckBoxesWidget> {
  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Table(
      children: [
        TableRow(
          children: [
            _checkbox(0),
            _checkbox(1),
            _checkbox(2),
            _checkbox(3),
            _checkbox(4),
            _checkbox(5),
            _checkbox(6),
          ]
        ),
        TableRow(
          children: [
            Text('Lun', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.black), textAlign: TextAlign.center),
            Text('Mar', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.black), textAlign: TextAlign.center),
            Text('Mie', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.black), textAlign: TextAlign.center),
            Text('Jue', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.black), textAlign: TextAlign.center),
            Text('Vie', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.black), textAlign: TextAlign.center),
            Text('Sab', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.black), textAlign: TextAlign.center),
            Text('Dom', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.6), color: OurColors.black), textAlign: TextAlign.center)
          ]
        )
      ],    
    );
  }

  Widget _checkbox(int index) {
    return Consumer<MapProvider>(builder: (context, provider, child) {
      return Checkbox(
        activeColor: OurColors.lightGreenishBlue,
        value: provider.days[index], 
        onChanged: (bool valor){
          provider.days[index] = valor;
          setState(() {});
        }
      );
    });
  }

}