import 'package:flutter/material.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';

Widget buildMenu({
  DarkThemeProvider themeChange,
  avatar,
  context,
  Function changeTheme,
  fullname,
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 50.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: avatar != ""
                      ? NetworkImage(avatar)
                      : AssetImage(
                          "assets/images/isgpp_avatar_placeholder.png"),
                  radius: 35.0,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, profile),
                    child: Container(
                      margin: EdgeInsets.only(top: 40, left: 30),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: mainCTA,
                        child: Icon(
                          Icons.mode_edit,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                LText(
                  "\l.lead{سلام},\n\l.lead.bold{$fullname}",
                  baseStyle: TextStyle(
                      fontFamily: mainFont,
                      color:
                          themeChange.darkTheme ? Colors.white : Colors.black),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
          ListMenu(
            themeChange: themeChange,
            text: searchText,
            icon: Icons.search_sharp,
            pressedMenu: () => Navigator.pushNamed(context, searchByPlateRoute),
          ),
          ListMenu(
            themeChange: themeChange,
            text: slotText,
            icon: Icons.playlist_add_check_rounded,
            pressedMenu: () => Navigator.pushNamed(context, searchBySlotRoute),
          ),
          ListMenu(
            themeChange: themeChange,
            text: personalCodeSearchText,
            icon: Icons.person,
            pressedMenu: () =>
                Navigator.pushNamed(context, searchByPersCodeRoute),
          ),
          ListMenu(
            themeChange: themeChange,
            text: searchingByPhotoCapturing,
            icon: Icons.camera_enhance,
            pressedMenu: () =>
                Navigator.pushNamed(context, searchByCameraRoute),
          ),
          ListMenu(
            themeChange: themeChange,
            text: enterText,
            icon: Icons.login,
            pressedMenu: () => Navigator.pushNamed(context, entryCheck),
          ),
          ListMenu(
            themeChange: themeChange,
            text: exitText,
            icon: Icons.logout,
            pressedMenu: () => Navigator.pushNamed(context, exitCheck),
          ),
          ListMenu(
            themeChange: themeChange,
            text: saved,
            icon: Icons.bookmark,
            pressedMenu: () => Navigator.pushNamed(context, bookmarkRoute),
          ),
          ListMenu(
            themeChange: themeChange,
            text: initSettingsText,
            icon: Icons.settings,
            pressedMenu: () => Navigator.pushNamed(context, settingsRoute),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 2.0.h),
            child: CustomText(
              text:
                  "\u00a9 2021 ، پیاده سازی و توسعه یافته توسط صنایع ارتباطی پایا",
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 2.0.h),
            child: CustomText(
              text: "نسخه 0.0.2",
            ),
          ),
        ],
      ),
    ),
  );
}

class ListMenu extends StatelessWidget {
  const ListMenu({
    this.themeChange,
    this.text,
    this.icon,
    this.pressedMenu,
  });

  final DarkThemeProvider themeChange;
  final text;
  final icon;
  final Function pressedMenu;

  @override
  Widget build(BuildContext context) {
    return LListItem(
      backgroundColor: Colors.transparent,
      onTap: pressedMenu,
      leading: Icon(icon,
          size: 16.0.sp,
          color: themeChange.darkTheme ? Colors.white : Colors.black),
      title: CustomText(
        text: text,
        size: 11.0.sp,
      ),
      textColor: themeChange.darkTheme ? Colors.white : Colors.black,
      dense: true,
    );
  }
}
