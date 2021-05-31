import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import '../../Classes/streamAPI.dart';

class Settings extends StatefulWidget {
  const Settings();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final targetPlatform =
        Theme.of(context).platform == TargetPlatform.iOS ? "iOS" : "Android";

    void logoutSection() {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        // backgroundColor: ,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_circle_down_sharp,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                maxRadius: 30,
                backgroundColor: Colors.orange,
                child: Icon(
                  Icons.warning_amber_sharp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.0.h),
              Text(
                "خروج از حساب",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 16.0.sp,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.0.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  logoutMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: mainFaFontFamily, fontSize: 14.0.sp),
                ),
              ),
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  MaterialButton(
                    color: Colors.red,
                    minWidth: 45.0.w,
                    onPressed: () async {
                      FlutterSecureStorage lds = FlutterSecureStorage();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      // SystemChannels.platform
                      //     .invokeMethod('SystemNavigator.pop');
                      await lds.deleteAll();
                      prefs.setInt("user_plate_notif_number", 0);
                      prefs.clear();
                      Navigator.popUntil(context, ModalRoute.withName("/"));
                      // exit(0);
                    },
                    child: Text(
                      "بلی",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 14.0.sp,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10),
                  MaterialButton(
                    minWidth: 45.0.w,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "خیر",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 14.0.sp,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.0.h),
            ],
          ),
        ),
      );
    }

    void firstStepToSetBiometric() {
      CoolAlert.show(
        context: context,
        backgroundColor: mainCTA,
        type: CoolAlertType.info,
        title: "!لازم است بدانید",
        text: biometricInfoToCheck,
        confirmBtnTextStyle: TextStyle(fontFamily: mainFaFontFamily),
        confirmBtnColor: mainCTA,
        confirmBtnText: "مرحله بعدی",
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, "/setBiometric");
        },
      );
    }

    // Providers
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final avatarModel = Provider.of<AvatarModel>(context);

    final themeIconLeading = themeChange.darkTheme
        ? Icon(Icons.brightness_5, color: Colors.yellow)
        : Icon(Icons.bedtime, color: Colors.blue);

    StreamAPI streamAPI = StreamAPI();

    Widget sliverAppBar({name, avatar}) => SliverAppBar(
          expandedHeight: 70.0.w,
          floating: false,
          pinned: true,
          backgroundColor: mainCTA,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              name,
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 15),
            ),
            background: Image(
              image: NetworkImage(avatar),
              fit: BoxFit.cover,
            ),
          ),
          leading: Container(
            margin: EdgeInsets.all(10),
            child: ClipOval(
              child: Material(
                color: mainCTA, // button color
                child: InkWell(
                  splashColor: mainSectionCTA, // inkwell color
                  child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      )),
                  onTap: () => Navigator.pushNamed(context, "/settings"),
                ),
              ),
            ),
          ),
        );

    return CustomScrollView(
      slivers: [
        Builder(
          builder: (_) {
            if (avatarModel.avatarState == FlowState.Loading)
              return sliverAppBar(
                  name: "",
                  avatar:
                      "https://style.anu.edu.au/_anu/4/images/placeholders/person.png");
            return sliverAppBar(
                name: avatarModel.fullname, avatar: avatarModel.avatar);
          },
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: themeChange.darkTheme ? darkBar : lightBar,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: ListTileSwitch(
                                leading: themeIconLeading,
                                value: themeChange.darkTheme,
                                onChanged: (bool state) {
                                  themeChange.darkTheme = state;
                                },
                                title: Text(
                                  themeModeSwitch,
                                  style: TextStyle(
                                      fontFamily: mainFaFontFamily,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: .25,
                            indent: 20,
                            height: 0,
                          ),
                          Container(
                            color: themeChange.darkTheme ? darkBar : lightBar,
                            child: FlatButton(
                              onPressed: () => firstStepToSetBiometric(),
                              child: ListTile(
                                title: Text(
                                  "تنظیم بایومتریک",
                                  style: TextStyle(
                                      fontFamily: mainFaFontFamily,
                                      fontSize: 15),
                                ),
                                leading: Icon(
                                  Icons.lock_outline,
                                  color: Colors.orangeAccent,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                            thickness: .25,
                            indent: 20,
                            height: 0,
                          ),
                          Container(
                              width: double.infinity,
                              height: 55,
                              color: themeChange.darkTheme ? darkBar : lightBar,
                              child: FlatButton(
                                onPressed: () => logoutSection(),
                                child: ListTile(
                                  title: Text(
                                    "خروج از حساب کاربری خود",
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        fontSize: 15),
                                  ),
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "توسعه داده شده توسط ارتباطات پایا نسخه ${targetPlatform}",
                              style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                fontSize: 10.0.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              childCount: 1),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
