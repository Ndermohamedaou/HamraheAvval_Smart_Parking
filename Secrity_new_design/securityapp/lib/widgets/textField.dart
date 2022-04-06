import 'package:securityapp/constFile/initVar.dart';
import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  TextFields({
    this.lblText,
    this.onChangeText,
    this.textFieldIcon,
    this.textInputType,
    this.validate,
    this.iconPressed,
    this.maxLen,
    this.errText,
    this.enteringEditing,
    this.readOnly,
    this.initValue,
    this.keyType,
  });

  final String lblText;
  final Function onChangeText;
  final IconData textFieldIcon;
  final bool textInputType;
  final Function validate;
  final Function iconPressed;
  final int maxLen;
  final dynamic errText;
  final Function enteringEditing;
  final bool readOnly;
  final String initValue;
  final keyType;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          readOnly: readOnly,
          keyboardType: keyType,
          initialValue: initValue,
          maxLength: maxLen,
          validator: validate,
          obscureText: textInputType,
          textAlign: TextAlign.center,
          cursorColor: mainCTA,
          decoration: InputDecoration(
            counterText: "",
            errorText: errText,
            errorStyle: TextStyle(fontFamily: mainFont),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: mainCTA,
                width: 2,
              ),
            ),
            fillColor: mainCTA,
            labelText: lblText,
            labelStyle: TextStyle(
                fontFamily: mainFont,
                color: mainCTA,
                fontWeight: FontWeight.bold),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: FlatButton(
              minWidth: 10,
              onPressed: iconPressed,
              child: Icon(
                textFieldIcon,
                color: mainCTA,
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
