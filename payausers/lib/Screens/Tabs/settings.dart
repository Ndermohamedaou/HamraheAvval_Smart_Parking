import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logoutBtn.dart';

class Settings extends StatelessWidget {
  const Settings({this.fullNameMeme, this.avatarMeme});

  final fullNameMeme;
  final avatarMeme;
  @override
  Widget build(BuildContext context) {
    print(avatarMeme);
    return SafeArea(
      child: CustomScrollView(
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
                    onTap: () => print("settings"),
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
                            LogoutBtn(),
                          ],
                        ),
                      ),
                    ),
                childCount: 1),
          )
        ],
      ),
    );
  }
}
