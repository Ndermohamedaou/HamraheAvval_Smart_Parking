import 'dart:async';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/staffInfo_model.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  final openUserDashSettings;
  final navigateToTrafficsTab;
  final navigateToReservesTab;
  final navigateToPlatesTab;
  const Dashboard({
    this.openUserDashSettings,
    this.navigateToTrafficsTab,
    this.navigateToReservesTab,
    this.navigateToPlatesTab,
  });

  @override
  _DashboardState createState() => _DashboardState();
}

dynamic themeChange;
StaffInfoModel staffInfoModel;
Timer _onRefreshStaffInfo;

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  @override
  void initState() {
    _onRefreshStaffInfo = Timer.periodic(Duration(seconds: 30), (timer) {
      staffInfoModel.fetchStaffInfo;
    });

    super.initState();
  }

  @override
  void dispose() {
    _onRefreshStaffInfo.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Providers
    themeChange = Provider.of<DarkThemeProvider>(context);
    // Getting reserves data from provider model
    final reservesModel = Provider.of<ReservesModel>(context);
    // Getting Traffics data from provider model
    final trafficsModel = Provider.of<TrafficsModel>(context);
    // Getting plates data from provider model
    final plateModel = Provider.of<PlatesModel>(context);
    // Getting user Avatar data from provider model
    final avatarModel = Provider.of<AvatarModel>(context);
    // Getting Score and car location of user
    staffInfoModel = Provider.of<StaffInfoModel>(context);

    LogLoading logLoading = LogLoading();

    String finalCarSlotLocation() {
      /// Checking location of car slot from the API data.
      try {
        String userCarLocation =
            staffInfoModel.staffInfo["location"]["slot"].toString();
        List carLocationSplitString = userCarLocation.split("-");
        return "${carLocationSplitString[0]} - ${carLocationSplitString[1]}";
      } catch (e) {
        return staffInfoModel.staffInfo["location"];
      }
    }

    // Create Responsive Grid Container view
    var size = MediaQuery.of(context).size;
    final double containerWidth = size.width > 500 ? 500 : double.infinity;

    void openOptionsData(
        {data = "0",
        title,
        hasAction = false,
        onPressedNavigationButton: Function}) {
      Widget actionButton = hasAction
          ? Container(
              width: 200,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(8.0),
                color: mainSectionCTA,
                child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: onPressedNavigationButton,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "مشاهده جزئیات",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: loginBtnTxtColor,
                              fontFamily: mainFaFontFamily,
                              fontSize: btnSized,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    )),
              ),
            )
          : SizedBox();
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5.0.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 2.0.h),
              Text(
                "$data",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 22,
                  color: mainCTA,
                ),
              ),
              actionButton,
              SizedBox(height: 5.0.h),
            ],
          ),
        ),
      );
    }

    void launchURL(String urlString) async {
      /// Launch specific URL in browser.
      await launch(
        urlString,
        forceSafariVC: true,
      );
    }

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dashboardBg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 3.0.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.rtl,
                      children: [
                        GestureDetector(
                          onTap: widget.openUserDashSettings,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(avatarModel.avatar ?? "")),
                              SizedBox(width: 10.0),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      avatarModel.fullname,
                                      style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    Text(
                                      staffInfoModel
                                              .staffInfo["parking_type_fa"] ??
                                          welcomeTitle,
                                      style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: themeChange.darkTheme ? darkBar : lightBar,
                          borderRadius: BorderRadius.circular(8.0),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color:
                                    themeChange.darkTheme ? darkBar : lightBar,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                textDirection: TextDirection.rtl,
                                children: [
                                  Image.asset("assets/images/myScore.png",
                                      width: 30),
                                  Builder(
                                    builder: (_) {
                                      if (staffInfoModel.staffLoadState ==
                                          FlowState.Loading) {
                                        return Text(
                                          "انتظار",
                                          style: TextStyle(
                                            fontFamily: mainFaFontFamily,
                                            color: themeChange.darkTheme
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 18.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                      if (staffInfoModel.staffLoadState ==
                                          FlowState.Error) {
                                        return Text(
                                          "خطا",
                                          style: TextStyle(
                                            fontFamily: mainFaFontFamily,
                                            color: Colors.red,
                                            fontSize: 18.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                      return staffInfoModel
                                                  .staffInfo["score"] ==
                                              null
                                          ? Text("-")
                                          : Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "امتیاز",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            mainFaFontFamily,
                                                        fontSize: 18,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                    SizedBox(width: 3.0),
                                                    Text(
                                                      "${staffInfoModel.staffInfo["score"]}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            mainFaFontFamily,
                                                        fontSize: 18,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.0.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    width: containerWidth,
                    padding: EdgeInsets.all(5.0),
                    child: GridView.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Builder(
                          builder: (_) {
                            if (trafficsModel.trafficsState ==
                                FlowState.Error) {
                              return SecondOptions(
                                icon: "myTraffic.png",
                                title: "ترددها",
                                onPressed: () {
                                  return showStatusInCaseOfFlush(
                                      context: context,
                                      title:
                                          "نیم صفحه مشاهده وضعیت با شکست رو به رو شد",
                                      msg:
                                          "نیم صفحه قادر به باز شدن نیست زیرا باید اطلاعات را از سرویس دهنده دریافت کند، مشکل در برقراری ارتباط",
                                      iconColor: Colors.white,
                                      icon: Icons.warning);
                                },
                              );
                            }
                            return SecondOptions(
                              icon: "myTraffic.png",
                              title: "ترددها",
                              onPressed: () => openOptionsData(
                                  title: "تعداد تردد های شما",
                                  data: trafficsModel.traffics.length ??
                                      dataLoadingTextString,
                                  hasAction: true,
                                  onPressedNavigationButton: () {
                                    widget.navigateToTrafficsTab();
                                    Navigator.pop(context);
                                  }),
                            );
                          },
                        ),
                        Builder(builder: (_) {
                          if (reservesModel.reserveState == FlowState.Error) {
                            return SecondOptions(
                              icon: "myReserveList.png",
                              title: "رزروها",
                              onPressed: () => openOptionsData(
                                title: "تعداد رزروهای باقی مانده هفته",
                                data:
                                    reservesModel.reserves["reserves"].length ??
                                        dataLoadingTextString,
                                onPressedNavigationButton: () {
                                  return showStatusInCaseOfFlush(
                                      context: context,
                                      title:
                                          "نیم صفحه مشاهده وضعیت با شکست رو به رو شد",
                                      msg:
                                          "نیم صفحه قادر به باز شدن نیست زیرا باید اطلاعات را از سرویس دهنده دریافت کند، مشکل در برقراری ارتباط",
                                      iconColor: Colors.white,
                                      icon: Icons.warning);
                                },
                              ),
                            );
                          }
                          return SecondOptions(
                            icon: "myReserveList.png",
                            title: "رزروها",
                            onPressed: () => openOptionsData(
                                title: "تعداد رزروهای باقی مانده هفته",
                                data: staffInfoModel.staffInfo["reserves"] ??
                                    dataLoadingTextString,
                                hasAction: true,
                                onPressedNavigationButton: () {
                                  widget.navigateToReservesTab();
                                  Navigator.pop(context);
                                }),
                          );
                        }),
                        Builder(builder: (_) {
                          if (plateModel.platesState == FlowState.Error) {
                            return SecondOptions(
                              icon: "myPlate.png",
                              title: "پلاک ها",
                              onPressed: () => openOptionsData(
                                title: "تعداد پلاک های ثبت شده در سامانه",
                                data: plateModel.plates.length ??
                                    dataLoadingTextString,
                                onPressedNavigationButton: () {
                                  return showStatusInCaseOfFlush(
                                      context: context,
                                      title:
                                          "نیم صفحه مشاهده وضعیت با شکست رو به رو شد",
                                      msg:
                                          "نیم صفحه قادر به باز شدن نیست زیرا باید اطلاعات را از سرویس دهنده دریافت کند، مشکل در برقراری ارتباط",
                                      iconColor: Colors.white,
                                      icon: Icons.warning);
                                },
                              ),
                            );
                          }
                          return SecondOptions(
                            icon: "myPlate.png",
                            title: "پلاک ها",
                            onPressed: () => openOptionsData(
                              title: "تعداد پلاک های شما",
                              data: plateModel.plates.length ??
                                  dataLoadingTextString,
                              hasAction: true,
                              onPressedNavigationButton: () {
                                widget.navigateToPlatesTab();
                                Navigator.pop(context);
                              },
                            ),
                          );
                        }),
                        Builder(builder: (_) {
                          if (staffInfoModel.staffLoadState ==
                              FlowState.Error) {
                            return SecondOptions(
                              icon: "myLastLocation.png",
                              title: "جایگاه",
                              onPressed: () => openOptionsData(
                                title: "عدم اتصال به شبکه",
                                data:
                                    "لطفا ارتباط خود را با شبکه اینترنت بررسی کنید",
                              ),
                            );
                          }
                          try {
                            return staffInfoModel.staffInfo["location"] == null
                                ? SecondOptions(
                                    icon: "myLastLocation.png",
                                    title: "جایگاه",
                                    onPressed: () => openOptionsData(
                                      title: "جایگاه فعلی وسیله نقلیه شما",
                                      data: dataLoadingTextString ??
                                          dataLoadingTextString,
                                    ),
                                  )
                                : SecondOptions(
                                    icon: "myLastLocation.png",
                                    title: "جایگاه",
                                    onPressed: () => openOptionsData(
                                      title: "جایگاه فعلی وسیله نقلیه شما",
                                      data: finalCarSlotLocation(),
                                      onPressedNavigationButton: () {
                                        widget.navigateToPlatesTab();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                          } catch (e) {
                            return SecondOptions(
                              icon: "myLastLocation.png",
                              title: "جایگاه",
                              onPressed: () => openOptionsData(
                                title: "جایگاه فعلی وسیله نقلیه شما",
                                data: dataLoadingTextString,
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: themeChange.darkTheme
                          ? mainBgColorDark
                          : mainBgColorLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Builder(builder: (BuildContext context) {
                      if (staffInfoModel.staffLoadState == FlowState.Loading)
                        return logLoading.loading;

                      if (staffInfoModel.staffLoadState == FlowState.Error)
                        return logLoading.internetProblem;

                      List banners = staffInfoModel.staffInfo["banners"];

                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: banners.length,
                        itemBuilder: (BuildContext context, int index) {
                          return VerticalSlide(
                            imgSrc: banners[index]["img_url"],
                            openURL: () => launchURL(banners[index]["web_url"]),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class VerticalSlide extends StatelessWidget {
  const VerticalSlide({this.imgSrc, this.openURL});

  final String imgSrc;
  final Function openURL;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double containerWidth = size.width > 500 ? 500 : double.infinity;

    return GestureDetector(
      onTap: openURL,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: containerWidth,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(imgSrc),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SecondOptions extends StatelessWidget {
  const SecondOptions({
    this.title,
    this.icon,
    this.onPressed,
  });

  final String title;
  final icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: themeChange.darkTheme ? mainBgColorDark : mainBgColorLight,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/images/$icon", width: 30.0, height: 30.0),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
