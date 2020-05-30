import 'package:flutter/material.dart';

// card con las rutas de los destinos
class CardWidget extends StatefulWidget {
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'ride'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: _imageContainer(),
                title: Text('Daniel Mendoza', style: TextStyle(fontFamily: "WorkSansMedium")),
                subtitle: Text('Kia Sportage'),
              ),
              Container(
                padding: EdgeInsets.only(right: 15.0, left: 10.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.only(right: 3.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.location_on),
                                SizedBox(width: 5.0),
                                Flexible(child: Text('Terminal de Carcelén', style: TextStyle(fontFamily: "WorkSansLight", fontSize: 14.0)))
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.calendar_today, size: 20.0),
                                SizedBox(width: 8.0),
                                Flexible(child: Text('Lun-Mar-Mie-Jue-Vie', style: TextStyle(fontFamily: "WorkSansLight", fontSize: 14.0)))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text('4', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 24.0)),
                            Text('Asientos', style: TextStyle(fontFamily: "WorkSansMedium", fontSize: 14.0)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ESTE CÓDIGO MUESTRA UN BOTÓN EN LOS CARD
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     Container(
              //       padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
              //       child: RaisedButton(
              //         onPressed: (){},
              //         color: Theme.Colors.loginGradientEnd,
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              //         child: Text('Solicitar Viaje', style: TextStyle(fontFamily: "WorkSansMedium", color: Colors.white)),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // imagen de conductor 
  Widget _imageContainer(){
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: new BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black26),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage("https://i.imgur.com/BoN9kdC.png"
        )                    )
      )
    );
  }
}