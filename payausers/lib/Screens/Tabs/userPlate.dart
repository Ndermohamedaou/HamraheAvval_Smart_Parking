import 'dart:async';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:payausers/ExtractedWidgets/userPlateDetailsInModal.dart';
import 'package:payausers/controller/deleteUserPlate.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';

class UserPlates extends StatefulWidget {
  const UserPlates();

  @override
  _UserPlatesState createState() => _UserPlatesState();
}

PlatesModel plateModel;
Timer _onRefreshPlatesPerMin;

class _UserPlatesState extends State<UserPlates>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    _onRefreshPlatesPerMin = Timer.periodic(Duration(minutes: 1), (timer) {
      plateModel.fetchPlatesData;
    });
    super.initState();
  }

  @override
  void dispose() {
    _onRefreshPlatesPerMin.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Providers
    final themeChange = Provider.of<DarkThemeProvider>(context);
    plateModel = Provider.of<PlatesModel>(context);

    // UI Loading or Error handler
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
              delUserPlate: () {
                deletePlate.delUserPlate(
                    id: plateEn, context: context, themeChange: themeChange);
                // Update user plates in Provider
                plateModel.fetchPlatesData;
              },
            ),
          ),
        ),
      );
    }

    Widget plates = Builder(
      builder: (_) {
        if (plateModel.platesState == FlowState.Loading)
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

        if (plateModel.platesState == FlowState.Error)
          return logLoadingWidgets.internetProblem;

        final _plates = plateModel.plates;

        if (_plates.isEmpty)
          return logLoadingWidgets.notFoundReservedData(msg: "پلاک");

        return ListView.builder(
          shrinkWrap: true,
          itemCount: _plates.length,
          itemBuilder: (BuildContext context, index) {
            return (Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              fastThreshold: 1.25,
              movementDuration: Duration(milliseconds: 200),
              child: GestureDetector(
                  onTap: () => openDetailsInModal(
                          plate: [
                            _plates[index]['plate0'],
                            _plates[index]['plate1'],
                            _plates[index]['plate2'],
                            _plates[index]['plate3']
                          ],
                          plateEn: _plates[index]['plate_en'],
                          hrStatus1: _plates[index]["status1"],
                          secStatus2: _plates[index]["status2"],
                          overalStatus: _plates[index]["status"]),
                  child: PlateViewer(
                      plate0: _plates[index]['plate0'] != null
                          ? _plates[index]['plate0']
                          : "",
                      plate1: _plates[index]['plate1'] != null
                          ? _plates[index]['plate1']
                          : "",
                      plate2: _plates[index]['plate2'] != null
                          ? _plates[index]['plate2']
                          : "",
                      plate3: _plates[index]['plate3'] != null
                          ? _plates[index]['plate3']
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
                                  id: _plates[index]['plate_en'],
                                  context: context,
                                  themeChange: themeChange);
                              // Update user plates in Provider
                              plateModel.fetchPlatesData;
                              // print(_plates[index]['plate_en']);
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
