import 'package:flutter/material.dart';
import 'package:securityapp/classes/ApiAccess.dart';
import 'package:securityapp/constFile/ConstFile.dart';

import 'classes/SavingLocalStorage.dart';

List data;
ApiAccess api = ApiAccess();
LocalizationDataStorage lds = LocalizationDataStorage();

class SlotsView extends StatefulWidget {
  @override
  _SlotsViewState createState() => _SlotsViewState();
}

class _SlotsViewState extends State<SlotsView> {
  @override
  Widget build(BuildContext context) {
    void getSlotsFront() async {
      String uToken = await lds.gettingUserToken();
      data = await api.getSlots(uAuth: uToken);
    }

    getSlotsFront();

    // print(data[1]['vanak']["1"][5]);
    // print(data[1]['vanak']["1"].length);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'جایگاه های پارکینگ',
            style: TextStyle(fontFamily: mainFontFamily),
          ),
          bottom: TabBar(
            onTap: (tab) {
              // setState(() {
              //   tabIndex = tab;
              //   print(tabIndex);
              // });
            },
            tabs: [
              Tab(
                icon:
                    Icon(Icons.corporate_fare_rounded, color: Colors.blue[200]),
                child: Text(
                  "ونک",
                  style: TextStyle(
                      fontFamily: mainFontFamily, color: Colors.blue[400]),
                ),
              ),
              Tab(
                icon:
                    Icon(Icons.corporate_fare_rounded, color: Colors.blue[200]),
                child: Text(
                  "همراه اول",
                  style: TextStyle(
                      fontFamily: mainFontFamily, color: Colors.blue[400]),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text("طبقه اول",
                        style: TextStyle(
                            fontFamily: mainFontFamily, fontSize: 25)),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: data[1]['vanak']["1"].length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.center,
                                child: Text(data[1]['vanak']["1"][index]["id"]),
                              ),
                            );
                          }),
                    ),
                    Text("طبقه دوم",
                        style: TextStyle(
                            fontFamily: mainFontFamily, fontSize: 25)),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: data[1]['vanak']["2"].length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.center,
                                child: Text(data[1]['vanak']["2"][index]["id"]),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
