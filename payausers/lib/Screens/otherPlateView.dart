import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
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

  void addPlateProcInNow({plate0, plate1, plate2, plate3}) async {
    if (plate0 != "" && plate1 != null && plate2 != "" && plate3 != "") {
      if (plate0.length == 2 && plate2.length == 3 && plate3.length == 2) {
// |      print(plate0);
//       print(plate1);
//       print(plate2);
//       print(plate3);
        setState(() => isAddingDocs = false);
        final uToken = await lds.read(key: "token");
        List<dynamic> lsPlate = [plate0, plate1, plate2, plate3];
        int result =
            await addPlateProc.otherPlateReq(token: uToken, plate: lsPlate);

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
              msg: "جهت تایید پلاک به سازمان مراجعه کنید",
              iconColor: Colors.green,
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
              iconColor: Colors.red,
              icon: Icons.close);
        }
        if (result == 1) {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: existUserPlateTitleErr,
              msg: existUserPlateDescErr,
              iconColor: Colors.red,
              icon: Icons.close);
        }
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
            title: "خطا در ارسال پلاک",
            msg: "لطفا پلاک معتبر وارد نمایید",
            iconColor: Colors.red,
            icon: Icons.close);
      }
    } else {
      setState(() => isAddingDocs = true);

      showStatusInCaseOfFlush(
          context: context,
          title: "اطلاعات خود را تکمیل کنید",
          msg: "اطلاعات خود را تکمیل کنید و سپس اقدام به ارسال کنید",
          iconColor: Colors.red,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    plateModel = Provider.of<PlatesModel>(context);

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
