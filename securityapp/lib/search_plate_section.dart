import 'dart:io';
import 'package:flutter/material.dart';
import 'package:securityapp/classes/AlphabetClassList.dart';
import 'constFile/ConstFile.dart';
import 'constFile/dropDownItems.dart';
import 'titleStyle/titles.dart';
import 'constFile/texts.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

String plate0 = "12";
String plate1 = "ط";
String plate2 = "345";
String plate3 = "11";
String realPlate = "";
AlphabetList alp = AlphabetList();
List plateAlpList = alp.getAlphabet();
int _value = 0;

class SearchPlateSection extends StatefulWidget {
  @override
  _SearchPlateSectionState createState() => _SearchPlateSectionState();
}

class _SearchPlateSectionState extends State<SearchPlateSection> {
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
            tabs: [
              Tab(
                icon: Icon(Icons.directions_car),
                text: "از طریق پلاک",
              ),
              Tab(
                icon: Icon(Icons.wysiwyg),
                text: "از طریق جایگاه",
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
                setState(() {
                  realPlate =
                      "${plate0.toEnglishDigit()} ${plateAlpList[_value].value} ${plate2.toEnglishDigit()} ${plate3.toEnglishDigit()}";
                });
                // print("+++++++++++++++++++++++++++++");
                // print("Your plak is: ${realPlate}");
                // print("+++++++++++++++++++++++++++++");



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
    return SafeArea(
        child: TabBarView(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 70,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.8),
                    borderRadius: BorderRadius.circular(8)),
                child: buildRowPlate(),
              ),
              Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      plateSearchDetail,
                      style: TextStyle(fontFamily: mainFontFamily, fontSize: 15, color: Colors.grey.shade800),
                    ),
                  )),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [],
          ),
        )
      ],
    ));
  }

  Row buildRowPlate() {
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
          width: 50,
          height: 70,
          margin: EdgeInsets.only(top: 7),
          child: DropdownButton(
            value: _value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[500],
                fontFamily: mainFontFamily,
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
        VerticalDivider(width: 1, color: Colors.black, thickness: 3),
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
