import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Model/ThemeColor.dart';
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
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    super.build(context);
    final targetPlatform =
        Theme.of(context).platform == TargetPlatform.iOS ? "iOS" : "Android";
    final localData = Provider.of<AvatarModel>(context);

    void logoutSection() {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        backgroundColor:
            themeChange.darkTheme ? mainBgColorDark : mainBgColorLight,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Iconsax.close_circle,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                t.translate('logout.logoutTitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 20.0,
                  color: Colors.orange,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  t.translate('logout.logoutDesc'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: mainFaFontFamily,
                    fontSize: 18.0,
                  ),
                ),
              ),
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(8.0),
                      color: mainSectionCTA,
                      child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async {
                            // Getting token from lStorage and cleaning LocalStorage as logout user
                            final lStorage = FlutterSecureStorage();
                            final userToken = await lStorage.read(key: "token");
                            ApiAccess api = ApiAccess(userToken);
                            // Getting logout endpoint.
                            Endpoint logoutEndpoint =
                                apiEndpointsMap["auth"]["logout"];

                            if (await api.requestHandler(logoutEndpoint.route,
                                    logoutEndpoint.method, {}) ==
                                "200") {
                              FlutterSecureStorage lds = FlutterSecureStorage();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              localData.refreshToken = "";
                              // Clear local storage data.
                              await lds.deleteAll();
                              prefs.setInt("user_plate_notif_number", 0);
                              prefs.clear();
                              Navigator.popUntil(
                                  context, ModalRoute.withName("/"));
                              // exit(0);
                            }
                          },
                          child: Text(
                            t.translate("global.actions.yes"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: loginBtnTxtColor,
                                fontFamily: mainFaFontFamily,
                                fontSize: btnSized,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(8.0),
                      color: themeChange.darkTheme ? darkBar : Colors.white,
                      child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            t.translate("global.actions.no"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: mainSectionCTA,
                                fontFamily: mainFaFontFamily,
                                fontSize: btnSized,
                                fontWeight: FontWeight.bold),
                          )),
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
    final avatarModel = Provider.of<AvatarModel>(context);

    final themeIconLeading = themeChange.darkTheme
        ? Icon(Iconsax.lamp_on, color: Colors.yellow)
        : Icon(Iconsax.lamp_slash, color: Colors.blue);

    Widget sliverAppBar({name, avatar}) => SliverAppBar(
          expandedHeight: 70.0.w,
          floating: false,
          pinned: true,
          backgroundColor: defaultAppBarColor,
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
                                switchActiveColor: mainCTA,
                                onChanged: (bool state) {
                                  themeChange.darkTheme = state;
                                },
                                title: Text(
                                  t.translate("systemSettings.darkTheme"),
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
                              onPressed: () =>
                                  Navigator.pushNamed(context, "/setBiometric"),
                              child: ListTile(
                                title: Text(
                                  t.translate("systemSettings.biometric"),
                                  style: TextStyle(
                                      fontFamily: mainFaFontFamily,
                                      fontSize: 15),
                                ),
                                leading: Icon(
                                  Iconsax.security_safe,
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
                                onPressed: () => Navigator.pushNamed(
                                    context, "/readTermsOfService"),
                                child: ListTile(
                                  title: Text(
                                    t.translate(
                                        "systemSettings.termsOfService"),
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        fontSize: 15),
                                  ),
                                  leading: Icon(
                                    Iconsax.box,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                ),
                              )),
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
                                  t.translate("logout.logoutButton"),
                                  style: TextStyle(
                                      fontFamily: mainFaFontFamily,
                                      fontSize: 15),
                                ),
                                leading: Icon(
                                  Iconsax.logout,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              t.translate("developedBy") +
                                  targetPlatform +
                                  t.translate("version"),
                              style: TextStyle(
                                fontFamily: mainFaFontFamily,
                                fontSize: 15,
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
