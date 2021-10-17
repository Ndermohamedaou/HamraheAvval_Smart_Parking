import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dashboardTiles/Tiles.dart';
import 'package:payausers/ExtractedWidgets/userCard.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/Screens/familyPage.dart';
import 'package:payausers/controller/gettingLocalData.dart';
import 'package:payausers/Model/streamAPI.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/providers/traffics_model.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    this.openUserDashSettings,
  });
  final Function openUserDashSettings;

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
    final double itemHeight = (size.height - kToolbarHeight) / 4;
    final double itemWidth = size.width;
    LocalDataGetterClass loadLocalData = LocalDataGetterClass();

    final double containerWidth = size.width > 500 ? 500 : double.infinity;
    final double optionsHolderWidth = size.width > 500 ? 150 : 100;

    // Check if device be in portrait or Landscape
    final double widthSizedResponse = size.width >= 410 && size.width < 600
        ? (itemWidth / itemHeight) / 3
        : size.width >= 390 && size.width <= 409
            ? (itemWidth / itemHeight) / 2.4
            : size.width <= 380
                ? (itemWidth / itemHeight) / 3.2
                : size.width >= 700 && size.width < 1000
                    ? (itemWidth / itemHeight) / 6
                    : (itemWidth / itemHeight) / 0.65.w;

    Widget userLeadingCircleAvatar(avatar, fullname) => GestureDetector(
          onTap: widget.openUserDashSettings,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: mainCTA,
                  backgroundImage: avatar,
                ),
                title: Text(
                  "خوش آمدید",
                  style: TextStyle(fontFamily: mainFaFontFamily),
                ),
                subtitle: Text(
                  fullname,
                  style: TextStyle(fontFamily: mainFaFontFamily),
                ),
              ),
            ),
          ),
        );

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.0.h),
          Builder(
            builder: (_) {
              // if (avatarModel.avatarState == FlowState.Loading) {
              //   return userLeadingCircleAvatar(
              //       Icon(Icons.airline_seat_individual_suite_sharp));
              // }
              return userLeadingCircleAvatar(
                  avatarModel.avatar != ""
                      ? NetworkImage(avatarModel.avatar)
                      : null,
                  avatarModel.fullname);
            },
          ),
          SizedBox(height: 2.0.h),
          FutureBuilder(
            future: loadLocalData.getStaffInfoFromLocal(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
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
                        data: snapshot.data['userId'],
                        version: QrVersions.auto,
                        padding: EdgeInsets.all(10),
                        foregroundColor: themeChange.darkTheme
                            ? Colors.white
                            : HexColor("#000000"),
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
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return null;
              } else {
                return null;
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
                SecondOptions(
                  icon: Ionicons.bar_chart_outline,
                  title: "ترددها",
                  onPressed: () {},
                ),
                SecondOptions(
                  icon: Ionicons.ticket_outline,
                  title: "رزروها",
                  onPressed: () {},
                ),
                SecondOptions(
                  icon: Ionicons.file_tray_full_outline,
                  title: "پلاک ها",
                  onPressed: () {},
                ),
                SecondOptions(
                  icon: Ionicons.location_outline,
                  title: "جایگاه",
                  onPressed: () {},
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
