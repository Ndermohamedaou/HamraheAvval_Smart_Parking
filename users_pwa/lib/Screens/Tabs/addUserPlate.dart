import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:provider/provider.dart';

class UserPlates extends StatelessWidget {
  const UserPlates({this.userPlates, this.delUserPlate, this.loadingUserplate});

  final List userPlates;
  final Function delUserPlate;
  final bool loadingUserplate;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    Widget plates = ListView.builder(
      shrinkWrap: true,
      itemCount: userPlates.length,
      itemBuilder: (BuildContext context, index) {
        return (Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          fastThreshold: 1.25,
          movementDuration: Duration(milliseconds: 200),
          child: Container(
              child: PlateViewer(
                  plate0: userPlates[index]['plate0'] != null
                      ? userPlates[index]['plate0']
                      : "",
                  plate1: userPlates[index]['plate1'] != null
                      ? userPlates[index]['plate1']
                      : "",
                  plate2: userPlates[index]['plate2'] != null
                      ? userPlates[index]['plate2']
                      : "",
                  plate3: userPlates[index]['plate3'] != null
                      ? userPlates[index]['plate3']
                      : "",
                  themeChange: themeChange.darkTheme)),
          actions: <Widget>[
            IconSlideAction(
              caption: 'پاک کردن',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                showAdaptiveActionSheet(
                  context: context,
                  title: Text(
                    'پاک شود؟',
                    style:
                        TextStyle(fontFamily: mainFaFontFamily, fontSize: 20),
                  ),
                  actions: <BottomSheetAction>[
                    BottomSheetAction(
                        title: Text(
                          'پاک کردن',
                          style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () =>
                            delUserPlate(plateID: userPlates[index]['id'])),
                  ],
                  cancelAction: CancelAction(
                    title: Text('لغو'),
                    textStyle: TextStyle(
                        fontFamily: mainFaFontFamily,
                        color: Colors.blue,
                        fontSize: 20),
                  ),
                );
              },
            ),
          ],
        ));
      },
    );

    Widget notFoundReservedData = Column(
      children: [
        Image.asset(
          "assets/images/emptyBox.png",
          width: 180,
          height: 180,
        ),
        Text("شما پلاک ثبت شده ای ندارید",
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    Widget internetProblem = Column(
      children: [
        Lottie.asset(
          "assets/lottie/notFoundTraffics.json",
          width: 180,
          height: 180,
        ),
        Text("عدم برقراری ارتباط با سرویس دهنده",
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );
    final plateContext = userPlates.length != 0 ? plates : notFoundReservedData;

    final realUserPlateView = loadingUserplate ? plateContext : internetProblem;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBarAsNavigate(),
            realUserPlateView,
          ],
        ),
      ),
    );
  }
}

class AppBarAsNavigate extends StatelessWidget {
  const AppBarAsNavigate({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            myPlateText,
            style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: subTitleSize,
                fontWeight: FontWeight.bold),
          ),
          ClipOval(
            child: Material(
              color: mainCTA, // button color
              child: InkWell(
                splashColor: mainSectionCTA, // inkwell color
                child: SizedBox(
                    width: 46,
                    height: 46,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    )),
                onTap: () => Navigator.pushNamed(context, "/addingPlateIntro"),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
