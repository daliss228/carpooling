import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/style/theme.dart' as Tema;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final estiloTexto = TextStyle(fontSize: 20.0, fontFamily: "WorkSansMedium", color: Colors.black);
  final estiloTextoSub = TextStyle(fontSize: 17.0, fontFamily: "WorkSansMedium", color: Colors.black);
  final estiloTextoLabels = TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size; 

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                width: double.infinity,
                height: 100,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    _portada(context),
                    Positioned(
                      left: (_screenSize.width * 0.5) - 60.0,
                      child: _fusionha()
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.0,),
              _camposUsuario(),

            ]),
          )
        ],
      )
    ); 
  }


  Widget _camposUsuario(){
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 70.0),
        child: Column(
          children: <Widget>[
            _nombreUsuario(), 
            SizedBox(height: 20.0,),
            _emailUsuario(),
            SizedBox(height: 20.0,),
            _cedulaUsuario(), 
            SizedBox(height: 20.0,), 
            _passwordUsuario(),
            SizedBox(height: 100.0,),
            Text('Conectate con:', style: estiloTextoSub,),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  iconSize: 50.0,
                  icon: Icon(FontAwesomeIcons.facebook), 
                  onPressed: (){
                    print('Boton de Facebook pulsado'); 
                  }
                ),
                IconButton(
                  iconSize: 50.0,
                  icon: Icon(FontAwesomeIcons.googlePlus), 
                  onPressed: (){
                    print('Botón de Google pulsado');
                  }
                )
              ],
            )
          ],
        )
      ),
    );
  }

  //Widgets para los campos a recibir

  Widget _nombreUsuario(){
    return TextField(
      enabled: false,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black
      ),
      decoration: InputDecoration(
        icon: Icon(
          FontAwesomeIcons.user,
          color: Colors.black,
        ),
        hintText: 'Héctor Analuisa',
        hintStyle: estiloTextoLabels
      ),
    );
  }

  Widget _emailUsuario(){
    return TextField(
      enabled: false,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black
      ),
      decoration: InputDecoration(
        icon: Icon(
          FontAwesomeIcons.envelope,
          color: Colors.black,
        ),
        hintText: 'hectorpm956@gmail.com',
        hintStyle: estiloTextoLabels
      ),
    );
  }

  Widget _cedulaUsuario(){
    return TextField(
      enabled: false,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black
      ),
      decoration: InputDecoration(
        icon: Icon(
          FontAwesomeIcons.indent,
          color: Colors.black,
        ),
        hintText: '1234567890',
        hintStyle: estiloTextoLabels
      ),
    );
  }

  Widget _passwordUsuario(){
    return TextField(
      enabled: false,
      obscureText: true,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black
      ),
      decoration: InputDecoration(
        icon: Icon(
          FontAwesomeIcons.lock,
          color: Colors.black,
        ),
        //labelText: 'Password',
        hintText: '******************',
        hintStyle: estiloTextoLabels
      ),
    );
  }


  //-----------------------------------------------------------FIN



  Widget _fusionha(){
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: <Widget>[
          _infoAvatarUser(),
          Positioned(
            bottom: 0.0,
            left: 90,
            child: CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 21.0,
                backgroundColor: Colors.black12,
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.camera,
                    color: Colors.black,
                    size: 20.0,
                  ), 
                  onPressed: (){
                    print('Pulsa camarita'); 
                  }
                ),
              ),
            )
          )

        ],
      ),
    ); 
  }

  Widget _infoAvatarUser(){
    return Container(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 60.0,
        child: ClipOval(
          child: Image(
            image: NetworkImage(
            'https://media.telemundo51.com/2019/09/riesgos-enfermedades-gatos7.jpg?fit=1200%2C800'),
            width: 115.0,
            height: 115.0,
            fit: BoxFit.cover,
            )
          ),
      ),
    );
  }

  Widget _portada( BuildContext context){ // Separado por que es un contenedor en una funcion
    return Container(
      padding: EdgeInsets.all(17.0),// COn este estoy separando de los bordes OJOOO OJOOO
      height: 75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Tema.Colors.loginGradientStart, Tema.Colors.loginGradientEnd]
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50.0),
          bottomLeft: Radius.circular(50.0)
        )
      ),
    );
  }

  //Widget para el uso de Nombre y cedula del usuario

  

  Widget _crearAppBar(){
    return SliverAppBar(
      pinned: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit), 
          onPressed: (){
            print('Boton de edición'); 
          }
        ),
      ],
      // Para darle un gradiente a la SliverAPPBAR es necesario hacer uso de un flexible space 
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Tema.Colors.loginGradientStart, Tema.Colors.loginGradientEnd])
        ),
      ),
    ); 
  }

}