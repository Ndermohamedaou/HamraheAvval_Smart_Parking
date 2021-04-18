import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:payausers/controller/alert.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

List userPlates = [];
ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

class AddUserPlate extends StatefulWidget {
  @override
  _AddUserPlateState createState() => _AddUserPlateState();
}

class _AddUserPlateState extends State<AddUserPlate> {
  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 10), (timer) {
      gettingPlateRealTime();
    });
    gettingPlateRealTime();
  }

  void gettingPlateRealTime() {
    gettingMyPlates().then((plate) {
      setState(() {
        userPlates = plate;
      });
    });
  }

  Future<List> gettingMyPlates() async {
    ApiAccess api = ApiAccess();
    FlutterSecureStorage lds = FlutterSecureStorage();
    final userToken = await lds.read(key: "token");
    final plates = await api.getUserPlate(token: userToken);
    return plates;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    // print(userPlates);
    void delUserPlate(id) async {
      try {
        final userToken = await lds.read(key: "token");
        final delStatus = await api.delUserPlate(token: userToken, id: id);
        if (delStatus == "200") {
          alert(
              context: context,
              aType: AlertType.success,
              title: delProcSucTitle,
              desc: delProcDesc,
              themeChange: themeChange,
              dstRoute: "dashboard");
        }
        gettingMyPlates();
      } catch (e) {
        alert(
            aType: AlertType.warning,
            title: delProcFailTitle,
            desc: delProcFailDesc);
      }
    }

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
                        title: 'پاک کردن',
                        textStyle: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        onPressed: () {
                          delUserPlate(userPlates[index]['id']);
                        }),
                  ],
                  cancelAction: CancelAction(
                    title: 'لغو',
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

    Widget searchingProcess = Column(
      children: [
        Lottie.asset("assets/lottie/searching.json"),
        Text(searchingProcessText,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    final plateContext = userPlates.isEmpty ? searchingProcess : plates;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarAsNavigate(),
              plateContext,
            ],
          ),
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
                onTap: () => Navigator.pushNamed(
                    context, "/addUserplateAlternative",
                    arguments: {"route": "pop"}),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
