import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'classes/AlphabetClassList.dart';
import 'classes/ApiAccess.dart';
import 'package:toast/toast.dart';
import 'classes/SharedClass.dart';
import 'constFile/ConstFile.dart';
import 'constFile/dropDownItems.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'extractsWidget/login_extract_text_fields.dart';
import 'titleStyle/titles.dart';
import 'constFile/texts.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

String plate0 = "12";
String plate1 = "ط";
String plate2 = "345";
String plate3 = "11";
String realPlate = "";
List<String> platesList = [];
AlphabetList alp = AlphabetList();
List plateAlpList = alp.getAlphabet();
ApiAccess apiParkedCars = ApiAccess();
final lStorage = FlutterSecureStorage();
int tabIndex = 0;
int _value = 0;
String slot = "";
dynamic emptyTextFieldErr = null;

class SearchPlateSection extends StatefulWidget {
  @override
  _SearchPlateSectionState createState() => _SearchPlateSectionState();
}

class _SearchPlateSectionState extends State<SearchPlateSection> {
  void searchByPlate() async {
    String uToken = await lStorage.read(key: "uToken");

    if (tabIndex == 0) {
      try {
        platesList = [plate0, plateAlpList[_value].item, plate2, plate3];
        Map data = await apiParkedCars.parkedCarsInfo(
            uToken: uToken, sType: "plate", plates: platesList);
        Navigator.pushNamed(context, "/carDetails", arguments: data);
      } catch (e) {
        Toast.show("خطا در جست و جو", context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
        print(e);
      }
    } else if (tabIndex == 1) {
      if (slot != "") {
        try {
          Map data = await apiParkedCars.parkedCarsInfo(
              uToken: uToken, sType: "slot", slotNum: "${slot}");
          // print(data["status"]["status"]);
          if (data["status"]["status"] == 0)
            Toast.show("جایگاه خالی است", context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                textColor: Colors.white);
          else {
            Navigator.pushNamed(context, "/carDetails",
                arguments: data['meta']);
          }
        } catch (e) {
          Toast.show("خطا در جست و جو", context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Colors.white);
        }
      } else {
        setState(() {
          emptyTextFieldErr = emptyTextFieldMsg;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            searchingPlate,
            style: TextStyle(fontFamily: mainFontFamily),
          ),
          bottom: TabBar(
            onTap: (tab) {
              setState(() {
                tabIndex = tab;
                print(tabIndex);
              });
            },
            tabs: [
              Tab(
                icon: Icon(Icons.directions_car),
                child: Text(
                  "از طریق پلاک",
                  style: TextStyle(fontFamily: mainFontFamily),
                ),
              ),
              Tab(
                icon: Icon(Icons.wysiwyg),
                child: Text(
                  "از طریق جایگاه",
                  style: TextStyle(fontFamily: mainFontFamily),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.blue[900],
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () {
                searchByPlate();
              },
              child: Text(
                searchingPlate,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: loginTextFontFamily,
                    fontSize: loginTextSize,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: MainSection(),
      ),
    );
  }
}

class MainSection extends StatefulWidget {
  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return SafeArea(
        child: TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              themeChange.darkTheme
                  ? Lottie.asset("assets/lottie/carSearchingDark.json",
                      width: 300)
                  : Lottie.asset("assets/lottie/carSearchingLight.json",
                      width: 300),
              Container(
                width: double.infinity,
                height: 70,
                // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin:
                    EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            themeChange.darkTheme ? Colors.white : Colors.black,
                        width: 2.8),
                    borderRadius: BorderRadius.circular(8)),
                child: buildRowPlate(themeChange.darkTheme),
              ),
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin: EdgeInsets.only(right: 25, left: 10),
                    child: Text(
                      plateSearchDetail,
                      style: TextStyle(
                          fontFamily: mainFontFamily,
                          fontSize: 15,
                          color: Colors.grey.shade500),
                    ),
                  )),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset("assets/lottie/searchSlotsLight.json", width: 180),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: TextFields(
                  lblText: "شماره جایگاه",
                  textFieldIcon: Icons.wysiwyg,
                  textInputType: false,
                  readOnly: false,
                  errText: emptyTextFieldErr == null ? null : emptyTextFieldMsg,
                  onChangeText: (setSlot) {
                    setState(() {
                      emptyTextFieldErr = null;
                      slot = setSlot;
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }

  Row buildRowPlate(midTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.blue[900],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 2),
              Image.asset(
                "assets/images/iranFlag.png",
                width: 35,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'I.R.',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'I R A N',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 50,
          height: 70,
          margin: EdgeInsets.only(top: 0),
          child: TextFormField(
            showCursor: false,
            style: TextStyle(
                fontSize: 26,
                fontFamily: mainFontFamily,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            initialValue: plate0.toPersianDigit(),
            decoration:
                InputDecoration(counterText: "", border: InputBorder.none),
            maxLength: 2,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                plate0 = value;
              });
            },
          ),
        ),
        Container(
          width: 60,
          height: 70,
          margin: EdgeInsets.only(top: 7),
          child: DropdownButton(
            value: _value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: mainFontFamily,
                color: midTextColor ? Colors.white : Colors.black,
                fontSize: 22),
            items: dropdownMenu,
            onChanged: (value) {
              setState(() {
                _value = value;
                print(_value);
              });
            },
          ),
        ),
        Container(
          width: 50,
          height: 70,
          margin: EdgeInsets.only(top: 0, right: 0),
          child: TextFormField(
            initialValue: plate2.toPersianDigit(),
            style: TextStyle(
                fontSize: 26,
                fontFamily: mainFontFamily,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration:
                InputDecoration(counterText: "", border: InputBorder.none),
            maxLength: 3,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                plate2 = value;
              });
            },
          ),
        ),
        VerticalDivider(
            width: 1,
            color: midTextColor ? Colors.white : Colors.black,
            thickness: 3),
        Container(
          width: 50,
          height: 70,
          margin: EdgeInsets.only(top: 0, right: 10),
          child: TextFormField(
            initialValue: plate3.toPersianDigit(),
            style: TextStyle(
                fontSize: 26,
                fontFamily: mainFontFamily,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            decoration:
                InputDecoration(counterText: "", border: InputBorder.none),
            maxLength: 2,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                plate3 = value;
              });
            },
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
    );
  }
}
