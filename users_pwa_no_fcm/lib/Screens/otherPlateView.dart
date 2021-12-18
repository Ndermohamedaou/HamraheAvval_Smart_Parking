import 'package:flutter/material.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
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
      List<dynamic> lsPlate = [plate0, plate1, plate2, plate3];
      int result =
          await addPlateProc.otherPlateReq(token: uToken, plate: lsPlate);

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
            title: successfullPlateAddTitle,
            msg: successFullOtherPlateAddDesc,
            iconColor: Colors.green,
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
            iconColor: Colors.red,
            icon: Icons.close);
      }

      // If you enter repetitious plate you will get warning message
      if (result == 1) {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: existUserPlateTitleErr,
            msg: existUserPlateDescErr,
            iconColor: Colors.red,
            icon: Icons.close);
      }

      // If server can't handle request of add document to db you will get error message
      if (result == -1) {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: errorPlateAddTitle,
            msg: errorPlateAddDsc,
            iconColor: Colors.red,
            icon: Icons.close);
      }
    } else {
      setState(() => isAddingDocs = true);
      showStatusInCaseOfFlush(
          context: context,
          title: completeInformationTitle,
          msg: completeInformationDesc,
          iconColor: Colors.red,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          addPlateNumAppBar,
          style: TextStyle(fontFamily: mainFaFontFamily),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlateEntery(
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
        text: "ثبت اطلاعات",
        ontapped: () => addPlateProcInNow(
          plate0: plate0,
          plate1: alp.getAlphabet()[_value].item,
          plate2: plate2,
          plate3: plate3,
        ),
      ),
    );
  }
}
