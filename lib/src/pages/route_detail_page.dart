import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_carpooling/src/utils/helpers.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/models/user_model.dart';
// import 'package:flutter_carpooling/src/widgets/map_widget.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/models/report_model.dart';
import 'package:flutter_carpooling/src/widgets/alert_widget.dart';
import 'package:flutter_carpooling/src/services/user_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/providers/map_provider.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';
import 'package:flutter_carpooling/src/providers/user_provider.dart';
import 'package:flutter_carpooling/src/utils/validator_response.dart';
import 'package:flutter_carpooling/src/widgets/simple_map_widget.dart';
import 'package:flutter_carpooling/src/pages/route_register_page.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';

class RouteDetailPage extends StatelessWidget {
  final RouteModel route;
  RouteDetailPage({@required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: DataConnectionChecker().hasConnection,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return _RouteDetailPage(route: route);
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
      )
    );
  }
}

class _RouteDetailPage extends StatefulWidget {
  final RouteModel route;
  _RouteDetailPage({@required this.route});

  @override
  _RouteDetailPageState createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<_RouteDetailPage> {

  final _prefs = UserPreferences();
  final _userService = UserService();
  final _routeService = RouteService();
  final _formKey1 = GlobalKey<FormState>();

  int _groupSelected;
  bool _isADriver = false;
  bool _userRegister = false;
  bool _visibleWarning = false;
  UserModel _driverModel = UserModel();
  ReportModel _reportModel = ReportModel();
  List<bool> _checks = List<bool>.generate(Reports.list.length, (i) => false);

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    _userRegister = verifyUserRegister(widget.route.users);
    final userProvider = Provider.of<UserProvider>(context);
    _isADriver = widget.route.idDriver == userProvider.user.id ? true : false;
    return Scaffold(
      floatingActionButton: (_prefs.mode == 'PASAJERO') ? Container() : _speedDial(responsiveScreen),
      body: FutureBuilder(
        future: _userService.readUser(widget.route.idDriver),
        builder: (BuildContext context, AsyncSnapshot<ValidatorResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.status) {
              _driverModel = snapshot.data.data; 
              return Stack(
                children: <Widget>[
                  _background(responsiveScreen),
                  _map(responsiveScreen),
                  _tabBar(responsiveScreen),
                  _circularButtons(responsiveScreen),
                  _suscribeButton(responsiveScreen),
                  _infoDriver(responsiveScreen)
                ],
              );
            } else {
              return AlertWidget(
                title: 'Ups!',
                icon: ValidatorResponse.iconData(snapshot.data.code),
                message: snapshot.data.message,
                onPressed: () => Navigator.pop(context),
              );
            }
          } else {
            return LoadingWidget();
          }
        }
      ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _speedDial(Responsive responsiveScreen) {
    return Consumer2<MapProvider, RoutesProvider>(builder: (context, mapProvider, routesProvider, child) {
      return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: responsiveScreen.ip(2.5), color: Colors.white),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Opciones',
        heroTag: 'speed-dial-hero-tag2',
        backgroundColor: OurColors.lightGreenishBlue,
        foregroundColor: Colors.black,
        elevation: 6.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.delete, color: Color(0XFFE90000)),
            backgroundColor: Colors.white,
            label: 'Eliminar',
            labelStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.6), color: Colors.black),
            onTap: () async {
              // TODO: notificar a los usuarios que se ha eliminado una ruta
              final result = await _routeService.removeRoute(widget.route.id);
              if (result.status) {
                routesProvider.removeMyDriverRoutes = widget.route;
                Navigator.pushReplacementNamed(context, 'home');  
                showAlert(context, 'Ok!', ValidatorResponse.iconData(result.code), result.message); 
              } else {
                showAlert(context, 'Ups!', ValidatorResponse.iconData(result.code), result.message); 
              }
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.edit, color: Color(0XFF00B900)),
            backgroundColor: Colors.white,
            label: 'Editar',
            labelStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.6), color: Colors.black),
            onTap: () {
              // TODO: notificar a los usuarios que se ha editado una ruta
              mapProvider.clean();
              mapProvider.auxiliary = true;
              mapProvider.seat = widget.route.seat;
              mapProvider.idUsers = widget.route.idUsers;
              mapProvider.kGooglePlex = CameraPosition(target: LatLng(widget.route.coordinates.lat, widget.route.coordinates.lng), zoom: 16);
              mapProvider.geolocation = widget.route.coordinates;
              mapProvider.setMarkers = widget.route.coordinates;
              mapProvider.description = widget.route.address;
              mapProvider.schedule = widget.route.schedule;
              mapProvider.hour = widget.route.hour;
              Navigator.push(context, MaterialPageRoute(builder: (context) => RouteRegisterPage(route: widget.route)));
            }
          )
        ]
      );
    });
  }

  Widget _background(Responsive responsiveScreen) {
    return Container(
      width: double.infinity,
      height: responsiveScreen.hp(45),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.3),
          end: FractionalOffset(0.0, 0.0),
          colors:[OurColors.initialPurple, OurColors.finalPurple]
        )
      )
    );
  }

  Widget _tabBar(Responsive responsiveScreen) {
    return Container(
      height: responsiveScreen.hp(40),
      margin: EdgeInsets.only(top: responsiveScreen.hp(28)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.0,
            offset: Offset(0.0, 4.0),
            spreadRadius: 3.0
          )
        ]
      ),
      child: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
          children: [
            TabBar(
              indicatorColor: OurColors.lightGreenishBlue,
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.mapMarkerAlt, color: OurColors.black, size: responsiveScreen.ip(3))),
                Tab(icon: Icon(FontAwesomeIcons.car, color: OurColors.black, size: responsiveScreen.ip(3))),
                Tab(icon: Icon(FontAwesomeIcons.users, color: OurColors.black, size: responsiveScreen.ip(3))),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 28.0),
              height: responsiveScreen.hp(30),
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  _tabBarRoute(responsiveScreen),
                  _tabBarCar(responsiveScreen),
                  _tabBarUsers(responsiveScreen)
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _textFormField(IconData icon, String property, String value, Responsive responsiveScreen) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(1.8), color: OurColors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(icon, color: OurColors.lightGreenishBlue, size: responsiveScreen.ip(2.8)),
        labelText: property,
        labelStyle: TextStyle(fontFamily: 'WorkSansMedium', fontSize: responsiveScreen.ip(2)),
      )
    );
  }

  Widget _tabBarRoute(Responsive responsiveScreen) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            child: Text(widget.route.address, style: TextStyle(fontFamily: 'WorkSansSemiBold', color: Color(0XFF3B3E69), fontSize: responsiveScreen.ip(2)), textAlign: TextAlign.center),
          ),
          _textFormField(FontAwesomeIcons.calendarPlus, 'Fecha de creación', readableDate(widget.route.date), responsiveScreen),
          _textFormField(FontAwesomeIcons.calendar, 'Horario', stringSchedule(widget.route.schedule), responsiveScreen),
          _textFormField(FontAwesomeIcons.clock, 'Hora', widget.route.hour, responsiveScreen),
        ]
      )
    );
  }

  Widget _tabBarCar(Responsive responsiveScreen) {
    String seatsAvailable = (widget.route.seat - (widget.route.idUsers == null ? 0 : widget.route.idUsers.length)).toString();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _textFormField(FontAwesomeIcons.carSide, 'Marca', _driverModel.car.brand, responsiveScreen),
                _textFormField(FontAwesomeIcons.columns, 'Modelo', _driverModel.car.model, responsiveScreen),
                _textFormField(FontAwesomeIcons.addressCard, 'Placa', _driverModel.car.registry, responsiveScreen),
                _textFormField(FontAwesomeIcons.palette, 'Color', _driverModel.car.color, responsiveScreen),
              ]
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(seatsAvailable, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(5), color: OurColors.darkPurple)),
              Text(seatsAvailable != '1' ? 'Asientos' : 'Asiento', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.8), color: OurColors.darkPurple)),
              Text(seatsAvailable != '1' ? 'Disponibles' : 'Disponible', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.8), color: OurColors.darkPurple)),
            ],
          ),
        ],
      )
    );
  }

  Widget _tabBarUsers(Responsive responsiveScreen) {
    if (_prefs.mode == 'CONDUCTOR') {
      return (widget.route.users != null) ? ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.route.users.length,
        itemBuilder: (BuildContext context, int i){
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _photoUsers(widget.route.users[i].photo, responsiveScreen),
                  Text('${widget.route.users[i].name} ${widget.route.users[i].lastname}', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 15.0)),
                  IconButton(
                    icon: Icon(Icons.flag, size: responsiveScreen.ip(3.5)),
                    onPressed: () => _showSheet(responsiveScreen, widget.route.users[i].id)
                  ),
                ]
              ),
              Divider()
            ]
          );
        }
      ) : Container();  
    } else {
      return (widget.route.users != null) 
      ? SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: widget.route.users.map((user) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: _photoUsers(user.photo, responsiveScreen),
            )).toList().cast<Widget>(),
          ),
        ),
      ) : Container();
    } 
  }

  Widget _map(Responsive responsiveScreen) {
    return Container(
      width: double.infinity,
      height: responsiveScreen.hp(50),
      margin: EdgeInsets.only(top: responsiveScreen.hp(50)),
      child: SimpleMapWidget(latLng: widget.route.coordinates, type: 1)
    );
  }

  Widget _infoDriver(Responsive responsiveScreen) {
    return Container(
      height: responsiveScreen.hp(23),
      padding: EdgeInsets.all(15.0),
      margin: EdgeInsets.only(top: responsiveScreen.hp(9)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('${_driverModel.name} ${_driverModel.lastname}', style: TextStyle(fontFamily: 'WorkSansLight', color: Colors.white, fontSize: responsiveScreen.ip(2))),
              Text('Telf: ${_driverModel.phone}', textAlign: TextAlign.left, style: TextStyle(fontFamily: 'WorkSansLight', color: Colors.white, fontSize: responsiveScreen.ip(2))),
              Visibility(
                visible: (_driverModel.rate != null),
                child: Text('${driverRating(_driverModel.rate).toStringAsFixed(2)} ★', style: TextStyle(fontFamily: 'WorkSansLight', color: Colors.white, fontSize: responsiveScreen.ip(2))),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FadeInRight(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: responsiveScreen.ip(7.0) * 2,
                      height: responsiveScreen.ip(5.0) * 2,
                    ),
                    _photoUser(responsiveScreen),
                    Visibility(
                      visible: _userRegister,
                      child: _starButton(responsiveScreen)
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _photoUser(Responsive responsiveScreen) {
    return ClipOval(
      child: (_driverModel.photo != null)
      ? FadeInImage(
        image: NetworkImage(_driverModel.photo),
        placeholder: AssetImage('assets/img/ripple-loading.gif'),
        height: responsiveScreen.ip(9.8),
        width: responsiveScreen.ip(9.8),
        fit: BoxFit.cover,
      )
      : Container()
    );
  }

  Widget _starButton(Responsive responsiveScreen) {
    return Positioned(
      bottom: 0,
      right: responsiveScreen.ip(7),
      child: InkWell(
        onTap: () => _showModalRatingDriver(responsiveScreen),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: responsiveScreen.ip(1.8),
          child: CircleAvatar(
            radius: responsiveScreen.ip(1.5),
            backgroundColor: OurColors.yellow,
            child: Icon(Icons.star, color: Colors.white, size: responsiveScreen.ip(2.5)),
          ),
        ),
      ),
    );
  }

  Widget _suscribeButton(Responsive responsiveScreen) {
    String seatsAvailable = (widget.route.seat - (widget.route.idUsers == null ? 0 : widget.route.idUsers.length)).toString();
    return Visibility(
      visible: _prefs.mode == 'PASAJERO' && (seatsAvailable != '0' || _userRegister) && !_isADriver,
      child: Positioned(
        top: responsiveScreen.hp(65.5),
        right: 0.0,
        child: Container(
          height: responsiveScreen.hp(5),
          decoration: BoxDecoration(
            color: _userRegister ? OurColors.red : OurColors.lightGreenishBlue,
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          child: Consumer2<RoutesProvider, UserProvider>(builder: (context, routesProvider, userProvider, child) {
            return MaterialButton(
              highlightColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  _userRegister ? 'CANCELAR' : 'REGISTRARSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsiveScreen.ip(1.5), 
                    fontFamily: "WorkSansMedium"
                  )
                ),
              ),
              onPressed: () async {
                if (_userRegister) {
                  final result = await _routeService.canceleRegisterUserRoute(widget.route.id);
                  if (result.status) {
                    widget.route.users.removeWhere((user) => (user.id == userProvider.user.id));
                    routesProvider.removeMyPaxRoutes = widget.route;
                    widget.route.seat = widget.route.seat + 1;
                    _userRegister = false;
                    showAlert(context, 'Viaje cancelado!', ValidatorResponse.iconData(result.code), 'El usuario ha cancelado su suscripción a este viaje.');
                  } else {
                    showAlert(context, 'Ups!', ValidatorResponse.iconData(result.code), result.message);
                  }
                } else {
                  final result = await _routeService.createRegisterUserRoute(widget.route.id);
                  if (result.status) {
                    if (widget.route.users == null) {
                      widget.route.users = List<UserModel>();
                    }
                    widget.route.seat = widget.route.seat - 1;
                    widget.route.users.add(userProvider.user);
                    routesProvider.addMyPaxRoutes = widget.route;
                    _userRegister = true;  
                    showAlert(context, 'Usuario registrado!', ValidatorResponse.iconData(result.code), '${_userRegister ? 'El usuario se ha registrado correctamente.' : 'Ha cancelado su suscripción a este viaje.'}');
                  } else {
                    showAlert(context, 'Ups!', ValidatorResponse.iconData(result.code), result.message);
                  }
                }
                setState(() {});
              }
            );
          }),
        ),
      ),
    );
  }

  Widget _photoUsers(String photo, Responsive responsive){
    double size = (_prefs.mode == 'CONDUCTOR') ? responsive.ip(6.8) : responsive.ip(9);
    return Container(
      width: size,
      height: size,
      child: ClipOval(
        child: (photo != null) ? FadeInImage(
          image: NetworkImage(photo),
        placeholder: AssetImage('assets/img/ripple-loading.gif'),
        fit: BoxFit.fill,
        ) : Container()
      )
    );
  }

  Widget _circularButtons(Responsive responsiveScreen) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(15.0),
            child: CupertinoButton(
              padding: EdgeInsets.all(10.0),
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.black26,
              child: Icon(Icons.arrow_back, color: Colors.white, size: responsiveScreen.ip(2.5)),
              onPressed: () => Navigator.pop(context)
            )
          ),
          Visibility(
            visible: (_prefs.mode == 'PASAJERO') && !_isADriver,
            child: Container(
              margin: EdgeInsets.all(15.0),
              child: CupertinoButton(
                padding: EdgeInsets.all(10.0),
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.black26,
                child: Icon(Icons.flag, color: Colors.white, size: responsiveScreen.ip(2.5)),
                onPressed: () => _showSheet(responsiveScreen)
              )
            ),
          ),
        ],
      ),
    );
  }

  void _showSheet(Responsive responsiveScreen, [String userReported]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: StatefulBuilder(builder: (BuildContext context, StateSetter modalState) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              reverse: true,
              child: Form(
                key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.0, left: 15.0, top: 15.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Denunciar', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(2), color: OurColors.black)),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.close_outlined, color: OurColors.red, size: responsiveScreen.ip(3.0)),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: Text('¿Por qué quieres denunciar ${(_prefs.mode == 'PASAJERO') ? 'ésta publicación' : 'a este pasajero'}?', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: responsiveScreen.ip(1.8), color: OurColors.black)),
                    ),
                    Container(
                      height: responsiveScreen.hp(45),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: Reports.list.length,
                        itemBuilder: (BuildContext context, int i) => RadioListTile(
                          value: i,
                          groupValue: _groupSelected,
                          onChanged: (value) => _showCheck(modalState, i, value),
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(Reports.list[i], style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.7)))
                        )
                      ),
                    ),
                    Visibility(
                      visible: _checks.last,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0, left: 15.0),
                        child: TextFormField(
                          maxLines: 2,
                          maxLength: 120,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.7), color: OurColors.black),
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            filled: true,
                            counterStyle: TextStyle(fontFamily: "WorkSansLight"),
                            hintStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.7)),
                            hintText: "Describa su queja",
                            fillColor: Colors.white30
                          ),
                          validator: (value) {
                            if (value != "") {
                              modalState(() =>_visibleWarning = true);
                              return null;
                            }
                            return "";
                          },
                          onChanged: (value) => _reportModel.description = value,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _visibleWarning,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                        child: Text('** Elija una opción válida!', style: TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935))),
                      ),
                    ),
                    _sendReportButton(responsiveScreen, modalState, userReported)
                  ],
                ),
              ),
            );
          }),
        );
      }
    ).whenComplete(() {
      setState(() {
        _groupSelected = null;
        _visibleWarning = false;
        _checks = _checks.map((check) => false).toList();
      });
    });
  }

  Widget _sendReportButton(Responsive responsiveScreen, void modalState(void function()), [String userReported]) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.0),
        child: MaterialButton(
          color: OurColors.lightGreenishBlue,
          highlightColor: Colors.transparent,
          splashColor: OurColors.lightGreenishBlue,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text("ENVIAR", style: TextStyle(color: Colors.white, fontSize: responsiveScreen.ip(1.5), fontFamily: "WorkSansMedium"),
            ),
          ),
          onPressed: () async {
            if (_noErrorFormReport()) {
              modalState(() {
                _visibleWarning = false;
              });
              if (userReported != null) {
                _reportModel.type = 2; 
                _reportModel.idUser = userReported;
                _reportModel.idDriver = _prefs.uid;
              } else {
                _reportModel.type = 1; 
                _reportModel.idUser = _prefs.uid;
                _reportModel.idDriver = _driverModel.id;
              }
              _reportModel.idRoute = widget.route.id;
              _reportModel.date = DateTime.now().toString();
              if (!_checks.last) {
                _reportModel.description = _reportDescription();
              }
              final result = await _routeService.createReportRoute(_reportModel);
              if (result.status) {
                Navigator.pop(context);
                showAlert(context, 'Gracias por informarnos!', ValidatorResponse.iconData(result.code), 'Tus comentarios nos ayudan a que esta comunidad sea un lugar seguro.');  
              }
            } else {
              modalState(() {
                _visibleWarning = true;
              });
            }
          }
        ),
      ),
    );
  }

  void _showModalRatingDriver(Responsive responsiveScreen) {
    showDialog(
      context: context,
      builder: (context) => Consumer<RoutesProvider>(builder: (context, provider, child) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          title: Text("Valore al conductor:", style: TextStyle(fontSize: responsiveScreen.ip(2), fontFamily: 'WorkSansSemiBold', color: OurColors.black)),
          content: SmoothStarRating(
            rating: (provider.ratingDriver == 0) ? checkIfUserRated(_driverModel.rate, _prefs.uid) : provider.ratingDriver,
            allowHalfRating: true,
            starCount: 5,
            size: responsiveScreen.ip(5.5),
            isReadOnly: false,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            defaultIconData: Icons.star_border,
            color: OurColors.yellow,
            borderColor: OurColors.yellow,
            onRated: (value) async {
              provider.ratingDriver = value;
              await _userService.addOrUpdateRating2Driver(_driverModel.id, value);
              setState(() {});
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK', style: TextStyle(fontFamily: 'WorkSansSemiBold', color: OurColors.lightGreenishBlue, fontSize: responsiveScreen.ip(2))),
              onPressed: () {
                provider.ratingDriver = 0;
                Navigator.of(context).pop();
              }
            )
          ],
        );
      })
    );
  }

  void _showCheck(void modalState(void function()), int i, int value) {
    _groupSelected = value;
    modalState(() {
      _checks[i] = !_checks[i];
      _visibleWarning =  false;
    });
    if (_checks[i]) {
      modalState(() {
        _checks = _checks.map((check) => false).toList();
        _checks[i] = true;
      });
    }
  }

  bool _noErrorFormReport() {
    if ((_checks.last && _formKey1.currentState.validate()) || (!_checks.last && validatorChecks(_checks))) {
      return true;
    } else {
      return false;
    }
  }

  String _reportDescription() {
    for (int i = 0; i < _checks.length; i++) {
      if (_checks[i] == true) {
        return Reports.list[i];
      }
    }
    return '';
  }

}
