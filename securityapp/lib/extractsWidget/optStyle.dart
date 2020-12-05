import 'package:flutter/material.dart';
import '../constFile/ConstFile.dart';
class OptionsViewer extends StatelessWidget {
  OptionsViewer({
    @required this.text,
    @required this.desc,
    this.avatarIcon,
    this.iconColor,
    this.avatarBgColor,
  });

  final String text;
  final String desc;
  final IconData avatarIcon;
  final Color iconColor;
  final Color avatarBgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: cardStyleColor, borderRadius: BorderRadius.circular(16.0)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
              fontFamily: mainSecurityAppFontFamily,
              color: Colors.white,
              fontSize: titleFontSize,
            ),
          ),
          subtitle: Text(
            desc,
            style: TextStyle(
              fontFamily: mainSecurityAppFontFamily,
              color: Colors.white60,
              fontSize: subTitleFontSize,
            ),
          ),
          leading: CircleAvatar(
            child: Icon(
              avatarIcon,
              color: iconColor,
            ),
            backgroundColor: avatarBgColor,
          ),
        ),
      ),
    );
  }
}
