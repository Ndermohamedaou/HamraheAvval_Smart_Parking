import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'classes/ApiAccess.dart';
import 'constFile/ConstFile.dart';
import 'classes/SavingLocalStorage.dart';
import 'constFile/texts.dart';
import 'extractsWidget/GraphicalSlotsWidget.dart';

Map data;
Color slotColors;
ApiAccess api = ApiAccess();
LocalizationDataStorage lds = LocalizationDataStorage();

class SlotsView extends StatefulWidget {
  @override
  _SlotsViewState createState() => _SlotsViewState();
}

class _SlotsViewState extends State<SlotsView> {
  @override
  // ignore: must_call_super
  void initState() {
    // To run await

    Timer.periodic(Duration(seconds: 10), (timer) {
      settingSlotsUpdatePerInterval();
    });
    // For initialized in first time to see this section
    settingSlotsUpdatePerInterval();
    // runs every 20 second
  }

  Future<Map> getSlots() async {
    String uToken = await lds.gettingUserToken();
    String slot = await lds.gettingUserSlot();
    data = await api.getSlots(uAuth: uToken, slotName: slot);
    return data;
  }

  settingSlotsUpdatePerInterval() {
    getSlots().then((results) {
      setState(() {
        data = results;
        // print(data["-1"]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(data[1]['vanak']["1"][2]['status']);
    // print(data[1]['vanak']["1"].length);
    // // final test:
    // print(data["floors"]);

    final spinnerIndicator =
        SpinKitFadingCube(size: 50, color: Colors.blue[700]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          parkingSlots,
          style: TextStyle(fontFamily: mainFontFamily),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 25),
            child: Column(
              children: [
                data == null
                    ? Center(child: spinnerIndicator)
                    : FloorSlots(
                        data: data,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
