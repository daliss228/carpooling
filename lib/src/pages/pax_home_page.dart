import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/widgets/card_widget.dart';
import 'package:flutter_carpooling/src/utils/colors.dart'  as Tema;

class PaxHomePage extends StatefulWidget {

  @override
  _PaxHomePageState createState() => _PaxHomePageState();
}

class _PaxHomePageState extends State<PaxHomePage> {

  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: _screenSize.width,
              height: _screenSize.height * 0.55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100.0), 
                ),
                gradient: LinearGradient(
                  colors: [
                    Tema.OurColors.lightBlue, 
                    Tema.OurColors.lightGreenishBlue
                  ]
                )
              ),
            ),
            Column(
              children: <Widget>[
                searchInput(),
                CardWidget(),
                SizedBox(height: 25.0)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget searchInput(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 25.0),
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Color(0xfff6f6f6),
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0.0, 2.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Buscar rutas",
                hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                border: InputBorder.none
              ),
            )
          ),
          InkWell(
            onTap: () {},
            child: Container(
              child: Icon(Icons.search, color: Tema.OurColors.lightGreenishBlue, size: 28.0)
            )
          )
        ],
      ),
    );
  }

}