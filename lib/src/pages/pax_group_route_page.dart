import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';
import 'package:flutter_carpooling/src/widgets/loading_widget.dart';
import 'package:flutter_carpooling/src/widgets/list_view_widget.dart';
import 'package:flutter_carpooling/src/widgets/background_widget.dart';
import 'package:flutter_carpooling/src/providers/routes_provider.dart';

class PaxGroupRoutes extends StatefulWidget {

  @override
  _PaxGroupRoutesState createState() => _PaxGroupRoutesState();
}

class _PaxGroupRoutesState extends State<PaxGroupRoutes> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context)  {
    super.build(context);
    final responsiveScreen = Responsive(context); 
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            left: responsiveScreen.wp(75),
            child: FadeInRight(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: responsiveScreen.hp(34),))
          ),
          Positioned(
            top: responsiveScreen.hp(1),
            left: responsiveScreen.wp(75),
            child: FadeInRight(
              delay: Duration(milliseconds: 500),
              child: BackgoundWidget(colors: [OurColors.finalPurple, OurColors.initialPurple], sizeWidget: responsiveScreen.hp(30),)
            )
          ),
          Positioned(
            top: responsiveScreen.hp(70),
            right: responsiveScreen.wp(75),
            child: FadeInLeft(child: BackgoundWidget(colors: [OurColors.lightBlue, OurColors.lightGreenishBlue], sizeWidget: responsiveScreen.hp(30),))
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: responsiveScreen.hp(3)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: FadeInLeft(
                    child: Text(
                      'Rutas Disponibles',
                      style: TextStyle(
                        fontSize: responsiveScreen.ip(4),
                        fontFamily: 'WorkSansLight',
                        color: OurColors.black
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<RoutesProvider>(builder: (context, provider, child) { 
                    return (!provider.loading) 
                    ? ListViewWidget(routes: provider.myGroupRoutes, onRefresh: provider.readGroupRoute)
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