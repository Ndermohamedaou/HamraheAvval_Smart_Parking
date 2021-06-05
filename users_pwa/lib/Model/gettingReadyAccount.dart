// If user is not new
import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/SavingData.dart';
import 'package:toast/toast.dart';

class GettingReadyAccount {
  void getUserAccInfo(token, context) async {
    ApiAccess api = ApiAccess();
    SavingData savingData = SavingData();
    try {
      Map userInfo = await api.getStaffInfo(token: token);
      // Convert plate list from api to lStorage
      // final List userPlates = userInfo["plates"] as List;

      bool result = await savingData.LDS(
        token: token,
        user_id: userInfo["user_id"],
        email: userInfo["email"],
        name: userInfo["name"],
        role: userInfo['role'],
        avatar: userInfo["avatar"],
        melli_code: userInfo['melli_code'],
        personal_code: userInfo['personal_code'],
        section: userInfo["section"],
        lastLogin: userInfo["last_login"],
      );

      if (result) {
        Navigator.pushNamed(context, "/loginCheckout");
      } else {
        Toast.show("Your info can not saved", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    } catch (e) {
      Toast.show("Error in Get User info!", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
    }
  }
}
