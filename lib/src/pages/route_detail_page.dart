import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/utils.dart';
// import 'package:flutter_carpooling/src/widgets/map_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/models/route_model.dart';
import 'package:flutter_carpooling/src/services/route_service.dart';

class RouteDetailPage extends StatefulWidget {

  final RouteModel route;
  final String seatsAvailable;

  RouteDetailPage({@required this.route, @required this.seatsAvailable});

  @override
  _RouteDetailPageState createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {

  String useruid;
  // bool _userResgister = false;
  RouteService _routeService = RouteService();

  @override
  Widget build(BuildContext context) {
    final _sizeScren = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: _sizeScren.width,
            height: _sizeScren.height * 0.45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset(0.0, 0.3),
                end: FractionalOffset(0.0, 0.0),
                colors:[OurColors.initialPurple, OurColors.finalPurple]
              )
            ),
          ),
          _descriptionDriver(_sizeScren),
          _photoDriver(_sizeScren),
          _map(_sizeScren),
          _tabBar(_sizeScren),
          _comebackButton(_sizeScren),
          _suscribeButton(_sizeScren)
        ],
      )
    );
  }

  Widget _tabBar(_sizeScren) {
    return Column(
      children: [
        Container(
          height: _sizeScren.height * 0.24,
        ),
        Container(
          height: _sizeScren.height * 0.42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
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
                    Tab(icon: Icon(FontAwesomeIcons.mapMarkerAlt, color: OurColors.darkGray)),
                    Tab(icon: Icon(FontAwesomeIcons.car, color: OurColors.darkGray)),
                    Tab(icon: Icon(FontAwesomeIcons.users, color: OurColors.darkGray)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
                  height: _sizeScren.height * 0.34,
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      _tabBarRoute(),
                      _tabBarCar(),
                      _tabBarUsers()
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ]
    );
  }

  Widget _textFormField(IconData icon, String property, String value) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 15.0, color: OurColors.darkGray),
      decoration: InputDecoration(
        suffixStyle: TextStyle(fontFamily: 'WorkSansMedium'),
        border: InputBorder.none,
        icon: Icon(icon, color: OurColors.lightGreenishBlue),
        labelText: property,
        labelStyle: TextStyle(fontFamily: 'WorkSansMedium'),
      )
    );
  }

  Widget _tabBarRoute() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(widget.route.address, style: TextStyle(fontFamily: 'WorkSansSemiBold', color: Color(0XFF3B3E69), fontSize: 16.0), textAlign: TextAlign.center),
        ),
        _textFormField(FontAwesomeIcons.calendarPlus, 'Fecha de creación', 'Viernes, 21 de agosto de 2020'), // Todo: cambiar a widget.route.date
        _textFormField(FontAwesomeIcons.calendar, 'Horario', stringSchedule(widget.route.schedule)),
        _textFormField(FontAwesomeIcons.clock, 'Hora', widget.route.hour),
      ]
    );
  }

  Widget _tabBarCar() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _textFormField(FontAwesomeIcons.carSide, 'Marca', widget.route.driver.car.brand),
              _textFormField(FontAwesomeIcons.columns, 'Modelo', widget.route.driver.car.model),
              _textFormField(FontAwesomeIcons.addressCard, 'Placa', widget.route.driver.car.registry),
              _textFormField(FontAwesomeIcons.palette, 'Color', widget.route.driver.car.color),
            ]
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.seatsAvailable, style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 30.0, color: OurColors.darkPurple)),
            Text('Asientos', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 15.0, color: OurColors.darkPurple)),
            Text('Disponibles', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 15.0, color: OurColors.darkPurple)),
          ],
        ),
        SizedBox(width: 10.0)
      ],
    );
  }

  Widget _tabBarUsers() {
    return (widget.route.users != null) ? ListView.builder(
      itemCount: widget.route.users.length,
      itemBuilder: (BuildContext context, int i){
        return Column(
          children: [
            Row(
              children: [
                Expanded(flex: 1, child: Center(child: _photoUsers(widget.route.users[i].photo))),
                Expanded(flex: 2, child: Text('${widget.route.users[i].name} ${widget.route.users[i].lastName}', style: TextStyle(fontFamily: 'WorkSansMedium', fontSize: 15.0))),
                Expanded(flex: 1, child: Center(child: Icon(FontAwesomeIcons.whatsapp, size: 30.0))),
              ]
            ),
            Divider()
          ]
        );
      }
    ) : Container();
  }

  Widget _photoUsers(photo){
    return Container(
      width: 50.0,
      height: 50.0,
      child: ClipOval(
        child: (photo != null) ? FadeInImage(
          image: NetworkImage(photo),
          placeholder: AssetImage('assets/img/ripple-loading.gif'),
          height: 125.0,
          width: 125.0,
          fit: BoxFit.fill,
        ) : Container()
      )
    );
  }

  Widget _comebackButton(_sizeScren){
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 15.0, top: _sizeScren.height * 0.025),
        child: CupertinoButton(
          padding: EdgeInsets.all(10.0),
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.black26,
          child: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, 'home')
        )
      ),
    );
  }

  

  Widget _suscribeButton(_sizeScren){
    return Positioned(
      bottom: 20.0,
      right: 10.0,
      child: Column(
        children: [
          CupertinoButton(
            padding: EdgeInsets.all(10.0),
            borderRadius: BorderRadius.circular(30.0),
            color: OurColors.lightGreenishBlue,
            child: Icon(FontAwesomeIcons.clipboardCheck, color: Colors.white),
            onPressed: () async {
              await _routeService.createRegisterUserRoute('uidroute');
            }
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.white30,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 4.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Text(verifyUserRegister(widget.route.users) ? 'Cancelar' : 'Registrarse', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 14.0, color: OurColors.darkGray))
          )
        ],
      ),
    );
  }

  Widget _map(_sizeScren) {
    return Positioned(
      top: _sizeScren.height * 0.45,
      child: Container(
        width: _sizeScren.width,
        height: _sizeScren.height * 0.55,
        // child: MapWidget(latLng: widget.route.coordinates, type: 1)
      )
    );
  }

  Widget _photoDriver(_sizeScren) {
    return Positioned(
      top: _sizeScren.height * 0.12,
      right: 15.0,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 39.0,
        child: ClipOval(
          child: (widget.route.driver.photo != null) ? FadeInImage(
            image: NetworkImage(widget.route.driver.photo),
            placeholder: AssetImage('assets/img/ripple-loading.gif'),
            height: 75.0,
            width: 75.0,
            fit: BoxFit.fill,
          )
          : Container()
        ),
      )
    );
  }

  // Widget _photoDriver(_sizeScren) {
  //   return Positioned(
  //     top: _sizeScren.height * 0.12,
  //     right: 15.0,
  //     child: Container(
  //       child: CircleAvatar(
  //         backgroundColor: Colors.white,
  //         radius: 39.0,
  //         child: ClipOval(
  //           child: (widget.route.driver?.photo != null) 
  //           ? FadeInImage(
  //             image: NetworkImage(widget.route.driver.photo),
  //             placeholder: AssetImage('assets/img/ripple-loading.gif'),
  //             height: 125.0,
  //             width: 125.0,
  //             fit: BoxFit.fill,
  //           )
  //           : Container()
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _descriptionDriver(_sizeScren) {
    return Positioned(
      top: _sizeScren.height * 0.13,
      left: 15,
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Conductor:', style: TextStyle(fontFamily: 'WorkSansSemiBold', color: Colors.white, fontSize: 15.0)),
            Text('${widget.route.driver.name} ${widget.route.driver.lastName}', style: TextStyle(fontFamily: 'WorkSansLight', color: Colors.white, fontSize: 16.0)),
            Text(widget.route.driver.phone, textAlign: TextAlign.left, style: TextStyle(fontFamily: 'WorkSansLight', color: Colors.white, fontSize: 15.0)),
          ],
        ),
      ),
    );
  }

}