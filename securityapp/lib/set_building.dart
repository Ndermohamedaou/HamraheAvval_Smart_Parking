import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:securityapp/classes/ApiAccess.dart';
import 'package:securityapp/confirmation_page.dart';
import 'package:toast/toast.dart';
import 'classes/SavingLocalStorage.dart';
import 'constFile/ConstFile.dart';
import 'constFile/texts.dart';

class SetBuilding extends StatefulWidget {
  @override
  _SetBuildingState createState() => _SetBuildingState();
}

Map responseData;
List buildings;
int _value = 0;

class _SetBuildingState extends State<SetBuilding> {
  @override
  Widget build(BuildContext context) {
    // Getting Details of user for submit and saving in lds module
    responseData = ModalRoute.of(context).settings.arguments;
    buildings = responseData['buildings'];

    List<Widget> dropdownMenu = [
      DropdownMenuItem(
        child: Text('${buildings[0]['name_fa']}'),
        value: 0,
      ),
      DropdownMenuItem(
        child: Text('${buildings[1]['name_fa']}'),
        value: 1,
      ),
      DropdownMenuItem(
        child: Text('${buildings[2]['name_fa']}'),
        value: 2,
      ),
    ].toList();

    void savingData({uToken, buildingName, uInfo, buildingNameFa}) async {
      LocalizationDataStorage lds = LocalizationDataStorage();
      bool lStorageStatus = await lds.savingUInfo(
          uToken: uToken,
          fullName: uInfo['name'],
          email: uInfo['email'],
          personalCode: uInfo['personal_code'],
          naturalCode: uInfo['melli_code'],
          password: uInfo,
          avatar: uInfo['avatar'],
          buildingName: buildingName,
          buildingNameFA: buildingNameFa);

      if (lStorageStatus) {
        Navigator.pushNamed(context, '/');
      } else {
        Toast.show(applicationError, context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Colors.white);
      }
    }

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
              savingData(
                  uToken: responseData['uToken'],
                  buildingName: buildings[_value]['name_en'],
                  buildingNameFa: buildings[0]['name_fa'],
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
                child: Image.asset("assets/images/building.png",
                    width: double.infinity),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  buildingSubmissionTitle,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: mainFontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: double.infinity,
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: DropdownButton(
                    icon: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          CupertinoIcons.building_2_fill,
                          color: Colors.blue[500],
                          textDirection: TextDirection.rtl,
                        )),
                    value: _value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: mainFontFamily,
                        // color: midTextColor ? Colors.white : Colors.black,
                        color: Colors.black,
                        fontSize: 22),
                    items: dropdownMenu,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
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
