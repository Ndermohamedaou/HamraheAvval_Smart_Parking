import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class UserLeading extends StatelessWidget {
  const UserLeading({this.imgPressed, this.avatarImg});

  final Function imgPressed;
  final String avatarImg;

  @override
  Widget build(BuildContext context) {
    // print("This is Avatar =>>>>>>> $avatarImg");
    Widget uA = avatarImg.isEmpty
        ? CircleAvatar(
            backgroundColor: mainCTA,
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
    return CircleAvatar(child: uA);
  }
}
