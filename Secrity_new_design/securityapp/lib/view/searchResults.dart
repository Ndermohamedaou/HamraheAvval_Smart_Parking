import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/ApiAccess.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/provider/abuse_warning_model.dart';
import 'package:securityapp/spec/FlowState.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/alert.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:securityapp/widgets/padded_container.dart';
import 'package:securityapp/widgets/sentSituation.dart';
import 'package:securityapp/widgets/textField.dart';
import 'package:sizer/sizer.dart';

int moreImgIndex = 0;

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  String abuseSlot;
  @override
  void initState() {
    moreImgIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    moreImgIndex = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    AbuseWarningModel abuseWarningModel =
        Provider.of<AbuseWarningModel>(context);

    Map statusSpecification = {
      -1: "رزرو شده",
      1: "پر",
      0: "خالی",
    };

    // Getting all data from the server in previous screen api call.
    Map info = ModalRoute.of(context).settings.arguments;

    final personalCode = info["status"]["personal_code"];
    String plateImg =
        info["meta"]["Plate_img"] != null ? info["meta"]["Plate_img"] : "";
    String carImg =
        info["meta"]["car_img"] != null ? info["meta"]["car_img"] : "";
    var slotNum = info["meta"]['slot'];
    var slotStatus = statusSpecification[info["status"]['status']];
    final entryTime = info["meta"]["entry_datetime"];
    final exitTime = info["meta"]["exit_datetime"];
    final staffPhone =
        info["status"]["phone"] == null ? "-" : info["status"]["phone"];
    final name = info["status"]["name"];
    final staffPosition =
        info["status"]["position"] == null ? "-" : info["status"]["position"];

    submitAbuseSlotSelection() async {
      ///
      /// Set new Abuse slot with parkingWarnApi.
      /// Passed slot number and staff personal code
      ApiAccess api = ApiAccess();
      final lStorage = FlutterSecureStorage();
      final userToken = await lStorage.read(key: "uToken");

      // Check TextField empty, and send request
      if (abuseSlot != "") {
        try {
          final result = await api.setNewAbuse(
            token: userToken,
            personalCode: personalCode,
            slotNumber: slotNum,
          );

          if (result == "200")
            rAlert(
              context: context,
              title: reportAbuseSuccessTitle,
              desc: reportAbuseSuccessDesc,
              tAlert: AlertType.success,
              onTapped: () => Navigator.pop(context),
            );

          if (result == "500")
            rAlert(
              context: context,
              title: reportAbuseSuccessTitle,
              desc: reportAbuseFailedDesc,
              tAlert: AlertType.warning,
              onTapped: () => Navigator.pop(context),
            );

          setState(() => abuseSlot = "");
          abuseWarningModel.getAbuseList;
        } catch (e) {
          print("Error in setting new abuse report $e");
          showStatusInCaseOfFlush(
            context: context,
            backgroundColor: mainSectionCTA,
            icon: Icons.close,
            iconColor: Colors.red,
            title: reportAbuseFailedTitle,
            msg: reportAbuseFailedDesc,
          );
        }
      } else {
        showStatusInCaseOfFlush(
          context: context,
          backgroundColor: mainSectionCTA,
          icon: Icons.close,
          iconColor: Colors.red,
          title: reportAbuseTextFiledEmptyTitle,
          msg: reportAbuseTextFiledEmptyDesc,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: resultSearch,
          size: 14.0.sp,
        ),
        centerTitle: true,
        backgroundColor: mainCTA,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 40.0.h,
                child: PageView(
                  children: [
                    Image.memory(
                      base64.decode(carImg),
                      fit: BoxFit.contain,
                    ),
                    Image.memory(
                      base64.decode(plateImg),
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20, top: 20, bottom: 10),
                    child: CustomText(
                      text: fullDetails,
                      size: 14.0.sp,
                      fw: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      PaddedContainer(
                        themeChange: themeChange,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ResultTiles(
                              icon: Icons.layers,
                              iconBg: slotNumberBg,
                              iconColor: Colors.white,
                              title: slotNumberResult,
                              subtitle: slotNum,
                            ),
                            SizedBox(height: 1.25.h),
                            Divider(
                              height: 2,
                              thickness: 1,
                            ),
                            ResultTiles(
                              icon: Icons.where_to_vote_outlined,
                              iconBg: slotStatusBg,
                              iconColor: Colors.white,
                              title: slotStatusResult,
                              subtitle: slotStatus,
                            ),
                            Divider(
                              height: 2,
                              thickness: 1,
                            ),
                            ResultTiles(
                              icon: Icons.supervised_user_circle_sharp,
                              iconBg: Colors.blueAccent,
                              iconColor: Colors.white,
                              title: "نام کاربر",
                              subtitle: name,
                            ),
                            SizedBox(height: 1.25.h),
                            Divider(
                              height: 2,
                              thickness: 1,
                            ),
                            ResultTiles(
                              icon: Icons.person_pin_circle_sharp,
                              iconBg: mainCTA,
                              iconColor: Colors.white,
                              title: "شناسه پرسنلی",
                              subtitle: personalCode,
                            ),
                            Divider(
                              height: 2,
                              thickness: 1,
                            ),
                            ResultTiles(
                              icon: Icons.phone,
                              iconBg: staffPhoneBg,
                              iconColor: Colors.white,
                              title: staffPhoneString,
                              subtitle: staffPhone,
                            ),
                            Divider(
                              height: 2,
                              thickness: 1,
                            ),
                            ResultTiles(
                              icon: Icons.point_of_sale,
                              iconBg: mainSectionCTA,
                              iconColor: Colors.white,
                              title: staffPositionString,
                              subtitle: staffPosition,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0.h),
                      PaddedContainer(
                        themeChange: themeChange,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ResultTiles(
                              icon: Icons.login,
                              iconBg: entrySlotBg,
                              iconColor: Colors.black,
                              title: entryTimeResult,
                              subtitle: entryTime,
                            ),
                            SizedBox(height: 1.25.h),
                            Divider(
                              height: 2,
                              thickness: 1,
                            ),
                            ResultTiles(
                              icon: Icons.logout,
                              iconBg: exitSlotBg,
                              iconColor: Colors.white,
                              title: exitTimeResult,
                              subtitle: exitTime,
                            ),
                          ],
                        ),
                      ),
                      PaddedContainer(
                        themeChange: themeChange,
                        child: Builder(
                          builder: (_) {
                            if (abuseWarningModel.getAbuseListState ==
                                FlowState.Loading)
                              return CircularProgressIndicator();

                            if (abuseWarningModel.getAbuseListState ==
                                FlowState.Error)
                              return CustomText(
                                text: "خطا در دریافت اطلاعات",
                              );

                            if (abuseWarningModel.abuseList.isEmpty)
                              return CustomText(
                                size: 14.0.sp,
                                text: "لیست اخطارها خالی است",
                              );

                            return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: abuseWarningModel.abuseList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return PaddedContainer(
                                  themeChange: themeChange,
                                  child: Column(
                                    children: [
                                      CustomText(
                                        text:
                                            abuseWarningModel.abuseList[index],
                                        size: 12.0.sp,
                                      ),
                                      SizedBox(height: 5),
                                      Divider(
                                        color: Colors.grey,
                                        indent: 3.0,
                                        height: 5.0,
                                        thickness: 0.75,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      personalCode == "-"
                          ? SizedBox()
                          : PaddedContainer(
                              themeChange: themeChange,
                              child: Column(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 15.0),
                                    child: TextFields(
                                      keyType: TextInputType.number,
                                      lblText: reportAbuseTextFieldLabel,
                                      initValue: abuseSlot,
                                      textInputType: false,
                                      maxLen:
                                          textFieldsMaxLength["abuseTextField"],
                                      readOnly: false,
                                      onChangeText: (newSlot) =>
                                          setState(() => abuseSlot = newSlot),
                                    ),
                                  ),
                                  SentSituation(
                                    width: 68.0.w,
                                    send: () => submitAbuseSlotSelection(),
                                    icon: Icons.done_all,
                                    iconColor: Colors.white,
                                    color: mainSectionCTA,
                                    text: reportAbuseText,
                                    textColor: Colors.white,
                                    isLoadingTime: false,
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 2.0.h),
                      SizedBox(height: 5.0.h),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ResultTiles extends StatelessWidget {
  const ResultTiles({
    this.icon,
    this.iconColor,
    this.iconBg,
    this.title,
    this.subtitle,
  });

  final icon;
  final iconColor;
  final iconBg;
  final title;
  final subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          leading: CircleAvatar(
            radius: 7.0.w,
            child: Icon(
              icon,
              color: iconColor,
            ),
            backgroundColor: iconBg,
          ),
          title: CustomText(
            text: title,
            fw: FontWeight.bold,
          ),
          subtitle: CustomText(
            text: subtitle != null ? subtitle : "",
          ),
        ),
      ),
    );
  }
}
