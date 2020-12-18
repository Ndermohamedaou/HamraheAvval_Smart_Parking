import 'package:flutter/material.dart';
import 'package:securityapp/classes/ApiAccess.dart';
import 'package:securityapp/constFile/ConstFile.dart';

import 'classes/SavingLocalStorage.dart';

List data;
Color slotColors;
ApiAccess api = ApiAccess();
LocalizationDataStorage lds = LocalizationDataStorage();

class SlotsView extends StatefulWidget {
  @override
  _SlotsViewState createState() => _SlotsViewState();
}

class _SlotsViewState extends State<SlotsView> {
  @override
  Widget build(BuildContext context) {
    // print(data[1]['vanak']["1"][2]['status']);
    // print(data[1]['vanak']["1"].length);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'جایگاه های پارکینگ',
          style: TextStyle(fontFamily: mainFontFamily),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("طبقه اول",
                  style: TextStyle(fontFamily: mainFontFamily, fontSize: 25)),
              // Container(
              //   margin:
              //       EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //   child: GridView.builder(
              //       shrinkWrap: true,
              //       itemCount: data[1]['vanak']["1"].length,
              //       gridDelegate:
              //           SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 5),
              //       itemBuilder: (BuildContext context, int index) {
              //         return GestureDetector(
              //           onTap: () {},
              //           child: Container(
              //             margin: EdgeInsets.symmetric(
              //                 vertical: 2, horizontal: 2),
              //             decoration: BoxDecoration(
              //                 color: data[1]['vanak']["1"][index]
              //                             ['status'] ==
              //                         1
              //                     ? Colors.red
              //                     : data[1]['vanak']["1"][index]
              //                                 ['status'] ==
              //                             -1
              //                         ? Colors.orange
              //                         : data[1]['vanak']["1"][index]
              //                                     ['status'] ==
              //                                 0
              //                             ? Colors.blue
              //                             : Colors.white,
              //                 borderRadius: BorderRadius.circular(20)),
              //             alignment: Alignment.center,
              //             child: Text(data[1]['vanak']["1"][index]["id"]),
              //           ),
              //         );
              //       }),
              // ),
              Text("طبقه دوم",
                  style: TextStyle(fontFamily: mainFontFamily, fontSize: 25)),
              // Container(
              //   margin:
              //       EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              //   child: GridView.builder(
              //       shrinkWrap: true,
              //       itemCount: data[1]['vanak']["2"].length,
              //       gridDelegate:
              //           SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 5),
              //       itemBuilder: (BuildContext context, int index) {
              //         return GestureDetector(
              //           onTap: () {},
              //           child: Container(
              //             margin: EdgeInsets.symmetric(
              //                 vertical: 2, horizontal: 2),
              //             decoration: BoxDecoration(
              //                 color: data[1]['vanak']["1"][index]
              //                             ['status'] ==
              //                         1
              //                     ? Colors.red
              //                     : data[1]['vanak']["1"][index]
              //                                 ['status'] ==
              //                             -1
              //                         ? Colors.orange
              //                         : data[1]['vanak']["1"][index]
              //                                     ['status'] ==
              //                                 0
              //                             ? Colors.blue
              //                             : Colors.white,
              //                 borderRadius: BorderRadius.circular(20)),
              //             alignment: Alignment.center,
              //             child: Text(data[1]['vanak']["2"][index]["id"]),
              //           ),
              //         );
              //       }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
