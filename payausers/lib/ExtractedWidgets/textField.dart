import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

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
    this.keyboardType,
    this.cursorColor,
    this.borderColor,
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
  final TextInputType keyboardType;
  final Color cursorColor;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          readOnly: readOnly,
          keyboardType: keyboardType,
          initialValue: initValue,
          maxLength: maxLen,
          validator: validate,
          obscureText: textInputType,
          textAlign: TextAlign.center,
          cursorColor: cursorColor == null ? mainCTA : cursorColor,
          decoration: InputDecoration(
            counterText: "",
            errorText: errText,
            errorStyle: TextStyle(fontFamily: mainFaFontFamily),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor == null ? mainCTA : borderColor,
                width: 2,
              ),
            ),
            fillColor: borderColor == null ? mainCTA : borderColor,
            labelText: lblText,
            //TODO Fill this section for extract my custom Widget
            labelStyle: TextStyle(
                fontFamily: mainFaFontFamily,
                color: borderColor == null ? mainCTA : borderColor),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            suffixIcon: FlatButton(
              minWidth: 10,
              onPressed: iconPressed,
              child: Icon(
                textFieldIcon,
                color: borderColor == null ? mainCTA : borderColor,
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
