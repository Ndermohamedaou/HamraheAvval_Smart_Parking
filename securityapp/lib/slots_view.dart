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
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: GridView.builder(
                  padding: ,
                  itemCount: 20,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 10,
                  ),
                  itemBuilder: (BuildContext context, index){
                    return(
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                      )
                    );
                  },
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
