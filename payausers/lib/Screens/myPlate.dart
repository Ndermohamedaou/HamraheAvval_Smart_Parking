import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

List userPlates = [];
ApiAccess api = ApiAccess();
FlutterSecureStorage lds = FlutterSecureStorage();

class MYPlateScreen extends StatefulWidget {
  @override
  _MYPlateScreenState createState() => _MYPlateScreenState();
}

class _MYPlateScreenState extends State<MYPlateScreen> {
  @override
  void initState() {
    super.initState();

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

    void alert({title, desc, aType}) {
      Alert(
        context: context,
        type: aType,
        title: title,
        desc: desc,
        style: AlertStyle(
            backgroundColor: themeChange.darkTheme ? darkBar : Colors.white,
            titleStyle: TextStyle(
              fontFamily: mainFaFontFamily,
            ),
            descStyle: TextStyle(fontFamily: mainFaFontFamily)),
        buttons: [
          DialogButton(
            child: Text(
              "تایید",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: mainFaFontFamily),
            ),
            onPressed: () =>
                Navigator.popUntil(context, ModalRoute.withName("/dashboard")),
            width: 120,
          )
        ],
      ).show();
    }

    void delUserPlate(id) async {
      try {
        final userToken = await lds.read(key: "token");
        final delStatus = await api.delUserPlate(token: userToken, id: id);
        if (delStatus == "200") {
          alert(
              aType: AlertType.success,
              title: delProcSucTitle,
              desc: delProcDesc);
        }
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
          child: Container(
              color: themeChange.darkTheme ? darkBar : lightBar,
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
              onTap: () => delUserPlate(userPlates[index]['id']),
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.arrow_back_ios_rounded)),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        myPlateText,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: subTitleSize),
                      ),
                    ),
                  ],
                ),
              ),
              plateContext
            ],
          ),
        ),
      ),
    );
  }
}
