import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import 'package:intl/intl.dart';


class ViajesPage extends StatefulWidget {
  ViajesPage({Key key}) : super(key: key);

  @override
  _ViajesPageState createState() => _ViajesPageState();
}

class _ViajesPageState extends State<ViajesPage> {  
  bool valorCheckBoxLun = false;
  bool valorCheckBoxMar = false;
  bool valorCheckBoxMie = false;
  bool valorCheckBoxJue = false;
  bool valorCheckBoxVie = false;
  bool valorCheckBoxSab = false;
  bool valorCheckBoxDom = false;

  TimeOfDay _time;
  DateTime selectedDate = DateTime.now(); 
  final DateFormat dateFormat = DateFormat('HH:mm');


  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(-0.277369, -78.557692);


  Future <TimeOfDay> selecTime(BuildContext context) async {
    _time = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(), 
       builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
  } 


    @override
    Widget build(BuildContext context) {
      
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _contenedorGPS(), 
              _contenedorInfo()
            ],
          ),
        ), 
      ); 
    }
  
    Widget _contenedorGPS(){
      final _screenSize = MediaQuery.of(context).size;
      return Container(
        width: double.infinity,
        height: _screenSize.height * 0.65,
        child: Expanded(
          child: GoogleMap(
              initialCameraPosition: CameraPosition(
              target: _mainLocation,
              zoom: 15.0,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
            ].toSet(),
            markers: this.myMarker(),
            mapType: MapType.normal,
            onMapCreated: (controller) {
              setState(() {
                myMapController = controller;
              });
            },
          ),
        ),
      ); 
    }


    Set<Marker> myMarker() {
    setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_mainLocation.toString()),
          position: _mainLocation,
          infoWindow: InfoWindow(
            title: 'Historical City',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
      return _markers;
    }


  
    Widget _contenedorInfo(){
      final _screenSize = MediaQuery.of(context).size;
      return Container(
        padding: EdgeInsets.all(20.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _cajaBusqueda(),
            SizedBox(height: 20.0,),
            Text(
              'Indica los días de tu recorrido',
              textAlign: TextAlign.end,
              style: TextStyle(fontFamily: 'WorkSans', fontSize: 15.0),
            ),
            _cajaDias(), 
            SizedBox(height: 20.0,),
            Divider(), 
            _cajaHora(), 
            Divider(), 
            ButtonTheme(
              minWidth: double.infinity,
              child: RaisedButton(
                child: Text(
                  'Confirmar', 
                  style: TextStyle(fontFamily: 'WorkSans', fontSize: 17.0, color: Colors.white),
                  
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                onPressed: (){
                  
                }
              ),
            )
          ],
        ),
      ); 
    }

    Widget _cajaBusqueda(){
      return TextField(
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: "¿A dónde vas?",
          hintStyle: TextStyle(fontFamily: "WorkSans", fontSize: 18.0, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
        ),
      );
    } 

    Widget _cajaDias(){
      return Container(
        child: Table(
          children: [
            TableRow(
              children: [
                Checkbox(
                  value: valorCheckBoxLun, 
                  onChanged: (bool valor){
                    print('${valor}Lunes'); 
                    setState(() {
                      valorCheckBoxLun = valor;
                    });
                  }
                ),
                Checkbox(
                  value: valorCheckBoxMar, 
                  onChanged: (bool valor){
                    print('${valor}Martes'); 
                    setState(() {
                      valorCheckBoxMar = valor;
                    });
                  }
                ),
                Checkbox(
                  value: valorCheckBoxMie, 
                  onChanged: (bool valor){
                    print('${valor}Miercoles'); 
                    setState(() {
                      valorCheckBoxMie = valor;
                    });
                  }
                ),
                Checkbox(
                  value: valorCheckBoxJue, 
                  onChanged: (bool valor){
                    print('${valor}Jueves'); 
                    setState(() {
                      valorCheckBoxJue = valor;
                    });
                  }
                ),
                Checkbox(
                  value: valorCheckBoxVie, 
                  onChanged: (bool valor){
                    print('${valor}Viernes'); 
                    setState(() {
                      valorCheckBoxVie = valor;
                    });
                  }
                ),
                Checkbox(
                  value: valorCheckBoxSab, 
                  onChanged: (bool valor){
                    print('${valor}Sabado'); 
                    setState(() {
                      valorCheckBoxSab = valor;
                    });
                  }
                ),
                Checkbox(
                  value: valorCheckBoxDom, 
                  onChanged: (bool valor){
                    print('${valor}Domingo'); 
                    setState(() {
                      valorCheckBoxDom = valor;
                    });
                  }
                ),
              ]
            ),
            TableRow(
              children: [
                Text('Lun', style: TextStyle(fontFamily: 'WorkSans', fontSize: 10.0),textAlign: TextAlign.center,),
                Text('Mar', style: TextStyle(fontFamily: 'WorkSans', fontSize: 10.0),textAlign: TextAlign.center,),
                Text('Mie', style: TextStyle(fontFamily: 'WorkSans', fontSize: 10.0),textAlign: TextAlign.center,),
                Text('Jue', style: TextStyle(fontFamily: 'WorkSans', fontSize: 10.0),textAlign: TextAlign.center,),
                Text('Vie', style: TextStyle(fontFamily: 'WorkSans', fontSize: 10.0),textAlign: TextAlign.center,),
                Text('Sab', style: TextStyle(fontFamily: 'WorkSans', fontSize: 10.0),textAlign: TextAlign.center,),
                Text('Dom', style: TextStyle(fontFamily: 'WorkSans', fontSize: 10.0),textAlign: TextAlign.center,),
              ]
            )
          ],
        )
      ); 
    }

    Widget _cajaHora(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            _time == null ? 'Pulsa el icono para ingresar la hora de salida' : dateFormat.format(selectedDate).toString(), 
            style: TextStyle(fontFamily: 'WorkSans', fontSize: 15.0),
          ), 
          IconButton(
            icon: Icon(Icons.access_time, size: 30.0,), 
            onPressed: () async {
              await selecTime(context);
              selectedDate = DateTime(
                selectedDate.year, 
                selectedDate.month, 
                selectedDate.day, 
                _time.hour, 
                _time.minute
              );
              setState(() {
              });
            }
          )
        ],
      );
    }
  
  }
