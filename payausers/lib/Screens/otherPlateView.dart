import 'dart:io';

import 'package:flutter/material.dart';
import 'package:payausers/Classes/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/cardEntery.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payausers/Screens/confirmInfo.dart';
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

class _OtherPageViewState extends State<OtherPageView> {
  @override
  void initState() {
    plate0 = "";
    plate2 = "";
    plate3 = "";
    _value = 0;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addPlateProcInNow({plate0, plate1, plate2, plate3}) async {
    if (plate0 != "" && plate1 != null && plate2 != "" && plate3 != "") {
      // TODO: Connect this where to Controller
      print(plate0);
      print(plate1);
      print(plate2);
      print(plate3);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
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
