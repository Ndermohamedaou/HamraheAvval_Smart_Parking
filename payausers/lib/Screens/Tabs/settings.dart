import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logoutBtn.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({this.fullNameMeme, this.avatarMeme});

  final fullNameMeme;
  final avatarMeme;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final themeIconLeading = themeChange.darkTheme
        ? Icon(Icons.brightness_5, color: Colors.yellow)
        : Icon(Icons.bedtime, color: Colors.blue);
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              fullNameMeme,
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 15),
            ),
            background: Image(
              image: NetworkImage(avatarMeme),
              fit: BoxFit.cover,
            ),
          ),
          leading: Container(
            margin: EdgeInsets.all(10),
            child: ClipOval(
              child: Material(
                color: Colors.blue, // button color
                child: InkWell(
                  splashColor: Colors.blue[300], // inkwell color
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
                                    Navigator.pushNamed(context, "/myPlate"),
                                child: ListTile(
                                  title: Text(
                                    myPlateText,
                                    style: TextStyle(
                                        fontFamily: mainFaFontFamily,
                                        fontSize: 15),
                                  ),
                                  leading: Icon(
                                    Icons.car_repair,
                                    color: HexColor("#D800BF"),
                                    size: 30,
                                  ),
                                ),
                              )),
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
                          LogoutBtn(),
                        ],
                      ),
                    ),
                  ),
              childCount: 1),
        )
      ],
    );
  }
}
