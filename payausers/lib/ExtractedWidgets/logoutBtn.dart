import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';


class LogoutBtn extends StatelessWidget {
  const LogoutBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: 15, vertical: 15),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.red.shade800,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(
              20.0, 15.0, 20.0, 15.0),
          // onPressed: () => viewDialog(context),
          child: Text(
            logoutBtnText,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: mainFaFontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
