import 'package:dots_indicator/dots_indicator.dart';
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    CustomText(
                      text: resultSearch,
                      size: 14.0.sp,
                    ),
                    Icon(Icons.arrow_back)
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                child: PageView(
                  children: [
                    Image.asset("assets/images/searchPlate.png"),
                    Image.asset("assets/images/searchPlate.png"),
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
                        height: 30.0.h,
                        decoration: BoxDecoration(
                          color: themeChange.darkTheme
                              ? darkOptionBg
                              : lightOptionBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            ResultTiles(
                              icon: Icons.layers,
                              iconBg: slotNumberBg,
                              iconColor: Colors.white,
                              title: slotNumberResult,
                              // subtitle: "",
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
                              // subtitle: "",
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        width: 85.0.w,
                        child: CustomText(
                          text: resultSlotTip,
                          size: 11.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5.0.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 30.0.h,
                        decoration: BoxDecoration(
                          color: themeChange.darkTheme
                              ? darkOptionBg
                              : lightOptionBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            ResultTiles(
                              icon: Icons.login,
                              iconBg: entrySlotBg,
                              iconColor: Colors.white,
                              title: entryTimeResult,
                              // subtitle: "",
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
                              // subtitle: "",
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        width: 85.0.w,
                        child: CustomText(
                          text: resultTimeTips,
                          size: 11.0.sp,
                          color: Colors.grey,
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
