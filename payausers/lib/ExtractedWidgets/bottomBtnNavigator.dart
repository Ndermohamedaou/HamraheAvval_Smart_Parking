import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class BottomButton extends StatelessWidget {
  const BottomButton(
      {this.ontapped, this.text, this.hasCondition = true, this.color});

  final Function ontapped;
  final String text;
  final bool hasCondition;
  final color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(8.0),
        color: color ?? mainCTA,
        child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              hasCondition ? ontapped() : null;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !hasCondition
                    ? CupertinoActivityIndicator()
                    : Text(
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
