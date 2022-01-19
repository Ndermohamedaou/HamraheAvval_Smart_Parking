import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/changeAvatar.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

List byteImg = [];
AvatarModel avatarModel;

class LoadingChangeAvatar extends StatefulWidget {
  @override
  _LoadingChangeAvatarState createState() => _LoadingChangeAvatarState();
}

class _LoadingChangeAvatarState extends State<LoadingChangeAvatar> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () => changeAvatar());
  }

  void changeAvatar() async {
    // Getting user token from LDS
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(byteImg);
    try {
      if (byteImg != null) {
        // Go to Controller/changeAvatar.dart
        String result = await sendingImage(byteImg);
        print("Result of sending $result");
        if (result == "200") {
          // Update Avatar in Provider
          avatarModel.fetchUserAvatar;
          // print(result);
          final uToken = prefs.getString("token");
          ApiAccess api = ApiAccess(uToken);
          Endpoint staffInfoEndpoint = apiEndpointsMap["auth"]["staffInfo"];
          final userDetails = await api.requestHandler(
              staffInfoEndpoint.route, staffInfoEndpoint.method, {});
          final userAvatarChanged = userDetails["avatar"];
          print(userAvatarChanged);
          await prefs.setString("avatar", userAvatarChanged);
          final testAvatar = prefs.getString("avatar");
          // print("LOCAL IMAGE SUBMITED NEW -------> $testAvatar");
          Navigator.pop(context);
          if (testAvatar != "") {
            // Update Avatar in Provider
            avatarModel.fetchUserAvatar;
            showStatusInCaseOfFlush(
                context: context,
                title: "",
                msg: sendSuccessful,
                iconColor: Colors.green,
                icon: Icons.done_outline);
          } else {
            showStatusInCaseOfFlush(
                context: context,
                title: "",
                msg: sendFailed,
                iconColor: Colors.red,
                icon: Icons.remove_done);
          }
        } else {
          Toast.show(sendServerFailed, context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } else {
        showStatusInCaseOfFlush(
            context: context,
            title: "",
            msg: sendDenied,
            iconColor: Colors.red,
            icon: Icons.remove_done);
      }
    } catch (e) {
      print(e);
      showStatusInCaseOfFlush(
          context: context,
          title: "",
          msg: sendDenied,
          iconColor: Colors.red,
          icon: Icons.remove_done);
      Navigator.popUntil(context, ModalRoute.withName("/settings"));
    }
  }

  @override
  Widget build(BuildContext context) {
    byteImg = ModalRoute.of(context).settings.arguments;
    avatarModel = Provider.of<AvatarModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
