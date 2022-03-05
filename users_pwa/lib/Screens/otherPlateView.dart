import 'package:flutter/material.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payausers/controller/addPlateProcess.dart';
import 'package:payausers/controller/flushbarStatus.dart';

class OtherPageView extends StatefulWidget {
  @override
  _OtherPageViewState createState() => _OtherPageViewState();
}

AddPlateProc addPlateProc = AddPlateProc();
AlphabetList alp = AlphabetList();

// Plate Modifire
String plate0 = "";
String plate2 = "";
String plate3 = "";
int _value = 0;
bool isAddingDocs = true;

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

  void addPlateProcInNow({plate0, plate1, plate2, plate3}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (plate0 != "" && plate1 != null && plate2 != "" && plate3 != "") {
      setState(() => isAddingDocs = false);
      final uToken = prefs.getString("token");
      PlateStructure plate = PlateStructure(plate0, plate1, plate2, plate3);
      int result = await addPlateProc
          .uploadDocument(token: uToken, type: "other", plate: plate, data: {});

      // If all documents sent successfully
      // You will see successfull flush message from top of the phone
      if (result == 200) {
        // Prevent to twice tapping happen
        setState(() => isAddingDocs = true);
        // Twice poping
        int count = 0;
        // Back to home page or maino dashboard view
        // with popUntill twice back in application
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
        showStatusInCaseOfFlush(
            context: context,
            title: successfulPlateAddTitle,
            msg: successFullOtherPlateAddDesc,
            mainBackgroundColor: "#00c853",
            iconColor: Colors.white,
            icon: Icons.done_outline);
      }

      // If you have more than 3 plate in db you will get warning message
      if (result == 100) {
        // Twice poping
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: warnningOnAddPlate,
            msg: moreThanPlateAdded,
            iconColor: Colors.white,
            icon: Icons.close);
      }

      // If you enter repetitious plate you will get warning message
      if (result == 1) {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: existUserPlateTitleErr,
            msg: existUserPlateDescErr,
            iconColor: Colors.white,
            icon: Icons.close);
      }

      // If server can't handle request of add document to db you will get error message
      if (result == -1) {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: errorPlateAddTitle,
            msg: errorPlateAddDsc,
            iconColor: Colors.white,
            icon: Icons.close);
      }
    } else {
      setState(() => isAddingDocs = true);
      showStatusInCaseOfFlush(
          context: context,
          title: completeInformationTitle,
          msg: completeInformationDesc,
          iconColor: Colors.white,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        title: Text(
          addPlateNumAppBar,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
        text: "ثبت اطلاعات",
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
