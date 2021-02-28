import 'package:flutter/material.dart';
import 'package:liquid_ui/liquid_ui.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:sizer/sizer.dart';
import 'package:xlive_switch/xlive_switch.dart';

Widget buildMenu(
    {DarkThemeProvider themeChange, context, Function changeTheme, fullname}) {
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
          SizedBox(height: 100),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                XlivSwitch(
                  value: themeChange.darkTheme,
                  onChanged: changeTheme,
                ),
                SizedBox(width: 10),
                CustomText(
                  text: themeText,
                  size: 13.0.sp,
                )
              ],
            ),
          )
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
