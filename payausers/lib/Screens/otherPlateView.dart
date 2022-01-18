import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/addPlateProcess.dart';
import 'package:payausers/controller/flushbarStatus.dart';
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
              title: successfullPlateAddTitle,
              msg: successFullOtherPlateAddDesc,
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
              title: warnningOnAddPlate,
              msg: moreThanPlateAdded,
              iconColor: Colors.white,
              icon: Icons.close);
        }
        if (result == 1) {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: existUserPlateTitleErr,
              msg: existUserPlateDescErr,
              iconColor: Colors.white,
              icon: Icons.close);
        }
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
            title: "خطا در ارسال پلاک",
            msg: "لطفا پلاک معتبر وارد نمایید",
            iconColor: Colors.white,
            icon: Icons.close);
      }
    } else {
      setState(() => isAddingDocs = true);

      showStatusInCaseOfFlush(
          context: context,
          title: "اطلاعات خود را تکمیل کنید",
          msg: "اطلاعات خود را تکمیل کنید و سپس اقدام به ارسال کنید",
          iconColor: Colors.white,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    plateModel = Provider.of<PlatesModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
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
        color: mainSectionCTA,
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
