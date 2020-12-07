import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  TextFields({this.lblText, this.onChangeText, this.textFieldIcon});

  final String lblText;
  final Function onChangeText;
  final IconData textFieldIcon;


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          textAlign: TextAlign.center,
          cursorColor: Colors.blue[900],
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[900], width: 2),
            ),
            fillColor: Colors.blue[900],
            labelText: lblText,
            //TODO Fill this section for extract my custom Widget
            labelStyle: TextStyle(),
            border: OutlineInputBorder(),
            suffixIcon: Icon(
              textFieldIcon,
            ),
          ),
          onChanged: onChangeText,
        ),
      ),
    );
  }
}
