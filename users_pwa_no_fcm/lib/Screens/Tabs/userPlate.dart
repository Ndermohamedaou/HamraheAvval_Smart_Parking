import 'dart:async';

import 'package:flutter/cupertino.dart';
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
bool loadingDelTime = false;

class _UserPlatesState extends State<UserPlates>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    loadingDelTime = false;

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
          child: UserPlateInDetails(
            plate: plate,
            hrStatus: hrStatus1,
            secStatus: secStatus2,
            overalStatus: overalStatus,
            themeChange: themeChange,
            delUserPlate: () {
              deletePlate.delUserPlate(id: plateEn, context: context);
              // Update user plates in Provider
              plateModel.fetchPlatesData;
            },
          ),
        ),
      );
    }

    void openActionSheet(plateId) {
      showCupertinoModalBottomSheet(
        context: context,
        builder: (_) => CupertinoActionSheet(
          title: Text("حذف پلاک",
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 20)),
          message: Text(
              "آیا می خواهید پلاک خود را حذف کنید؟ این عمل باعث حذف پلاک شما در سامانه می شود",
              style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: loadingDelTime
                  ? CupertinoActivityIndicator()
                  : const Text("حذف پلاک",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: mainFaFontFamily,
                          color: Colors.red)),
              onPressed: () {
                setState(() => loadingDelTime = true);
                deletePlate.delUserPlate(
                  id: plateId,
                  context: context,
                );
                // Update user plates in Provider
                plateModel.fetchPlatesData;
                setState(() => loadingDelTime = false);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              child: const Text("لغو",
                  style: TextStyle(fontFamily: mainFaFontFamily)),
              onPressed: () => Navigator.pop(context)),
        ),
      );
    }

    Widget plates = Builder(
      builder: (_) {
        if (plateModel.platesState == FlowState.Loading)
          return logLoadingWidgets.waitCircularProgress();

        if (plateModel.platesState == FlowState.Error)
          return logLoadingWidgets.internetProblem;

        final _plates = plateModel.plates;

        if (_plates.isEmpty)
          return logLoadingWidgets.notFoundReservedData(msg: "ثبت پلاک");

        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _plates.length,
          itemBuilder: (BuildContext context, index) {
            return SingleChildScrollView(
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                fastThreshold: 1.25,
                movementDuration: Duration(milliseconds: 200),
                child: GestureDetector(
                    onTap: () {
                      // Update User Plates Provider
                      plateModel.fetchPlatesData;

                      openDetailsInModal(
                          plate: [
                            _plates[index]['plate0'],
                            _plates[index]['plate1'],
                            _plates[index]['plate2'],
                            _plates[index]['plate3']
                          ],
                          plateEn: _plates[index]['plate_en'],
                          hrStatus1: _plates[index]["status1"],
                          secStatus2: _plates[index]["status2"],
                          overalStatus: _plates[index]["status"]);
                    },
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
                      caption: delText,
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => openActionSheet(_plates[index]['plate_en'])),
                ],
              ),
            );
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
