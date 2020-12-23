import 'package:flutter/material.dart';
import 'package:securityapp/classes/SavingLocalStorage.dart';
import 'package:securityapp/constFile/texts.dart';
import 'package:toast/toast.dart';

void savingData({uToken, buildingName, uInfo, buildingNameFa, context}) async {
  LocalizationDataStorage lds = LocalizationDataStorage();
  bool lStorageStatus = await lds.savingUInfo(
      uToken: uToken,
      fullName: uInfo['name'],
      email: uInfo['email'],
      personalCode: uInfo['personal_code'],
      naturalCode: uInfo['melli_code'],
      password: uInfo,
      avatar: uInfo['avatar'],
      buildingName: buildingName,
      buildingNameFA: buildingNameFa);

  if (lStorageStatus) {
    Navigator.pushNamed(context, '/');
  } else {
    Toast.show(applicationError, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        textColor: Colors.white);
  }
}
