import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dashboardTiles.dart';
import 'package:payausers/ExtractedWidgets/userLeading.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    this.openUserDashSettings,
    this.fullnameMeme,
    this.userPersonalCodeMeme,
    this.avatarMeme,
    this.temporarLogo,
    this.userQRCode,
    this.section,
    this.role,
    this.userPlateNumber,
    this.userTrafficNumber,
    this.userReserveNumber,
    this.lastLogin,
  });
  final Function openUserDashSettings;
  final String fullnameMeme;
  final String userPersonalCodeMeme;
  final String avatarMeme;
  final String userQRCode;
  final String temporarLogo;
  final String section;
  final String role;
  final String userPlateNumber;
  final String userTrafficNumber;
  final String userReserveNumber;
  final String lastLogin;

  @override
  Widget build(BuildContext context) {
    // Create Responsive Grid Container view
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 4;
    final double itemWidth = size.width;
    // Check if device be in portrait or Landscape
    final double widthSizedResponse = size.width >= 410 && size.width < 600
        ? (itemWidth / itemHeight) / 3
        : size.width >= 390 && size.width <= 409
            ? (itemWidth / itemHeight) / 2.4
            : size.width <= 380
                ? (itemWidth / itemHeight) / 3.2
                : size.width >= 700 && size.width < 1000
                    ? (itemWidth / itemHeight) / 6
                    : (itemWidth / itemHeight) / 5;

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          // User Summery details on dashboard screen
          Directionality(
            textDirection: TextDirection.rtl,
            child: UserLeading(
              imgPressed: openUserDashSettings,
              fullname: fullnameMeme,
              userPersonalCode: userPersonalCodeMeme,
              avatarImg: avatarMeme,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          UserCard(
            qrCodeString: qrUserCode,
            fullname: fullnameMeme,
            persCode: userPersonalCodeMeme,
            lastVisit: lastLogin,
          ),

          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: widthSizedResponse,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DashboardTiles(
                  tileColor: "#FEEBE7",
                  icon: Icons.directions_car,
                  iconColor: HexColor("#AC292E"),
                  text: qty,
                  subText: transactionsText,
                  subSubText: untilTodayText,
                  subSubTextColor: HexColor("#AC292E"),
                  lenOfStuff: userTrafficNumber,
                ),
                DashboardTiles(
                  tileColor: "#EDE5FC",
                  icon: Icons.book,
                  iconColor: HexColor("#6C2BDF"),
                  text: qty,
                  subText: allReserveText,
                  subSubText: untilTodayText,
                  subSubTextColor: HexColor("#6C2BDF"),
                  lenOfStuff: userReserveNumber,
                ),
                DashboardTiles(
                  tileColor: "#E0FFED",
                  icon: Icons.account_balance,
                  iconColor: HexColor('#66D29F'),
                  text: "موقعیت",
                  subText: "جایگاه",
                  subSubText: role,
                  subSubTextColor: HexColor("#69D8A0"),
                  lenOfStuff: section,
                ),
                DashboardTiles(
                  tileColor: "#E2EEFE",
                  icon: Icons.layers_sharp,
                  iconColor: HexColor("#216DCD"),
                  text: qty,
                  subText: yourPlateText,
                  subSubText: inSystemText,
                  subSubTextColor: HexColor("#216DCD"),
                  lenOfStuff: userPlateNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    this.qrCodeString,
    this.fullname,
    this.persCode,
    this.lastVisit,
  });

  final String qrCodeString;
  final String fullname;
  final String persCode;
  final lastVisit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95.0.w,
      height: 35.0.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [mainCTA, mainSectionCTA]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(right: 10.0.w, bottom: 2.0.h),
                width: 40.0.w,
                height: 7.0.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(4.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.rtl,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/images/cardLogo.png",
                        width: 10.0.w,
                        height: 10.0.w,
                      ),
                    ),
                    SizedBox(width: 4.0.w),
                    Text(
                      "پارکینگ من",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: mainCardColor,
                          fontSize: 12.0.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // QRCode Section
                Container(
                  alignment: Alignment.center,
                  width: 12.0.h,
                  height: 12.0.h,
                  decoration: BoxDecoration(
                      color: HexColor("#EBEAFA"),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: QrImage(
                    data: qrCodeString,
                    version: QrVersions.auto,
                    padding: EdgeInsets.all(10),
                    foregroundColor: HexColor("#000000"),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        fullname.length > 15
                            ? "${fullname.substring(0, 15)}..."
                            : fullname,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: mainCardColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0.sp,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        persCode,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: persCodeColor,
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 5.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        "اخرین \n ورود",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: lastVisitColor,
                          fontSize: 12.0.sp,
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        lastVisit,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          color: Colors.black,
                          fontSize: 14.0.sp,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
