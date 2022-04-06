import 'package:flutter/material.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';

class PaddedContainer extends StatelessWidget {
  const PaddedContainer({
    this.themeChange,
    this.child,
  });

  final DarkThemeProvider themeChange;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(5.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeChange.darkTheme ? darkOptionBg : lightOptionBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
