import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class UserLeading extends StatelessWidget {
  const UserLeading({this.fullname, this.userPersonalCode, this.avatarImg});

  final String fullname;
  final String userPersonalCode;
  final Widget avatarImg;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          fullname,
          style: TextStyle(fontFamily: mainFaFontFamily),
        ),
        subtitle: Text(userPersonalCode,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 12)),
        leading: avatarImg);
  }
}
