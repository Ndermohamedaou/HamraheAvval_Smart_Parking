import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:toast/toast.dart';

// Show which date clicked and prepare to send it to API
String datePickedByUser = "";
String selectedPlate = "";
String startTime = "";
String endTime = "";
List userPlates = [];

class ReservedTab extends StatefulWidget {
  @override
  _ReservedTabState createState() => _ReservedTabState();
}

class _ReservedTabState extends State<ReservedTab> {
  // our text controller‍
  final TextEditingController textEditingController = TextEditingController();

  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    super.initState();
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: "${DateTime.now()}",
      fontFamily: mainFaFontFamily,
      onChange: (String oldDate, String newDate) {
        setState(() {
          datePickedByUser = newDate;
          print("This is new date $newDate");
        });
      },
    ).init();

    gettingMyPlates().then((plate) {
      setState(() {
        userPlates = plate;
      });
    });
  }

  Future<List> gettingMyPlates() async {
    ApiAccess api = ApiAccess();
    FlutterSecureStorage lds = FlutterSecureStorage();
    final userToken = await lds.read(key: "token");
    final plates = await api.getUserPlate(token: userToken);
    return plates;
  }

  void reserveMe(st, et, pt) async {
    if (st != "" && et != "" && pt != "") {
      ApiAccess api = ApiAccess();
      FlutterSecureStorage lds = FlutterSecureStorage();
      final userToken = await lds.read(key: "token");
      try {
        String reserveResult = await api.reserveByUser(
            token: userToken, startTime: st, endTime: et, plateNo: pt);
        if (reserveResult == "200") {
          // print(reserveResult);
          Navigator.pop(context);
          Toast.show(
              "رزرو شما با موفقیت انجام شد و نتیجه آن به صورت پیامک به شما اعلام خواهد شد",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } catch (e) {
        print(e);
      }
    } else
      Toast.show(dataEntryUnCorrect, context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    Widget plates = Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 300.0,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: false),
          items: userPlates.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlate = i['plate_en'];
                      });
                      Toast.show("پلاک انتخاب شد", context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                          textColor: Colors.white);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          // decoration: BoxDecoration(color: Colors.amber),
                          child: PlateViewer(
                              plate0: i['plate0'],
                              plate1: i['plate1'],
                              plate2: i['plate2'],
                              plate3: i['plate3'],
                              themeChange: themeChange.darkTheme),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ));
              },
            );
          }).toList(),
        )
      ],
    );

    Widget searchingProcess = Column(
      children: [
        Lottie.asset("assets/lottie/searching.json"),
        Text(searchingProcessText,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    final plateContext = userPlates.isEmpty ? searchingProcess : plates;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_rounded),
                    ),
                    Container(
                      child: Text(
                        choseReserveDate,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: subTitleSize),
                      ),
                    ),
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return persianDatePicker;
                        });
                  },
                  child: Icon(Icons.calendar_today_rounded)),
              Text(
                datePickedByUser,
                style: TextStyle(
                    fontFamily: mainFaFontFamily, fontSize: subTitleSize),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Text(
                      choseTime,
                      style: TextStyle(
                          fontFamily: mainFaFontFamily, fontSize: subTitleSize),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    'از',
                    style:
                        TextStyle(fontFamily: mainFaFontFamily, fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DatePicker.showTimePicker(
                        context,
                        locale: LocaleType.fa,
                        showTitleActions: true,
                        showSecondsColumn: false,
                        currentTime: DateTime.now(),
                        onChanged: (date) {
                          // print(date);
                        },
                        onConfirm: (date) {
                          setState(() {
                            startTime = "${date.hour}:${date.minute}";
                          });
                        },
                      );
                    },
                    child: Text(
                      startTime == "" ? "انتخاب" : startTime,
                      style: TextStyle(fontFamily: mainFaFontFamily),
                    ),
                  ),
                  Text(
                    'تا',
                    style:
                        TextStyle(fontFamily: mainFaFontFamily, fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      DatePicker.showTimePicker(
                        context,
                        showTitleActions: true,
                        showSecondsColumn: false,
                        currentTime: DateTime.now(),
                        onChanged: (date) {
                          // print(date);
                        },
                        onConfirm: (date) {
                          setState(() {
                            endTime = "${date.hour}:${date.minute}";
                          });
                        },
                      );
                    },
                    child: Text(
                      endTime == "" ? "انتخاب" : endTime,
                      style: TextStyle(fontFamily: mainFaFontFamily),
                    ),
                  ),
                ],
              ),

              Text("$startTime - $endTime",
                  style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
              plateContext,
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: loginBtnColor,
          child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                final pickDate = datePickedByUser.split("/");

                final strDateTimeStart =
                    "${pickDate[0]}-${pickDate[1]}-${pickDate[2]} $startTime";
                final strDateTimeEnd =
                    "${pickDate[0]}-${pickDate[1]}-${pickDate[2]} $endTime";

                // print(strDateTimeStart);
                // print(strDateTimeEnd);
                // print(selectedPlate);

                reserveMe(strDateTimeStart, strDateTimeEnd, selectedPlate);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "رزرو جایگاه",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: loginBtnTxtColor,
                        fontFamily: mainFaFontFamily,
                        fontSize: btnSized,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  )
                ],
              )),
        ),
      ),
    );
  }
}
