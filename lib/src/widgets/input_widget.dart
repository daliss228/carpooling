import 'package:flutter/material.dart';

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
    return TextFormField(
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      keyboardType: inputType,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      style: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 16.0, color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          icono,
          color: Colors.black,
          size: 22.0,
        ),
        hintText: label,
        hintStyle: TextStyle(fontFamily: "WorkSansSemiBold", fontSize: 17.0),
        errorText:errorLabel,
      ),
    );
  }
}