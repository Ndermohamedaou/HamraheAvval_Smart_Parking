import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:provider/provider.dart';
import 'package:time_range/time_range.dart';

// Show which date clicked and prepare to send it to API
String datePickedByUser = "";
String startTime = "";
String endTime = "";
List userPlates = [];
bool selectedPlate = false;
DateTime dt;

int year;
int day;
int month;
int hour;
final clockArr = [];

class ReservedTab extends StatefulWidget {
  @override
  _ReservedTabState createState() => _ReservedTabState();
}

class _ReservedTabState extends State<ReservedTab> {
  // our text controller
  final TextEditingController textEditingController = TextEditingController();

  PersianDatePickerWidget persianDatePicker;

  @override
  void initState() {
    super.initState();
    persianDatePicker = PersianDatePicker(
      controller: textEditingController,
      datetime: "${DateTime.now()}",
      outputFormat: 'YYYY-MM-DD',
      fontFamily: mainFaFontFamily,
      onChange: (String oldDate, String newDate) {
        setState(() {
          dt = newDate as DateTime;
          year = dt.year;
          month = dt.month;
          day = dt.day;
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

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    // List dateArr = ;
    // year = dateArr[0] as int;

    // print(startTime.split(""));

    // final DateTest = DateTime(dateArr[0], dateArr[1], dateArr[2]);

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
                    onTap: () {},
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

    // print(DateTime.now());
    // print(datePickedByUser);
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
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TimeRange(
                      fromTitle: Text(
                        'از',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: mainFaFontFamily),
                      ),
                      toTitle: Text(
                        'تا',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: mainFaFontFamily),
                      ),
                      titlePadding: 20,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: mainFaFontFamily),
                      activeTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: mainFaFontFamily),
                      borderColor: Colors.blue[500],
                      backgroundColor: Colors.transparent,
                      activeBackgroundColor: Colors.blue,
                      firstTime: TimeOfDay(hour: 00, minute: 00),
                      lastTime: TimeOfDay(hour: 23, minute: 00),
                      timeStep: 60,
                      timeBlock: 60,
                      onRangeCompleted: (range) {
                        setState(() {
                          startTime = range.start.format(context);
                          endTime = range.end.format(context);
                          // print(range.start.period);
                          // print(startTime.split("AM")[0]);
                          // print(endTime.split("AM")[0]);
                          //
                        });
                      }),
                ),
              ),
              Text(
                "$startTime - $endTime",
                style: TextStyle(
                    fontFamily: mainFaFontFamily, fontSize: subTitleSize),
              ),
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
                print(startTime);

                // final pickDate = datePickedByUser.split("/");
                // print(pickDate[0]);
                // print(pickDate[1]);
                // print(pickDate[2]);

                // DateTime(pickDate[0] as int, pickDate[1] as int, pickDate[2] as int, );
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
