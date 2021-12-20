import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

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

    ApiAccess api = ApiAccess();

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
                      // Getting token from shared preferences and cleaning LocalStorage as logout user
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      // Send token for logout from the system if response was 200
                      if (await api.logout(token: prefs.getString("token")) ==
                          "200") {
                        prefs.clear();
                        Navigator.popUntil(context, ModalRoute.withName("/"));
                      }
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

    // Providers
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final avatarModel = Provider.of<AvatarModel>(context);

    final themeIconLeading = themeChange.darkTheme
        ? Icon(Icons.brightness_5, color: Colors.yellow)
        : Icon(Icons.bedtime, color: Colors.blue);

    Widget sliverAppBar({name, avatar}) => SliverAppBar(
          expandedHeight: 70.0.w,
          floating: false,
          pinned: true,
          backgroundColor: mainCTA,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              name,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            ),
            background: Image(
              image: NetworkImage(avatar),
              fit: BoxFit.cover,
            ),
          ),
          leading: SizedBox(),
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
                            width: double.infinity,
                            height: 55,
                            color: themeChange.darkTheme ? darkBar : lightBar,
                            child: FlatButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, "/settings"),
                              child: ListTile(
                                title: Text(
                                  "تنظیمات",
                                  style: TextStyle(
                                      fontFamily: mainFaFontFamily,
                                      fontSize: 15),
                                ),
                                leading: Icon(
                                  Icons.settings,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 55,
                            color: themeChange.darkTheme ? darkBar : lightBar,
                            child: FlatButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, "/readTermsOfService"),
                              child: ListTile(
                                title: Text(
                                  "قوانین و مقررات",
                                  style: TextStyle(
                                      fontFamily: mainFaFontFamily,
                                      fontSize: 15),
                                ),
                                leading: Icon(
                                  Icons.design_services,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
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
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: FlatButton(
                              onPressed: () => logoutSection(),
                              child: Text(
                                logoutBtnText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontFamily: mainFaFontFamily,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
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
