import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dashboardTiles/Tiles.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/gettingLocalData.dart';
import 'package:payausers/Model/streamAPI.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:ionicons/ionicons.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

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

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  LocalDataGetterClass localDataGetterClass = LocalDataGetterClass();

  StreamAPI streamAPI = StreamAPI();
  GridTiles gridTile = GridTiles();
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

    // Create Responsive Grid Container view
    var size = MediaQuery.of(context).size;
    LocalDataGetterClass loadLocalData = LocalDataGetterClass();

    final double containerWidth = size.width > 500 ? 500 : double.infinity;
    final double optionsHolderWidth = size.width > 500 ? 150 : 100;

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
                              fontWeight: FontWeight.bold),
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

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.0.h),
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
                        backgroundImage: avatarModel.avatar != ""
                            ? NetworkImage(avatarModel.avatar)
                            : null,
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        children: [
                          Text(
                            "خوش آمدید",
                            style: TextStyle(
                              fontFamily: mainFaFontFamily,
                              fontSize: 18.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            avatarModel.fullname,
                            style: TextStyle(
                              fontFamily: mainFaFontFamily,
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: streamAPI.getUserInfoInReal(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(children: [
                        Icon(Icons.star, color: Colors.yellow, size: 40.0),
                        Text(
                          snapshot.data["score"].toString(),
                          style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 18,
                          ),
                        ),
                      ]);
                    } else {
                      return Column(children: [
                        Icon(Icons.star, color: Colors.yellow, size: 40.0),
                        Text(
                          "-",
                          style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 18,
                          ),
                        ),
                      ]);
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 2.0.h),
          FutureBuilder(
            future: loadLocalData.getStaffInfoFromLocal(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return QRHolder(
                  qrValue: snapshot.data['userId'],
                );
              } else if (snapshot.hasError) {
                return QRHolder(
                  qrValue: "صبر کنید یا اتصال خود را به اینترنت بررسی کنید",
                );
              } else {
                return QRHolder(
                  qrValue: "صبر کنید یا اتصال خود را به اینترنت بررسی کنید",
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            width: containerWidth,
            height: optionsHolderWidth,
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: themeChange.darkTheme ? darkBar : Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Builder(
                  builder: (_) {
                    if (trafficsModel.trafficsState == FlowState.Error) {
                      return SecondOptions(
                        icon: Ionicons.bar_chart_outline,
                        title: "ترددها",
                        onPressed: () {
                          return showStatusInCaseOfFlush(
                              context: context,
                              title:
                                  "نیم صفحه مشاهده وضعیت با شکست رو به رو شد",
                              msg:
                                  "نیم صفحه قادر به باز شدن نیست زیرا باید اطلاعات را از سرویس دهنده دریافت کند، مشکل در برقراری ارتباط",
                              iconColor: Colors.orange,
                              icon: Icons.warning);
                        },
                      );
                    }
                    return SecondOptions(
                      icon: Ionicons.bar_chart_outline,
                      title: "ترددها",
                      onPressed: () => openOptionsData(
                          title: "تعداد تردد های شما",
                          data: trafficsModel.traffics.length,
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
                      icon: Ionicons.ticket_outline,
                      title: "رزروها",
                      onPressed: () => openOptionsData(
                        title: "تعداد رزروهای شما",
                        data: reservesModel.reserves.length,
                        onPressedNavigationButton: () {
                          return showStatusInCaseOfFlush(
                              context: context,
                              title:
                                  "نیم صفحه مشاهده وضعیت با شکست رو به رو شد",
                              msg:
                                  "نیم صفحه قادر به باز شدن نیست زیرا باید اطلاعات را از سرویس دهنده دریافت کند، مشکل در برقراری ارتباط",
                              iconColor: Colors.orange,
                              icon: Icons.warning);
                        },
                      ),
                    );
                  }
                  return SecondOptions(
                    icon: Ionicons.ticket_outline,
                    title: "رزروها",
                    onPressed: () => openOptionsData(
                        title: "تعداد کل رزروهای شما",
                        data: reservesModel.reserves.length,
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
                      icon: Ionicons.file_tray_full_outline,
                      title: "پلاک ها",
                      onPressed: () => openOptionsData(
                        title: "تعداد پلاک های ثبت شده در سامانه",
                        data: plateModel.plates.length,
                        onPressedNavigationButton: () {
                          return showStatusInCaseOfFlush(
                              context: context,
                              title:
                                  "نیم صفحه مشاهده وضعیت با شکست رو به رو شد",
                              msg:
                                  "نیم صفحه قادر به باز شدن نیست زیرا باید اطلاعات را از سرویس دهنده دریافت کند، مشکل در برقراری ارتباط",
                              iconColor: Colors.orange,
                              icon: Icons.warning);
                        },
                      ),
                    );
                  }
                  return SecondOptions(
                    icon: Ionicons.file_tray_full_outline,
                    title: "پلاک ها",
                    onPressed: () => openOptionsData(
                      title: "تعداد پلاک های شما",
                      data: plateModel.plates.length,
                      hasAction: true,
                      onPressedNavigationButton: () {
                        widget.navigateToPlatesTab();
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
                StreamBuilder(
                  stream: streamAPI.getUserInfoInReal(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      try {
                        return SecondOptions(
                          icon: Ionicons.location_outline,
                          title: "جایگاه",
                          onPressed: () => openOptionsData(
                            title: "جایگاه فعلی وسیله نقلیه شما",
                            data: "${snapshot.data["location"]}",
                            onPressedNavigationButton: () {
                              widget.navigateToPlatesTab();
                              Navigator.pop(context);
                            },
                          ),
                        );
                      } catch (e) {
                        return SecondOptions(
                          icon: Ionicons.location_outline,
                          title: "جایگاه",
                          onPressed: () => openOptionsData(
                            title: "جایگاه فعلی وسیله نقلیه شما",
                            data: "در حال لود شدن",
                          ),
                        );
                      }
                    } else {
                      return SecondOptions(
                        icon: Ionicons.location_outline,
                        title: "جایگاه",
                        onPressed: () => openOptionsData(
                          title: "جایگاه فعلی وسیله نقلیه شما",
                          data: "در حال لود شدن",
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          VerticalSlide(imgSrc: "assets/images/slider-1.jpg"),
          VerticalSlide(imgSrc: "assets/images/slider-2.jpg"),
          VerticalSlide(imgSrc: "assets/images/slider-3.jpg")
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class QRHolder extends StatelessWidget {
  const QRHolder({this.qrValue});

  final String qrValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 30.0.h,
          height: 30.0.h,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: themeChange.darkTheme ? darkBar : Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(color: mainCTA, width: 15),
            boxShadow: [
              BoxShadow(
                color: mainCTA.withOpacity(0.6),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(2, 3),
              ),
            ],
          ),
          child: QrImage(
            data: qrValue,
            version: QrVersions.auto,
            padding: EdgeInsets.all(10),
            foregroundColor:
                themeChange.darkTheme ? Colors.white : HexColor("#000000"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "جهت استفاده از شناسه کاربری خود، شناسه کیو آر بالا را اسکن کنید",
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontWeight: FontWeight.normal,
              fontSize: 13.0.sp,
              color:
                  themeChange.darkTheme ? Colors.white : Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class VerticalSlide extends StatelessWidget {
  const VerticalSlide({this.imgSrc});

  final String imgSrc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double containerWidth = size.width > 500 ? 500 : double.infinity;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: containerWidth,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(imgSrc),
          fit: BoxFit.cover,
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
          color: themeChange.darkTheme ? mainBgColorDark : HexColor("#EEF3F6"),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: mainCTA,
              size: 15.0.sp,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 13.0.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
