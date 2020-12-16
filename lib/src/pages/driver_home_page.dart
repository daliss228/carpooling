import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/widgets/list_view_widget.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';

class DriverHomePage extends StatefulWidget {

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _responsiveScreen = Responsive(context); 
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            left: _responsiveScreen.wp(75),
            child: FadeInRight(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(34),))
          ),
          Positioned(
            top: _responsiveScreen.hp(1),
            left: _responsiveScreen.wp(75),
            child: FadeInRight(
              delay: Duration(milliseconds: 500),
              child: BackgoundWidget(colors: [OurColors.initialPurple, OurColors.finalPurple], sizeWidget: _responsiveScreen.hp(30))
            )
          ),
          Positioned(
            top: _responsiveScreen.hp(70),
            right: _responsiveScreen.wp(75),
            child: FadeInLeft(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: _responsiveScreen.hp(30),))
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: _responsiveScreen.hp(3)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: FadeInLeft(
                    child: Text(
                      'Mis Rutas',
                      style: TextStyle(
                        fontSize: _responsiveScreen.ip(4),
                        fontFamily: 'WorkSansLight',
                        color: OurColors.black
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<RoutesProvider>(builder: (context, provider, child) {
                    return (!provider.loading) 
                    ? ListViewWidget(routes: provider.myDriverRoutes, onRefresh: provider.readGroupRoute)
                    : LoadingTwoWidget(size: 50.0);
                  })
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
