import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:payausers/ExtractedWidgets/userPlateDetailsInModal.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/deleteUserPlate.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';

class UserPlates extends StatefulWidget {
  const UserPlates();

  @override
  _UserPlatesState createState() => _UserPlatesState();
}

PlatesModel plateModel;
ReservesModel reservesModel;
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
    reservesModel = Provider.of<ReservesModel>(context);

    // UI Loading or Error handler
    LogLoading logLoadingWidgets = LogLoading();
    DeletePlate deletePlate = DeletePlate();

    openDetailsInModal(
        {List plate, hrStatus1, secStatus2, overalStatus, plateEn}) {
      /// Tow factor delete.
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
            delUserPlate: () => customAlert(
              context: context,
              alertIcon: Icons.delete,
              iconColor: Colors.blue,
              title: deletePlateTitle,
              desc: deletePlateDesc,
              acceptPressed: () {
                deletePlate.delUserPlate(id: plateEn, context: context);
                // Update user plates in Provider
                plateModel.fetchPlatesData;
                // Update reserves
                reservesModel.fetchReservesData;
              },
              ignorePressed: () => Navigator.pop(context),
            ),
          ),
        ),
      );
    }

    Widget plates = Builder(
      builder: (_) {
        if (plateModel.platesState == FlowState.Loading)
          return logLoadingWidgets.loading();

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
                  themeChange: themeChange.darkTheme,
                ),
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          myPlateText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              plates,
            ],
          ),
        ),
      ),
      floatingActionButton: plateModel.platesState == FlowState.Loading ||
              plateModel.platesState == FlowState.Error ||
              plateModel.plates.length >= 2
          ? SizedBox()
          : Container(
              width: 170,
              height: 55,
              margin: EdgeInsets.only(top: 20.0),
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(100.0),
                color: mainSectionCTA,
                child: MaterialButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/addingPlateIntro"),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "افزودن پلاک جدید",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: mainFaFontFamily,
                              fontSize: btnSized,
                              fontWeight: FontWeight.normal),
                        ),
                        Icon(Icons.playlist_add, color: Colors.white),
                      ],
                    )),
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
