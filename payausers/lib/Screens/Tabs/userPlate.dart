import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:payausers/Classes/streamAPI.dart';
import 'package:payausers/ExtractedWidgets/userPlateDetailsInModal.dart';
import 'package:payausers/controller/deleteUserPlate.dart';
import 'package:provider/provider.dart';

class UserPlates extends StatefulWidget {
  const UserPlates();

  @override
  _UserPlatesState createState() => _UserPlatesState();
}

class _UserPlatesState extends State<UserPlates>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    StreamAPI streamAPI = StreamAPI();
    LogLoading logLoadingWidgets = LogLoading();
    DeletePlate deletePlate = DeletePlate();

    void openDetailsInModal(
        {List plate, hrStatus1, secStatus2, overalStatus, plateEn}) {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: SingleChildScrollView(
            child: UserPlateInDetails(
              plate: plate,
              hrStatus: hrStatus1,
              secStatus: secStatus2,
              overalStatus: overalStatus,
              themeChange: themeChange,
              delUserPlate: () => deletePlate.delUserPlate(
                  id: plateEn, context: context, themeChange: themeChange),
            ),
          ),
        ),
      );
    }

    Widget plates = StreamBuilder(
      stream: streamAPI.getUserPlatesReal(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return logLoadingWidgets.notFoundReservedData(msg: "پلاک");
          else
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, index) {
                return (Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  fastThreshold: 1.25,
                  movementDuration: Duration(milliseconds: 200),
                  child: GestureDetector(
                      onTap: () => openDetailsInModal(
                              plate: [
                                snapshot.data[index]['plate0'],
                                snapshot.data[index]['plate1'],
                                snapshot.data[index]['plate2'],
                                snapshot.data[index]['plate3']
                              ],
                              plateEn: snapshot.data[index]['plate_en'],
                              hrStatus1: snapshot.data[index]["status1"],
                              secStatus2: snapshot.data[index]["status2"],
                              overalStatus: snapshot.data[index]["status"]),
                      child: PlateViewer(
                          plate0: snapshot.data[index]['plate0'] != null
                              ? snapshot.data[index]['plate0']
                              : "",
                          plate1: snapshot.data[index]['plate1'] != null
                              ? snapshot.data[index]['plate1']
                              : "",
                          plate2: snapshot.data[index]['plate2'] != null
                              ? snapshot.data[index]['plate2']
                              : "",
                          plate3: snapshot.data[index]['plate3'] != null
                              ? snapshot.data[index]['plate3']
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
                            style: TextStyle(
                                fontFamily: mainFaFontFamily, fontSize: 20),
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
                                  deletePlate.delUserPlate(
                                      id: snapshot.data[index]['plate_en'],
                                      context: context,
                                      themeChange: themeChange);
                                  // print(snapshot.data[index]['plate_en']);
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("لطفا کمی شکیبا باشید",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
            ],
          );
        } else if (snapshot.hasError) return logLoadingWidgets.internetProblem;
      },
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBarAsNavigate(),
            plates,
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
