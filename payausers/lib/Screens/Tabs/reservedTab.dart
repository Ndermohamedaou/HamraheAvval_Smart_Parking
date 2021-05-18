import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:payausers/ExtractedWidgets/reserveDetailsInModal.dart';
import 'package:payausers/ExtractedWidgets/reserveHistoryView.dart';
import 'package:payausers/controller/instentReserveController.dart';
import 'package:payausers/controller/reservePlatePrepare.dart';
import 'package:payausers/controller/streamAPI.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';

class ReservedTab extends StatefulWidget {
  const ReservedTab({
    this.deletingReserve,
  });

  final Function deletingReserve;

  @override
  _ReservedTabState createState() => _ReservedTabState();
}

int filtered = 0;
bool loadingInstantReserve = false;

class _ReservedTabState extends State<ReservedTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    StreamAPI streamAPI = StreamAPI();
    LogLoading logLoadingWidgets = LogLoading();
    PreparedPlate preparedPlate = PreparedPlate();
    InstantReserve instantReserve = InstantReserve();
    FlutterSecureStorage lds = FlutterSecureStorage();

    void openDetailsInModal({
      reservID,
      List plate,
      startTime,
      endTime,
      building,
      slot,
    }) {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: SingleChildScrollView(
            child: ReserveInDetails(
              plate: plate,
              startTime: startTime,
              endTime: endTime,
              building: building,
              slot: slot,
              themeChange: themeChange,
              delReserve: () => widget.deletingReserve(reserveID: reservID),
            ),
          ),
        ),
      );
    }

    void instentReserveProcess(plateEn) async {
      setState(() => loadingInstantReserve = true);
      final token = await lds.read(key: "token");
      final result =
          await instantReserve.instantReserve(token: token, plate_en: plateEn);

      if (result != "") {
        setState(() => loadingInstantReserve = false);
        Alert(
          context: context,
          type: AlertType.success,
          title: "نتیجه رزرو لحظه ای شما",
          desc:
              "رزرو لحظه ای شما با موفقیت انجام شد و در موقعیت $result می تواند پارک خود را انجام دهید",
          style: AlertStyle(
              backgroundColor: themeChange.darkTheme ? darkBar : Colors.white,
              titleStyle: TextStyle(
                fontFamily: mainFaFontFamily,
              ),
              descStyle: TextStyle(fontFamily: mainFaFontFamily)),
          buttons: [
            DialogButton(
              child: Text(
                submitTextForAlert,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: mainFaFontFamily),
              ),
              onPressed: () => Navigator.popUntil(
                  context, ModalRoute.withName("/dashboard")),
              width: 120,
            )
          ],
        ).show();
      } else {
        setState(() => loadingInstantReserve = false);
        Alert(
          context: context,
          type: AlertType.error,
          title: "نتیجه رزرو لحظه ای شما",
          desc:
              "شما نمیتوانید رزرو لحظه ای خود را در این زمان انجام دهید. لطفا باری دیگر امتحان کنید",
          style: AlertStyle(
              backgroundColor: themeChange.darkTheme ? darkBar : Colors.white,
              titleStyle: TextStyle(
                fontFamily: mainFaFontFamily,
              ),
              descStyle: TextStyle(fontFamily: mainFaFontFamily)),
          buttons: [
            DialogButton(
              child: Text(
                submitTextForAlert,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: mainFaFontFamily),
              ),
              onPressed: () => Navigator.popUntil(
                  context, ModalRoute.withName("/dashboard")),
              width: 120,
            )
          ],
        ).show();
      }
    }

    final streamPlate = StreamBuilder(
      stream: streamAPI.getUserPlatesReal(),
      // ignore: missing_return
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return MaterialButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/addingPlateIntro"),
              child: Text(
                "پلاکی برای خود اضافه کنید",
                style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18),
              ),
            );
          else {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.centerRight,
                  child: Text(
                      "یکی از پلاک های خود را برای رزرو لحظه ای انتخاب کنید",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ),
                !loadingInstantReserve
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return FlatButton(
                            onPressed: () => instentReserveProcess(
                                snapshot.data[index]['plate_en']),
                            child: PlateViewer(
                                plate0: snapshot.data[index]['plate0'],
                                plate1: snapshot.data[index]['plate1'],
                                plate2: snapshot.data[index]['plate2'],
                                plate3: snapshot.data[index]['plate3'],
                                themeChange: themeChange.darkTheme),
                          );
                        })
                    : CircularProgressIndicator(),
                SizedBox(height: 40),
              ],
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("لطفا کمی شکیبا باشید",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
              ],
            ),
          );
        } else if (snapshot.hasError)
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            alignment: Alignment.center,
            child: logLoadingWidgets.internetProblem,
          );
      },
    );

    instantResrver() {
      showMaterialModalBottomSheet(
        context: context,
        enableDrag: true,
        bounce: true,
        duration: const Duration(milliseconds: 550),
        builder: (context) => SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: SingleChildScrollView(
            child: streamPlate,
          ),
        ),
      );
    }

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
                text: "نمایش 5 رزور",
                filterPressed: () {
                  setState(() => filtered = 5);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۲۰ رزرو",
                filterPressed: () {
                  setState(() => filtered = 20);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش ۵۰ رزرو",
                filterPressed: () {
                  setState(() => filtered = 50);
                  print("Filter is $filtered");
                  Navigator.pop(context);
                },
              ),
              FilterMenu(
                text: "نمایش تمام رزروها",
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
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reserveTextTitle,
                          style: TextStyle(
                              fontFamily: mainFaFontFamily,
                              fontSize: subTitleSize,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipOval(
                              child: Material(
                                color: mainCTA, // button color
                                child: InkWell(
                                  splashColor: mainSectionCTA, // inkwell color
                                  child: SizedBox(
                                      width: 46,
                                      height: 46,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      )),
                                  onTap: () => Navigator.pushNamed(
                                      context, "/reserveEditaion"),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            StreamBuilder(
                                stream:
                                    streamAPI.getUserCanInstantReserveReal(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data == 0
                                        ? SizedBox()
                                        : ClipOval(
                                            child: Material(
                                              color: Colors.red, // button color
                                              child: InkWell(
                                                  splashColor:
                                                      mainSectionCTA, // inkwell color
                                                  child: SizedBox(
                                                      width: 46,
                                                      height: 46,
                                                      child: Icon(
                                                        Icons.lock_clock,
                                                        color: Colors.white,
                                                      )),
                                                  onTap: () =>
                                                      instantResrver()),
                                            ),
                                          );
                                  } else if (snapshot.hasError)
                                    return SizedBox();
                                  else
                                    return SizedBox();
                                }),
                          ],
                        ),
                      ]),
                ),
              ),
              filtered != 0
                  ? Text(
                      "نتایج فیلتر شده هستند",
                      style: TextStyle(
                          fontFamily: mainFaFontFamily, fontSize: mainFontSize),
                    )
                  : SizedBox(),
              StreamBuilder(
                stream: streamAPI.getUserReserveReal(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return logLoadingWidgets.notFoundReservedData(
                          msg: "رزرو");
                    } else
                      return ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        primary: false,
                        itemCount: filtered == 0
                            ? snapshot.data.length
                            : snapshot.data.length > filtered
                                ? filtered
                                : snapshot.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return SingleChildScrollView(
                            child: GestureDetector(
                              onTap: () => openDetailsInModal(
                                reservID: snapshot.data[index]["id"],
                                plate: preparedPlate.preparePlateInReserve(
                                    rawPlate: snapshot.data[index]['plate']),
                                building:
                                    snapshot.data[index]["building"] != null
                                        ? snapshot.data[index]["building"]
                                        : "",
                                slot: snapshot.data[index]["slot"],
                                startTime: snapshot.data[index]
                                    ["reserveTimeStart"],
                                endTime: snapshot.data[index]["reserveTimeEnd"],
                              ),
                              child: (Column(
                                children: [
                                  ReserveHistoryView(
                                    historyBuildingName:
                                        snapshot.data[index]["building"] != null
                                            ? snapshot.data[index]["building"]
                                            : "",
                                    reserveStatusColor: snapshot.data[index]
                                        ['status'],
                                    historySlotName: snapshot.data[index]
                                        ["slot"],
                                    historyStartTime: snapshot.data[index]
                                        ["reserveTimeStart"],
                                    historyEndTime: snapshot.data[index]
                                        ["reserveTimeEnd"],
                                  ),
                                ],
                              )),
                            ),
                          );
                        },
                      );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("لطفا کمی شکیبا باشید",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: mainFaFontFamily, fontSize: 18)),
                      ],
                    );
                  } else if (snapshot.hasError)
                    return logLoadingWidgets.internetProblem;
                },
              ),
            ],
          ),
        ),
      ),
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
      ),
    );
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
        ));
  }
}
