import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'classes/ApiAccess.dart';
import 'classes/SharedClass.dart';
import 'confirmation_page.dart';
import 'package:toast/toast.dart';
import 'classes/SavingLocalStorage.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';
import 'controller/set_building.dart';
import 'extractsWidget/text_buildings.dart';

class SetBuilding extends StatefulWidget {
  @override
  _SetBuildingState createState() => _SetBuildingState();
}

Map responseData;
String _dropDownValue;
String _dropDownFaValue;
String currentOption = "";

class _SetBuildingState extends State<SetBuilding> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Getting Details of user for submit and saving in lds module
    responseData = ModalRoute.of(context).settings.arguments;
    buildings = responseData['buildings'];

    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.blue[900],
          child: MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              // Saving data from user info side
              savingData(
                  context: context,
                  uToken: responseData['uToken'],
                  buildingName: _dropDownValue,
                  buildingNameFa: _dropDownFaValue,
                  uInfo: responseData['res']);
            },
            child: Text(
              buildingSubmission,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                width: 500,
                decoration: BoxDecoration(
                    color: HexColor("#f9f9f9"),
                    borderRadius: BorderRadius.circular(20)),
                child: Image.asset("assets/images/building.png",
                    width: double.infinity),
              ),
              SizedBox(height: 20),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: DropdownButton(
                    hint: _dropDownValue == null
                        ? BuildingsCustomText(
                            text: setBuildingText,
                            textColor: themeChange.darkTheme
                                ? Colors.white
                                : Colors.grey,
                          )
                        : BuildingsCustomText(
                            text: _dropDownFaValue,
                            textColor: themeChange.darkTheme
                                ? Colors.white
                                : Colors.grey,
                          ),
                    isExpanded: true,
                    iconSize: 30.0,
                    icon: DropdownIcon(),
                    dropdownColor: HexColor("#7280C6"),
                    items: buildings.map(
                      (val) {
                        return DropdownMenuItem(
                          value: val['name_en'],
                          onTap: () {
                            setState(() {
                              _dropDownFaValue = val['name_fa'];
                            });
                          },
                          child: BuildingsCustomText(
                            text: val['name_fa'],
                            textColor: Colors.white,
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      setState(
                        () {
                          _dropDownValue = val;
                          print(_dropDownValue);
                          print(_dropDownFaValue);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
