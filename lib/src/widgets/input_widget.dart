import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class InputWidget extends StatefulWidget {
  final String label;
  final String errorLabel;
  final IconData icono;
  final bool obscureText;
  final TextCapitalization textCapitalization; 
  final TextInputType inputType;
  final Function(String) validator; 
  final Function(String) onChanged;
  final Function(String) onSaved; 

  const InputWidget({Key key, @required this.label, @required this.icono, this.obscureText = false, this.inputType = TextInputType.text, this.validator, this.onChanged, this.errorLabel, this.textCapitalization = TextCapitalization.none, this.onSaved}) : super(key: key); 


  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization,
      obscureText: widget.obscureText,
      keyboardType: widget.inputType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      style: TextStyle(
          fontFamily: "WorkSansSemiBold",
          fontSize: 16.0,
          color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          widget.icono,
          color: Colors.black,
          size: 22.0,
        ),
        hintText: widget.label,
        hintStyle: TextStyle(
            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
        errorText:widget.errorLabel,
      ),
    );
  }
}