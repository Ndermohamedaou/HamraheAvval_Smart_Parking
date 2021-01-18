import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({@required this.ontapped, this.text});

  final Function ontapped;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(8.0),
        color: loginBtnColor,
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: ontapped,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: loginBtnTxtColor,
                      fontFamily: mainFaFontFamily,
                      fontSize: btnSized,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                )
              ],
            )),
      ),
    );
  }
}
