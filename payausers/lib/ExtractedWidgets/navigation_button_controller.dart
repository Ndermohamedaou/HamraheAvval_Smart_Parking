import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({this.themeChange, this.icon, this.onClick});

  final DarkThemeProvider themeChange;
  final IconData icon;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: themeChange.darkTheme ? darkBar : lightBar,
          border: Border.all(
            color: themeChange.darkTheme
                ? Colors.grey.shade700
                : Colors.grey.shade300,
            width: 1.4,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: themeChange.darkTheme
              ? Colors.grey.shade200
              : Colors.grey.shade700,
        ),
      ),
    );
  }
}
