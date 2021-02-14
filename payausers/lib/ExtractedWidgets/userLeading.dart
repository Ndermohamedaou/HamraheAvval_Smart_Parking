import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class UserLeading extends StatelessWidget {
  const UserLeading(
      {this.imgPressed, this.fullname, this.userPersonalCode, this.avatarImg});

  final Function imgPressed;
  final String fullname;
  final String userPersonalCode;
  final String avatarImg;

  @override
  Widget build(BuildContext context) {
    // print("This is Avatar =>>>>>>> $avatarImg");
    Widget uA = avatarImg.isEmpty
        ? CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.account_circle,
              color: Colors.white,
            ))
        : FlatButton(
            onPressed: imgPressed,
            minWidth: 50,
            height: 50,
            child: CircleAvatar(
              backgroundImage: NetworkImage(avatarImg),
            ),
          );
    return ListTile(
        title: Text(
          fullname,
          style: TextStyle(fontFamily: mainFaFontFamily),
        ),
        subtitle: Text(userPersonalCode,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 12)),
        leading: uA);
  }
}
