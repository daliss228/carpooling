import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/style/theme.dart'  as Theme;

// pagina para seleccionar el modo de usuario de la aplicacion
class ModePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  _botonesModoUsuario2('pasajero.png', 'Pasajero', context),
                  _botonesModoUsuario2('conductor.png', 'Conductor', context),
                ],
              ),
            ),
          ],
        ),
      )
    ); 
  }

  // widget para elegir el tipo de usuario de la app, existen 3 modelos de disenio
  Widget _botonesModoUsuario1(String imagen, String usuario, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, 'home'),
      child: Center(
        child: Container( 
          // height: 210.0,
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                // offset: Offset(0.0, 10.0)
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
               backgroundColor: Colors.transparent,
                radius: 70.0,
                child: Image(
                  image: AssetImage('assets/img/$imagen'),
                  height: 130,
                ),
              ),
              Text(usuario, style: TextStyle(fontSize: 18.0, fontFamily: "WorkSansBold", color: Theme.Colors.loginGradientEnd))
            ],
          )
        ),
      ),
    );
  }

  Widget _botonesModoUsuario2(String imagen, String usuario, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, 'home'),
      child: Stack(
        children: <Widget>[
          Container(
            height: 300.0,
            width: 180.0,
          ),
          Positioned(
            left: 18,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 70.0,
              child: Image(
                image: AssetImage('assets/img/$imagen'),
                height: 130,
              ),
            ),
          ),
          Positioned(
            top: 126,
            // left: 10,
            child: Container( 
              height: 80.0,
              width: 170.0,
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(width: 3.5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 10.0)
                  )
                ],
                color: Theme.Colors.loginGradientEnd,
                borderRadius: BorderRadius.circular(30.0)
              ),
              child: Center(child: Text(usuario, style: TextStyle(fontSize: 18.0, fontFamily: "WorkSansBold", color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonesModoUsuario3_1(String imagen, String usuario, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, 'home'),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 70.0,
            child: Image(
              image: AssetImage('assets/img/$imagen'),
              height: 130,
            ),
          ),
          Container( 
            height: 80.0,
            width: 170.0,
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(width: 3.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 10.0)
                )
              ],
              color: Theme.Colors.loginGradientEnd,
              borderRadius: BorderRadius.circular(30.0)
            ),
            child: Row(
              children: <Widget>[
                Image.asset('assets/img/light_right.png',
                  height: 50,
                  width: 58,
                ),
                SizedBox(width: 10.0),
                Center(child: Text(usuario, style: TextStyle(fontSize: 14.0, fontFamily: "WorkSansBold", color: Colors.white))),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _botonesModoUsuario3_2(String imagen, String usuario, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, 'home'),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 70.0,
            child: Image(
              image: AssetImage('assets/img/$imagen'),
              height: 130,
            ),
          ),
          Container( 
            height: 80.0,
            width: 170.0,
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(width: 3.5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 10.0)
                )
              ],
              color: Theme.Colors.loginGradientEnd,
              borderRadius: BorderRadius.circular(30.0)
            ),
            child: Row(
              children: <Widget>[
                Center(child: Text(usuario, style: TextStyle(fontSize: 14.0, fontFamily: "WorkSansBold", color: Colors.white))),
                SizedBox(width: 10.0),
                Image.asset('assets/img/light_left.png',
                  height: 50,
                  width: 58,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

