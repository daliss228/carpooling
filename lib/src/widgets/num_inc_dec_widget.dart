import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/colors.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';

class NumIncDecWidget extends StatefulWidget {

  final Function(int) onChanged;
  final int initValue;
  final int difValue;

  NumIncDecWidget({@required this.onChanged, this.initValue = 0, this.difValue = 0}) {
    assert(this.onChanged != null, this.initValue != null);
  }

  @override
  _NumIncDecWidgetState createState() => _NumIncDecWidgetState();
}

class _NumIncDecWidgetState extends State<NumIncDecWidget> {

  int value;

  @override
  void initState() {
    value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.remove_circle_outline, size: responsiveScreen.ip(3), color: OurColors.black),
          onPressed: () {
            if (value > 0) {
              setState(() {
                value--;
              });  
              widget.onChanged(value);
            }
          },
        ),
        Container(
          width: 30.0,
          alignment: Alignment.center,
          child: Text('$value', style: TextStyle(fontFamily: 'WorkSansLight', fontSize: responsiveScreen.ip(1.8), color: OurColors.black)),
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline, size: responsiveScreen.ip(3), color: OurColors.black),
          onPressed: () {
            print('😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏😏 $value + ${widget.difValue} = ${(value + widget.difValue)}');
            if ((value + widget.difValue) < 10) {
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

