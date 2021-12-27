import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/controller/alert.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/reserveController.dart';
import 'package:payausers/providers/reserves_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:provider/provider.dart';

// Declear Specific page index for controller
// int curIndex = 0;
// Show which date clicked and prepare to send it to API
String datePickedByUser = "";
bool isLoadingReserve = false;
dynamic themeChange;
List selectedDays = [];

class ReserveEditaion extends StatefulWidget {
  @override
  _ReserveEditaionState createState() => _ReserveEditaionState();
}

class _ReserveEditaionState extends State<ReserveEditaion> {
  // our text controller‍
  final TextEditingController textEditingController = TextEditingController();
  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    isLoadingReserve = false;
    datePickedByUser = "";

    getAWeek();
    super.initState();
  }

  @override
  void dispose() {
    selectedDays = [];
    super.dispose();
  }

  void getAWeek() {
    /// Get next week that will start with Saturday.
    ///
    /// With this function you can get a free week from Saturday to Thursday.
    ///
    var now = DateTime.now();
    var weekDay = now.weekday - 1;
    var firstOfTheWeek = now.add(Duration(days: weekDay));

    for (var i = 0; i < 6; i++)
      selectedDays.add(firstOfTheWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    themeChange = Provider.of<DarkThemeProvider>(context);
    ReservesModel reservesModel = Provider.of<ReservesModel>(context);
    // print(reservesModel.reserves["reserved_days"]);
    print(selectedDays);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
        ),
        title: Text(
          summery,
          style: TextStyle(
              fontFamily: mainFaFontFamily,
              color: themeChange.darkTheme ? Colors.white : Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Builder(
              builder: (_) {
                if (reservesModel.reserveState == FlowState.Loading)
                  return Text("Loeding");
                if (reservesModel.reserveState == FlowState.Error)
                  return Text("Error");
                List daysOfReserve = reservesModel.reserves["reserved_days"];

                if (daysOfReserve.isEmpty) return Text("List was empty.");

                return Text(daysOfReserve.toString());
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(),
    );
  }
}

/// TODO This Section for have weekly reserve function
///
/// - Create a LayoutBuilder for loading provider data and show some text for array of data [X]
/// - Getting next week and this next week will start at Saturday to Thursday [X]
/// - Show Mutliple Selector Widget for select or deslecting days of week [X]
/// - After all of that we need support events for this major function []
