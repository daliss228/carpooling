import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Theme;

// paga que muestra el detalle de los viajes
class RouteDetallePage extends StatelessWidget {
  final estiloTexto = TextStyle(fontSize: 16.0, fontFamily: "WorkSansMedium", color: Colors.black);
  @override
  Widget build(BuildContext context) {
    final _sizeScren = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[  
              Container(
                height: _sizeScren.height * 0.30,
                width: _sizeScren.width,
                child: Image.asset('assets/img/map.png', 
                  fit: BoxFit.cover,
                )
              ),
              GestureDetector(
                onTap: (){print('ver mapa');},
                child: Container(
                  height: _sizeScren.height * 0.30,
                  width: _sizeScren.width,
                  color: Colors.black12,
                ),
              ),
              SafeArea(
                child: IconButton(
                  onPressed: (){print('ir a ventana anterior');},
                  icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white)
                ),
              ),
            ],
          ),
          //contenedor del detalle auto
          SingleChildScrollView(
            child: Container( 
              width: 300,
              height: 100.0,
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Modelo: Kia', style: TextStyle(fontSize: 16.0, fontFamily: "WorkSansSemiBold")),
                  Text('Marca: Sportage', style: TextStyle(fontSize: 16.0, fontFamily: "WorkSansSemiBold")),
                  Text('Placa: JBB-878', style: TextStyle(fontSize: 16.0, fontFamily: "WorkSansSemiBold"))
                ],
              )
            ),
          ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  enabled: false,
                  hintStyle: estiloTexto,
                  hintText: 'Destino: '
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                decoration: InputDecoration(
                  enabled: false,
                  hintStyle: estiloTexto,
                  hintText: 'Hora de salida: '
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                decoration: InputDecoration(
                  enabled: false,
                  hintStyle: estiloTexto,
                  hintText: 'Precio: '
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                decoration: InputDecoration(
                  enabled: false,
                  hintStyle: estiloTexto,
                  hintText: 'Asientos disponibles: '
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                decoration: InputDecoration(
                  enabled: false,
                  hintStyle: estiloTexto,
                  hintText: 'Días disponibles: '
                ),
              ),
            ],
          ),
        ),  
        SizedBox(height: 25.0,),
        // RaisedButton(
        //   onPressed: (){},
        //   color: Colors.blue,
        //   child: Text('Registrarse', style: TextStyle(fontSize: 16.0, fontFamily: "WorkSansMedium", color: Colors.white)),
        // ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: _sizeScren.height * 0.07,
          width: _sizeScren.width * 0.8,
          child: RaisedButton.icon(
            label: Text('Registrarme', style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: "OpenSans-Bold")),
            color: Theme.Colors.loginGradientStart,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            icon: Icon(Icons.playlist_add_check, color: Colors.white),
            onPressed: (){},
          ),
        ),

        ],
      )

    );
  }
}

// Row(
//   children: <Widget>[
//     Expanded(child: Column(
//       children: <Widget>[
//         Center(child: Text('Carl Johnson', style: estiloTexto)),
//         Center(child: Text('0980000000', style: estiloTexto)),
//       ],
//     )),
//     Container(
//       margin: EdgeInsets.only(right: 45.0, top: 10.0),
//       width: 80.0,
//       height: 80.0,
//       decoration: new BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//           fit: BoxFit.fill,
//           image: NetworkImage("https://i.imgur.com/BoN9kdC.png"),
//         )
//       )
//     ),
//   ],
// ),
