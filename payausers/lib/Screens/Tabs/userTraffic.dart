import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/miniPlate.dart';
import 'package:payausers/controller/streamAPI.dart';
import 'package:sizer/sizer.dart';

class UserTraffic extends StatefulWidget {
  const UserTraffic();

  @override
  _UserTrafficState createState() => _UserTrafficState();
}

int filtered = 0;

class _UserTrafficState extends State<UserTraffic>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    StreamAPI streamAPI = StreamAPI();
    LogLoading logLoadingWidgets = LogLoading();

    Widget traffics = StreamBuilder(
      stream: streamAPI.getUserTrafficsReal(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return logLoadingWidgets.notFoundReservedData(msg: "تردد");
          else
            return ListView.builder(
              shrinkWrap: true,
              itemCount: filtered == 0
                  ? snapshot.data.length
                  : snapshot.data.length > filtered
                      ? filtered
                      : snapshot.data.length,
              primary: false,
              itemBuilder: (BuildContext context, index) {
                return (Column(
                  children: [
                    MiniPlate(
                      plate0: snapshot.data[index]["plate0"],
                      plate1: snapshot.data[index]["plate1"],
                      plate2: snapshot.data[index]["plate2"],
                      plate3: snapshot.data[index]["plate3"],
                      buildingName: snapshot.data[index]["building"] != null
                          ? snapshot.data[index]["building"]
                          : "",
                      startedTime: snapshot.data[index]["entry_datetime"],
                      endedTime: snapshot.data[index]["exit_datetime"],
                      slotNo: snapshot.data[index]["slot"],
                    ),
                  ],
                ));
              },
            );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("لطفا کمی شکیبا باشید",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
            ],
          );
        } else if (snapshot.hasError) return logLoadingWidgets.internetProblem;
      },
    );

    void filterSection() {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        // backgroundColor: ,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text("فیلتر نتایج",
                      style: TextStyle(
                        fontFamily: mainFaFontFamily,
                        color: mainCTA,
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: mainCTA,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              FilterMenu(
                text: "نمایش 5 تردد",
                filterPressed: () {
                  setState(() => filtered = 5);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۲۰ تردد",
                filterPressed: () {
                  setState(() => filtered = 20);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۵۰ تردد",
                filterPressed: () {
                  setState(() => filtered = 50);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش تمام تردد",
                filterPressed: () {
                  setState(() => filtered = 0);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 2.0.h),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        trafficsLogText,
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: subTitleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              filtered != 0
                  ? Text(
                      "نتایج فیلتر شده هستند",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily, fontSize: mainFontSize),
                    )
                  : SizedBox(),
              traffics,
            ],
          ),
        )),
        floatingActionButton: ClipOval(
          child: Material(
            color: mainCTA, // button color
            child: InkWell(
              splashColor: mainSectionCTA, // inkwell color
              child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  )),
              onTap: () => filterSection(),
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class FilterMenu extends StatelessWidget {
  const FilterMenu({
    this.text,
    this.filterPressed,
  });

  final String text;
  final Function filterPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: filterPressed,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 14.0.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
