import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:securityapp/classes/ApiAccess.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'classes/SavingLocalStorage.dart';
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
    Timer(Duration(milliseconds: 1), () {
      getSlots().then((results) {
        setState(() {
          data = results;
        });
      });
    });
  }

  Future<Map> getSlots() async {
    String uToken = await lds.gettingUserToken();
    String slot = await lds.gettingUserSlot();
    data = await api.getSlots(uAuth: uToken, slotName: slot);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    // print(data[1]['vanak']["1"][2]['status']);
    // print(data[1]['vanak']["1"].length);

    final spinnerIndicator = SpinKitFadingCube(size: 50, color: Colors.blue[700]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جایگاه های پارکینگ',
          style: TextStyle(fontFamily: mainFontFamily),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text("طبقه اول",
                    style: TextStyle(fontFamily: mainFontFamily, fontSize: 25)),
                // Text("${data["1"][0]["status"]}"),
                data == null
                    ? spinnerIndicator
                    : FloorSlots(
                        data: data,
                        slotsLen: data["1"].length,
                        floor: 1,
                      ),
                Text("طبقه دوم",
                    style: TextStyle(fontFamily: mainFontFamily, fontSize: 25)),
                data == null
                    ? spinnerIndicator
                    : FloorSlots(
                        data: data,
                        slotsLen: data["2"].length,
                        floor: 2,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
