import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/gettingLogin.dart';
import 'package:securityapp/model/ApiAccess.dart';
import 'package:securityapp/model/LDS.dart';
import 'package:securityapp/model/sqfliteLocalCheck.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/bottomBtn.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:sizer/sizer.dart';

String token;

// Controller Class
AuthUsers auth = AuthUsers();
List buildingsList = [];
Map userInfo = {};
// Saving data
LocalizationDataStorage LDS = LocalizationDataStorage();
// Sqflite
SavedSecurity saveSecurity = SavedSecurity();

String dropItemSelected = "";
String _dropDownEnValue;
String _dropDownFaValue;
Timer timer;

ApiAccess api = ApiAccess();

class Buildings extends StatefulWidget {
  @override
  _BuildingsState createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> {
  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      getStaffInfo().then((info) {
        setState(() {
          userInfo = info;
        });
      });
      // print("this is user info Map $userInfo");
    });

    getStaffInfo().then((info) {
      setState(() {
        userInfo = info;
      });
    });

    auth.gettingbuildings(token).then((building) {
      setState(() {
        buildingsList = building;
      });
    });

    _dropDownFaValue = "";
    _dropDownEnValue = "";

    print(buildingsList);
    _dropDownFaValue = "";
    _dropDownEnValue = "";
    super.initState();
  }

  Future<Map> getStaffInfo() async {
    try {
      return await api.gettingUsersInfo(token);
    } catch (e) {
      return {"status": "null"};
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    token = ModalRoute.of(context).settings.arguments;

    void logedOnSatff(uToken) async {
      if (_dropDownEnValue != "" &&
          _dropDownFaValue != "" &&
          userInfo["user_id"] != null) {
        bool savingStatus = await LDS.savingUInfo(
          uToken: uToken,
          userId: userInfo["user_id"],
          email: userInfo["email"],
          fullName: userInfo["name"],
          personalCode: userInfo["personal_code"],
          naturalCode: userInfo["melli_code"],
          avatar: userInfo["avatar"],
          buildingName: _dropDownEnValue,
          buildingNameFA: _dropDownFaValue,
        );
        saveSecurity.createSavedSecurity();

        if (savingStatus)
          Navigator.pushNamed(context, mainoRoute);
        else
          showStatusInCaseOfFlush(
            context: context,
            title: savingProblemTitle,
            msg: savingProblemDsc,
            icon: Icons.data_usage_outlined,
            iconColor: Colors.red,
          );
      } else {
        showStatusInCaseOfFlush(
          context: context,
          title: savingProblemTitle,
          msg: savingProblemDsc,
          icon: Icons.data_usage_outlined,
          iconColor: Colors.red,
        );
      }
    }

    List<DropdownMenuItem<dynamic>> dropItemList = buildingsList.isNotEmpty
        ? buildingsList.map(
            (val) {
              return DropdownMenuItem(
                value: val['name_en'],
                onTap: () {
                  setState(() {
                    _dropDownFaValue = val['name_fa'];
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    CustomText(
                      text: "ساختمان ${val['name_fa']}",
                      size: 12.0.sp,
                      align: TextAlign.center,
                    ),
                    Icon(Icons.home_work_outlined)
                  ],
                ),
              );
            },
          ).toList()
        : [];

    final dropHint = _dropDownFaValue != ""
        ? CustomText(
            text: _dropDownFaValue,
          )
        : CustomText(
            text: "ساختمان خود را انتخاب کنید",
          );

    // print("This is $userInfo");

    final statuser = userInfo['user_id'] != null
        ? CustomText(
            text: "اطلاعات شما دریافت شد",
            color: Colors.green,
            size: 14.0.sp,
            fw: FontWeight.bold,
          )
        : CustomText(
            text: "...در حال دریافت اطلاعات",
            color: Colors.red,
            size: 14.0.sp,
            fw: FontWeight.bold,
          );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(margin: EdgeInsets.all(10), child: statuser),
                ],
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0.h),
                  child: Lottie.asset("assets/animation/buildings.json",
                      width: 100.0.w, repeat: false)),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: DropdownButton(
                    hint: buildingsList.isEmpty
                        ? CustomText(text: "ساختمانی یافت نشد")
                        : dropHint,
                    isExpanded: true,
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.location_city_outlined,
                      color: mainCTA,
                    ),
                    items: dropItemList,
                    onChanged: (val) {
                      setState(
                        () {
                          _dropDownEnValue = val;
                          print(_dropDownEnValue);
                          print(_dropDownFaValue);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        text: submitMsg,
        color: mainCTA,
        onTapped: () => logedOnSatff(token),
      ),
    );
  }
}
