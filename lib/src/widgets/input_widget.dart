import 'package:flutter/material.dart';
import 'package:flutter_carpooling/src/utils/responsive.dart';

class InputWidget extends StatelessWidget {
  
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
  Widget build(BuildContext context) {
    final responsiveScreen = Responsive(context);
    return TextFormField(
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      keyboardType: inputType,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      style: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.9), color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          icono,
          color: Colors.black,
          size: responsiveScreen.ip(2),
        ),
        hintText: label,
        errorStyle: TextStyle(fontFamily: "WorkSansMedium", color: Color(0XFFE81935)),
        hintStyle: TextStyle(fontFamily: "WorkSansLight", fontSize: responsiveScreen.ip(1.8)),
        errorText: errorLabel,
      ),
    );
  }
}