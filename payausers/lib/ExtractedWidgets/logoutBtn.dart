import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:payausers/Screens/maino.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void logout() async {
      FlutterSecureStorage lds = FlutterSecureStorage();
      // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      await lds.deleteAll();
      Toast.show("مجددا به حساب خود وارد شوید", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
      Navigator.pushNamed(context, '/splashScreen');
      exit(0);
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.red.shade800,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () => logout(),
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
