import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

int moreImgIndex = 0;

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
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
    Map info = ModalRoute.of(context).settings.arguments;
    String plateImg = info["Plate_img"] != null ? info["Plate_img"] : "";
    String carImg = info["car_img"] != null ? info["car_img"] : "";
    var slotNum = info['slot'];
    var slotStatus = info['status'] == -1
        ? "رزور شده"
        : info['slot'] == 1
            ? "پر"
            : "خالی";
    final entryTime = info["entry_datetime"];
    final exitTime = info["exit_datetime"];
    final personalCode = info["personal_code"];
    final name = info["name"];

    // print(info);
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
                      base64.decode(plateImg),
                      fit: BoxFit.contain,
                    ),
                    Image.memory(
                      base64.decode(carImg),
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
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 55.0.h,
                        decoration: BoxDecoration(
                          color: themeChange.darkTheme
                              ? darkOptionBg
                              : lightOptionBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 28.0.h,
                        decoration: BoxDecoration(
                          color: themeChange.darkTheme
                              ? darkOptionBg
                              : lightOptionBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
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
