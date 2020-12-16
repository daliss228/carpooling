import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/utils/helpers.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/models/car_model.dart';
import 'package:flutter_carpooling/src/utils/user_prefs.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/services/car_service.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';

class AutoRegisterPage extends StatefulWidget {
  
  @override
  _AutoRegisterPageState createState() => _AutoRegisterPageState();
}

class _AutoRegisterPageState extends State<AutoRegisterPage> {
final TextEditingController _registryEdtCtr = TextEditingController();
  final TextEditingController _brandEdtCtr = TextEditingController();
  final TextEditingController _modelEdtCtr = TextEditingController();
  final TextEditingController _seatEdtCtr = TextEditingController();
  final TextEditingController _colorEdtCtr = TextEditingController();

  final TextStyle _styleText = TextStyle(fontFamily: "WorkSansLight", fontSize: 17.0, color: Colors.black, fontWeight: FontWeight.w300);
  final TextStyle _styleHint = TextStyle(fontFamily: "WorkSansLight", fontSize: 17.0, fontWeight: FontWeight.w300, color: Colors.black);
  final formRegisterAutoKey = GlobalKey<FormState>();
  final carProvider = new CarService(); 
  final prefs = new UserPreferences();
  final car = new CarModel();
  String uid; 
  bool _argument;
  int groupRadioButtons;
  bool isEnabled= true;
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    groupRadioButtons = 0;
    uid = prefs.uid.toString();
    loadingData();
  }

  @override
  void dispose() {
    super.dispose();
    _registryEdtCtr.clear();
    _brandEdtCtr.clear();
    _modelEdtCtr.clear();
    _seatEdtCtr.clear();
    _colorEdtCtr.clear();
  }

  changeButton(){
    setState(() {
      isEnabled = !isEnabled;
    });
  }

  Future<void> loadingData() async {
    try{
      Map _carResult = await carProvider.searchCar(uid);
      CarModel carModel = _carResult["carData"];
      isloading = false;
      setState(() {
        if(_carResult["ok"]){
          isEnabled = false;
          _registryEdtCtr.text = carModel.registry; 
          _brandEdtCtr.text = carModel.brand;
          _modelEdtCtr.text = carModel.model;
          _seatEdtCtr.text = carModel.seat.toString();
          selectDataRBtn(carModel.color);
        }
      });
    }catch (e){
      isloading = false;
      setState(() {
        isEnabled = true;
        _registryEdtCtr.text = "";
        _brandEdtCtr.text    = "";
        _modelEdtCtr.text    = "";
        _seatEdtCtr.text     = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    final screenSize = MediaQuery.of(context).size;
    _argument = ModalRoute.of(context).settings.arguments;

   return Scaffold(
      body: Stack(
        children: <Widget>[
          _backgroundApp(), 
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _containerText(responsiveScreen),
                  _formulario(screenSize, responsiveScreen, groupRadioButtons)
                ],
              ),
            )
          ),
          !_argument? Positioned(
              left: responsiveScreen.wp(2),
              top: responsiveScreen.wp(2),
              child: SafeArea(
                child: CupertinoButton(
                  padding: EdgeInsets.all(10.0),
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.black26,
                  child: Icon(Icons.arrow_back, color: Colors.white,), 
                  onPressed: (){Navigator.pop(context);},

                ),
              )
            ): Container(),

            !_argument? Positioned(
              right: responsiveScreen.wp(2),
              top: responsiveScreen.wp(2),
              child: SafeArea(
                child: CupertinoButton(
                  padding: EdgeInsets.all(10.0),
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.black26,
                  child: Icon(Icons.edit, color: Colors.white,), 
                  onPressed: (){
                    changeButton();
                  },
                ),
              )
            ): Container(),

            isloading? LoadingWidget(): Container()
          
        ],
      )
    );
  }

  Widget _containerText(Responsive responsiveScreen){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsiveScreen.ip(2)),
      height: responsiveScreen.hp(25),
      color: Colors.black12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: responsiveScreen.hp(4),),
          FadeInLeft(child: Text('Mi automóvil', style: TextStyle(fontSize: responsiveScreen.ip(4), fontFamily: 'WorkSansLight', color: Colors.white), )),
          SizedBox(height: responsiveScreen.hp(1),),
          FadeInLeft(
            child: Text(
              'No olvides registrar correctamente la información del automóvil.',
              style: TextStyle(fontSize: responsiveScreen.ip(1.6) , fontWeight: FontWeight.w300, color: Colors.white),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  Widget _backgroundApp(){
    final gradiente = Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.3),
          end: FractionalOffset(0.0, 0.0),
          colors:[OurColors.initialPurple, OurColors.finalPurple]
        )
      ),
    );
    return Stack(
      children: <Widget>[
        gradiente
      ],
    ); 
  }

  Widget _formulario(Size screenSize, Responsive responsiveScreen, int groupRadioButtons){
    double heightSize = screenSize.height - (screenSize.height * 0.25) - MediaQuery.of(context).padding.top;
    return Container(
      height:  heightSize,
      width: double.infinity,
      padding: EdgeInsets.only(top: responsiveScreen.hp(3), left: 40.0, right: 40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: SafeArea(
        child: Form(
          key: formRegisterAutoKey,
          child: FadeIn(
            duration: Duration(milliseconds: 2000),
            child: Column(
              children: <Widget>[
                _placa(), 
                SizedBox(height: responsiveScreen.hp(1),),
                _separador(screenSize),
                _marca(), 
                SizedBox(height: responsiveScreen.hp(1),),
                _separador(screenSize),
                _modelo(), 
                SizedBox(height: responsiveScreen.hp(1),),
                _separador(screenSize),
                _numAsientos(responsiveScreen), 
                SizedBox(height: responsiveScreen.hp(1),),
                _separador(screenSize),
                SizedBox(height: responsiveScreen.hp(2),),
                _color(groupRadioButtons),
                SizedBox(height: responsiveScreen.hp(3),),
                _btnReg(responsiveScreen)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placa(){
    return TextFormField(
      controller: _registryEdtCtr,
      enabled: isEnabled,
      textCapitalization: TextCapitalization.characters,
      style: _styleText,
      validator: (value){
        if(RegExp(r'^[A-Z0-9]+$').hasMatch(value) && value.length >= 6 && value.length <= 7){
          return null;
        }
        return 'Número de placa incorrecto';
      },
      onSaved: (value){car.registry = value;},
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Ejemplo: ABC123",
        hintStyle: _styleHint,
        labelText: "Placa",
        icon: Icon(Icons.chrome_reader_mode, color: Colors.black, size: 20.0,), 
      ),
    );
  }
  Widget _marca(){
    return TextFormField(
      controller: _brandEdtCtr,
      enabled: isEnabled,
      textCapitalization: TextCapitalization.words,
      style: _styleText,
      validator: (value){
        if(value.length >= 3 && value.length <= 50){
          return null;
        }
        return 'Ingrese el campo';
      },
      onSaved: (value){ car.brand = value;},
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Ejemplo: Chevrolet",
        hintStyle: _styleHint,
        labelText: "Marca",
        icon: Icon(Icons.directions_car, color: Colors.black, size: 20.0,)
      ),
    );
  }
  Widget _modelo(){
    return TextFormField(
      controller: _modelEdtCtr,
      textCapitalization: TextCapitalization.sentences,
      enabled: isEnabled,
      style: _styleText,
      validator: (value){
        if(value.length >= 3 && value.length <= 50){
          return null;
        }
        return 'Ingrese el campo';
      },
      onSaved: (value){ car.model = value;},
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Ejemplo: Aveo",
        hintStyle: _styleHint,
        labelText: "Modelo",
        icon: Icon(Icons.perm_data_setting, color: Colors.black, size: 20.0,)
      ),
    );
  }
  Widget _numAsientos(Responsive responsiveScreen){
    int numSeat = 0;
    return TextFormField(
      controller: _seatEdtCtr,
      textCapitalization: TextCapitalization.sentences,
      enabled: isEnabled,
      keyboardType: TextInputType.number,
      style: _styleText,
      validator: (value){
        if(isNumeric(value) && value.length == 1){
          numSeat = int.parse(value);
          if(numSeat >= 2 && numSeat <= 8){
            return null;  
          }
        }
        return 'Número de asientos incorrecto';
      },
      onSaved: (value){ car.seat = numSeat;},
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Ejemplo: 3",
        hintStyle: _styleHint,
        labelText: "Número de asientos:",
        icon: Icon(Icons.format_list_numbered, color: Colors.black, size: responsiveScreen.ip(2.5),)
      ),
    );
  }
  // TODO: ojo con este codigo
  Widget _btnReg(Responsive responsiveScreen){
    // return Center(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.all(Radius.circular(2.5)),
    //       boxShadow: <BoxShadow>[
    //         BoxShadow(
    //           color: Colors.black45,
    //           offset: Offset(0.0, 1.0),
    //           blurRadius: 10.0,
    //         ),
    //       ],
    //     ),
    //     child: 
    //     MaterialButton(
          
    //       color: Color(0xFF0393A5),
    //       highlightColor: Colors.transparent,
    //       splashColor: Tema.OurColors.lightGreenishBlue,
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(vertical: responsiveScreen.wp(1) , horizontal: responsiveScreen.wp(5)),
    //         child: Text(
    //           "GUARDAR",
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontSize: responsiveScreen.ip(2),
    //             fontFamily: "WorkSansBold"
    //           ),
    //         ),
    //       ),
    //       onPressed: isEnabled ? () async{
    //         await _saveCar();}  : null,
    //     )
    //   ),
    // ); 
    return Center(
      child: MaterialButton(
        color: OurColors.lightGreenishBlue,
        highlightColor: Colors.transparent,
        splashColor: OurColors.lightGreenishBlue,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
          child: Text("GUARDAR", style: TextStyle(color: Colors.white, fontSize: responsiveScreen.ip(1.5), fontFamily: "WorkSansMedium"),
          ),
        ),
        onPressed: isEnabled 
        ? () async{
          await _saveCar();
        }  
        : null,
      ),
    );
  }


  Widget _color(int groupRadioButtons){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Color", style: _styleHint),
        Container(
          child: Table(
            children: [
              TableRow(
                children: [
                  Radio(
                    activeColor: Colors.red,
                    value: 1, 
                    groupValue: groupRadioButtons, 
                    onChanged: isEnabled? (value){
                      selectedradioBtn(value);
                    } : null,
                  ),
                  Radio(
                    activeColor: Colors.black,
                    value: 2,
                    groupValue: groupRadioButtons, 
                    onChanged: isEnabled? (value){
                      selectedradioBtn(value);
                    } : null,
                  ),
                  Radio(
                    activeColor: Colors.black,
                    value: 3, 
                    groupValue: groupRadioButtons, 
                    onChanged: isEnabled? (value){
                      selectedradioBtn(value);
                    } : null,
                  ),
                  Radio(
                    activeColor: Colors.grey,
                    value: 4,
                    groupValue: groupRadioButtons, 
                    onChanged: isEnabled? (value){
                      selectedradioBtn(value);
                    } : null,
                  ),
                  Radio(
                    activeColor: Colors.green,
                    value: 5, 
                    groupValue: groupRadioButtons, 
                    onChanged: isEnabled? (value){
                      selectedradioBtn(value);
                    } : null,
                  ),
                  Radio(
                    activeColor: Colors.blue,
                    value: 6,
                    groupValue: groupRadioButtons, 
                    onChanged: isEnabled? (value){
                      selectedradioBtn(value);
                    } : null,
                  ),
                  
                ]
              ),
              TableRow(
                children: [
                  Center(child: Text('Rojo', style: _styleHint,)),
                  Center(child: Text('Blanco', style: _styleHint)),
                  Center(child: Text('Negro', style: _styleHint)),
                  Center(child: Text('Gris' , style: _styleHint)),
                  Center(child: Text('Verde', style: _styleHint)),
                  Center(child: Text('Azul' , style: _styleHint)),
                ]
              ),
            ],
          ),
        ),

      ],
      
    ); 
  }

  selectedradioBtn(int val){
  String colorCar; 
    if(val == 1){
      colorCar = "Rojo";
    }else if (val == 2){
     colorCar = "Blanco";
    }else if (val == 3){
     colorCar = "Negro";
    }else if (val == 4){
     colorCar = "Gris";
    }else if (val == 5){
     colorCar = "Verde";
    }else if (val == 6){
     colorCar = "Azul";
    }
    setState(() {
      groupRadioButtons = val;
      car.color = colorCar;
    });
  }

  selectDataRBtn(String color){
    if(color == "Rojo"){
      groupRadioButtons = 1; 
    }else if(color == "Blanco"){
      groupRadioButtons = 2;
    }else if(color == "Negro"){
      groupRadioButtons = 3;
    }else if(color == "Gris"){
      groupRadioButtons = 4;
    }else if(color == "Verde"){
      groupRadioButtons = 5;
    }else if(color == "Azul"){
      groupRadioButtons = 6;
    }
    setState(() {
    });
  }



  _saveCar() async{  
    if(!formRegisterAutoKey.currentState.validate()) return; 
    formRegisterAutoKey.currentState.save(); 
    if(isloading) return;
    setState(() {
      isloading = true; 
    });
    await carProvider.createCar(uid, car);
    setState(() {
      isloading = false;
    });
    Navigator.pushReplacementNamed(context, 'after'); 

  }

  Widget _separador(Size screenSize){
    return Container(
      width: screenSize.width * 0.75,
      height: 1.0,
      color: Colors.grey,
    );
  }
}