import 'package:flutter/material.dart';

class RegistroAutoPage extends StatefulWidget {
  @override
  _RegistroAutoPageState createState() => _RegistroAutoPageState();
}

class _RegistroAutoPageState extends State<RegistroAutoPage> {

  bool verde = false; 
  bool azul = false; 
  bool red = false; 
  bool gris = false; 
  bool blaco = false;
  bool negro = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registra tu auto'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              _placa(), 
              Divider(),
              _marca(), 
              Divider(), 
              _modelo(), 
              Divider(),
              _numAsientos(), 
              Divider(), 
              _color(), 
              Divider(), 
              RaisedButton(
                child: Text('Registrar'),
                onPressed: (){}
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget _placa(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: "Ejemplo de placa: ABC-1234",
        labelText: "Placa:",
        icon: Icon(Icons.chrome_reader_mode)
      ),
    );
  }
  Widget _marca(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: "Ejemplo de marca: Chevrolet",
        labelText: "Marca:",
        icon: Icon(Icons.directions_car)
      ),
    );
  }
  Widget _modelo(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: "Ejemplo de modelo: Aveo",
        labelText: "Modelo:",
        icon: Icon(Icons.perm_data_setting)
      ),
    );
  }
  Widget _numAsientos(){
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: "Ejemplo de número de asientos: 3",
        labelText: "Número de asientos:",
        icon: Icon(Icons.format_list_numbered)
      ),
    );
  }


  Widget _color(){
    return Container(
      child: Table(
        children: [
          TableRow(
            children: [
              Checkbox(
                value: red, 
                onChanged: (bool valor){
                  setState(() {
                    verde = false; 
                    azul = false; 
                    red = valor; 
                    gris = false; 
                    blaco = false;
                    negro = false;
                  });
                }
              ),
              Checkbox(
                value: blaco, 
                onChanged: (bool valor){
                  setState(() {
                    verde = false; 
                    azul = false; 
                    red = false; 
                    gris = false; 
                    blaco = valor;
                    negro = false;
                  });
                }
              ),
              Checkbox(
                value: negro, 
                onChanged: (bool valor){
                  setState(() {
                    verde = false; 
                    azul = false; 
                    red = false; 
                    gris = false; 
                    blaco = false;
                    negro = valor;
                  });
                }
              ),
              Checkbox(
                value: gris, 
                onChanged: (bool valor){
                  setState(() {
                    verde = false; 
                    azul = false; 
                    red = false; 
                    gris = valor; 
                    blaco = false;
                    negro = false;
                  });
                }
              ),
              Checkbox(
                value: verde, 
                onChanged: (bool valor){
                  setState(() {
                    verde = valor; 
                    azul = false; 
                    red = false; 
                    gris = false; 
                    blaco = false;
                    negro = false;
                  });
                }
              ),
              Checkbox(
                value: azul, 
                onChanged: (bool valor){
                  setState(() {
                    azul = valor;
                    verde = false; 
                    red = false; 
                    gris = false; 
                    blaco = false;
                    negro = false;
                  });
                }
              ),
            ]
          )
        ],
      ),
    ); 
  }






}