import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';

class NumIncDecWidget extends StatefulWidget {

  final Function(int) onChanged;
  final int value;

  NumIncDecWidget({this.onChanged, this.value}) {
    assert(this.onChanged != null, this.value != null);
  }

  @override
  _NumIncDecWidgetState createState() => _NumIncDecWidgetState();
}

class _NumIncDecWidgetState extends State<NumIncDecWidget> {

  int value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, size: responsiveScreen.ip(3), color: OurColors.darkGray),
          onPressed: () {
            if (value > 1) {
              setState(() {
                value--;
              });  
              widget.onChanged(value);
            }
          },
        ),
        Container(
          width: 30,
          alignment: Alignment.center,
          child: Text('$value', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.8), color: OurColors.darkGray)),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline, size: responsiveScreen.ip(3), color: OurColors.darkGray),
          onPressed: () {
            if (value < 10) {
              setState(() {
                value++;
              });
              widget.onChanged(value);
            }
          },
        ),
      ],
    );
  }
  
}

