import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/addPlateProcess.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:provider/provider.dart';

class OtherPageView extends StatefulWidget {
  @override
  _OtherPageViewState createState() => _OtherPageViewState();
}

AddPlateProc addPlateProc = AddPlateProc();
FlutterSecureStorage lds = FlutterSecureStorage();
AlphabetList alp = AlphabetList();

// Provider
PlatesModel plateModel;

// Plate modify
String plate0 = "";
String plate2 = "";
String plate3 = "";
int _value = 0;
bool isAddingDocs = true;
AppLocalizations t;

class _OtherPageViewState extends State<OtherPageView> {
  @override
  void initState() {
    plate0 = "";
    plate2 = "";
    plate3 = "";
    _value = 0;
    isAddingDocs = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    t = AppLocalizations.of(context);
    plateModel = Provider.of<PlatesModel>(context);
    // Final level for preparing and sending data to the server
    void addPlateProcInNow({plate0, plate1, plate2, plate3}) async {
      if (plate0 != "" && plate1 != null && plate2 != "" && plate3 != "") {
        if (plate0.length == 2 && plate2.length == 3 && plate3.length == 2) {
          // isAddingDocs is a loader indicator for wating user to prevent send more data
          // and prevent to create queue from the user side
          setState(() => isAddingDocs = false);
          final uToken = await lds.read(key: "token");
          // Preparing plate number to send to the server
          PlateStructure plate = PlateStructure(plate0, plate1, plate2, plate3);
          int result = await addPlateProc.uploadDocument(
              token: uToken, type: "other", plate: plate, data: {});

          if (result == 200) {
            // Update user plate in Provider
            plateModel.fetchPlatesData;
            // Delay for getting plates in right
            await Future.delayed(Duration(seconds: 1));

            // Prevent to twice tapping happen
            setState(() => isAddingDocs = true);
            // Twice poping
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate("plates.addPlate.addSuccessTitle"),
                msg: t.translate(
                    "plates.addPlate.otherPlate.successfulOtherPlateAddDesc"),
                mainBackgroundColor: "#00c853",
                iconColor: Colors.white,
                icon: Icons.done_outline);
          }

          if (result == 100) {
            // Twice poping
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
            });
            setState(() => isAddingDocs = true);
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate("plates.addPlate.addPlateMoreThanNum"),
                msg: t.translate("plates.addPlate.addPlateMoreThanNumDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
          }
          if (result == 1) {
            setState(() => isAddingDocs = true);
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate("plates.addPlate.repeatedPlateTitle"),
                msg: t.translate("plates.addPlate.repeatedPlateDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
          }
          if (result == -1) {
            setState(() => isAddingDocs = true);
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate("plates.addPlate.addPlateServerErrorTitle"),
                msg: t.translate("plates.addPlate.addPlateServerErrorDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
          }
        } else {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: t.translate("plates.addPlate.invalidPlateTitle"),
              msg: t.translate("plates.addPlate.invalidPlateDesc"),
              iconColor: Colors.white,
              icon: Icons.close);
        }
      } else {
        setState(() => isAddingDocs = true);

        showStatusInCaseOfFlush(
            context: context,
            title: t.translate("plates.addPlate.completeInfoTitle"),
            msg: t.translate("plates.addPlate.completeInfoDesc"),
            iconColor: Colors.white,
            icon: Icons.close);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          t.translate("plates.addPlate.addPlateNumAppBar"),
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
              PlateEntry(
                plate0: plate0,
                plate0Adder: (value) => setState(() => plate0 = value),
                plate1: _value,
                plate1Adder: (value) => setState(() => _value = value),
                plate2: plate2,
                plate2Adder: (value) => setState(() => plate2 = value),
                plate3: plate3,
                plate3Adder: (value) => setState(() => plate3 = value),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomButton(
        hasCondition: isAddingDocs,
        color: mainSectionCTA,
        text: t.translate("global.actions.confirmInfo"),
        onTapped: () => addPlateProcInNow(
          plate0: plate0,
          plate1: alp.getAlphabet()[_value].item,
          plate2: plate2,
          plate3: plate3,
        ),
      ),
    );
  }
}
