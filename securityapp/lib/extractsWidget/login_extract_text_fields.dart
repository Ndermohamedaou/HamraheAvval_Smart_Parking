import 'package:flutter/material.dart';
import 'package:securityapp/constFile/ConstFile.dart';

class TextFields extends StatelessWidget {
  TextFields({this.lblText,
    this.onChangeText,
    this.textFieldIcon,
    this.textInputType,
    this.validate,
    this.iconPressed,
    this.maxLen,
    this.minLen,
    this.errText,
    this.enteringEditing});

  final String lblText;
  final Function onChangeText;
  final IconData textFieldIcon;
  final bool textInputType;
  final Function validate;
  final Function iconPressed;
  final int maxLen;
  final int minLen;
  final dynamic errText;
  final Function enteringEditing;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          maxLength: maxLen,
          validator: validate,
          obscureText: textInputType,
          textAlign: TextAlign.center,
          cursorColor: Colors.blue[900],
          decoration: InputDecoration(
            errorText: errText,
            errorStyle: TextStyle(fontFamily: mainFontFamily),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue[900],
                width: 2,
              ),
            ),
            fillColor: Colors.blue[900],
            labelText: lblText,
            //TODO Fill this section for extract my custom Widget
            labelStyle: TextStyle(fontFamily: mainFontFamily),
            border:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            suffixIcon: FlatButton(
              minWidth: 10,
              onPressed: iconPressed,
              child: Icon(
                textFieldIcon,
                color: Colors.blue[900],
              ),
            ),
          ),
          onChanged: onChangeText,
          onEditingComplete: enteringEditing,
        ),
      ),
    );
  }
}
