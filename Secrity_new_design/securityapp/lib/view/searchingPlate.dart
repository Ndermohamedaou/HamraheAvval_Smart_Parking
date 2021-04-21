import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/searchingController.dart';
import 'package:securityapp/model/classes/AlphabetClassList.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/view/searchingByPersonalCode.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/dorpdownMenuItem.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:securityapp/widgets/searchingButton.dart';
import 'package:sizer/sizer.dart';

String plate0 = "";
String plate1 = "";
String plate2 = "";
String plate3 = "";
int _value = 0;
AlphabetList alp = AlphabetList();
DropdownItems ddi = DropdownItems();
SearchingCar searchMethod = SearchingCar();

class SearchByPlate extends StatefulWidget {
  @override
  _SearchByPlateState createState() => _SearchByPlateState();
}

class _SearchByPlateState extends State<SearchByPlate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    plate0 = "";
    plate1 = "";
    plate2 = "";
    plate3 = "";
    _value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    void SearchedByPlate({plate0, plate1, plate2, plate3}) async {
      if (plate0 != "" && plate1 != "" && plate2 != "" && plate3 != "") {
        // init Flutter Secure Storage
        // First getting token form Flutter local storage
        final lStorage = FlutterSecureStorage();
        final token = await lStorage.read(key: "uToken");
        // print("${plate0} ${plate1} ${plate2} ${plate3}");
        List plateArr = [plate0, plate1, plate2, plate3];
        List result =
            await searchMethod.searchingByPlate(token: token, plates: plateArr);
        // print(result);
        if (result.isNotEmpty)
          Navigator.pushNamed(context, searchResults, arguments: result[0]);
        else
          showStatusInCaseOfFlush(
            context: context,
            title: notFoundTitle,
            msg: notFoundDsc,
            icon: Icons.close,
            iconColor: Colors.red,
          );
      } else {
        showStatusInCaseOfFlush(
          context: context,
          title: emptyPlateTitle,
          msg: emptyPlateDsc,
          icon: Icons.close,
          iconColor: Colors.red,
        );
      }
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(context, ModalRoute.withName(mainoRoute));
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 30.0.h,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: CustomText(
                    text: searchText,
                    fw: FontWeight.bold,
                    size: 10.0.sp,
                  ),
                  background: Image(
                    image: AssetImage("assets/images/searchPlate.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName(mainoRoute));
                  },
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 4.45.h),
                              Container(
                                width: 100.0.w,
                                height: 70,
                                margin: EdgeInsets.only(
                                    top: 10, right: 20, left: 20, bottom: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        width: 2.8),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 2),
                                          Image.asset(
                                            "assets/images/iranFlag.png",
                                            width: 35,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'I.R.',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                'I R A N',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 13.0.w,
                                      height: 70,
                                      margin: EdgeInsets.only(top: 5),
                                      child: TextFormField(
                                        style: TextStyle(
                                            letterSpacing: 5,
                                            fontSize: 25.0.sp,
                                            fontFamily: mainFont,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                        initialValue: plate0,
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none),
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
                                      width: 14.0.w,
                                      height: 70,
                                      margin: EdgeInsets.only(top: 0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: _value,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: mainFont,
                                              color: themeChange.darkTheme
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 25),
                                          items: ddi.gettingLists(),
                                          onChanged: (value) {
                                            setState(() {
                                              _value = value;
                                              print(_value);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 20.0.w,
                                      height: 70,
                                      margin: EdgeInsets.only(top: 5),
                                      child: TextFormField(
                                        initialValue: plate2,
                                        style: TextStyle(
                                            letterSpacing: 5,
                                            fontSize: 25.0.sp,
                                            fontFamily: mainFont,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none),
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
                                        color: themeChange.darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                        thickness: 3),
                                    Container(
                                      width: 14.0.w,
                                      height: 70,
                                      margin:
                                          EdgeInsets.only(top: 5, right: 10),
                                      child: TextFormField(
                                        initialValue: plate3,
                                        style: TextStyle(
                                            letterSpacing: 5,
                                            fontSize: 25.0.sp,
                                            fontFamily: mainFont,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none),
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
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 30),
                                width: 10.0.w,
                                child: CustomText(
                                  text: plateSearchTip,
                                  size: 11.0.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5.0.h),
                              SearchBtn(
                                searchPressed: () => SearchedByPlate(
                                  plate0: plate0,
                                  plate1: alp.getAlphabet()[_value].item,
                                  plate2: plate2,
                                  plate3: plate3,
                                ),
                              ),
                            ],
                          ),
                        ),
                    childCount: 1),
              )
            ],
          ),
          floatingActionButton: FabCircularMenu(
            fabColor: floatingAction,
            ringColor: floatingAction,
            ringDiameter: 400.0,
            children: <Widget>[
              IconButton(
                  tooltip: slotText,
                  icon: Icon(
                    Icons.playlist_add_check_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, searchBySlotRoute)),
              IconButton(
                  tooltip: personalCodeSearchText,
                  icon: Icon(
                    Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, searchByPersCodeRoute)),
              IconButton(
                  tooltip: searchingByPhotoCapturing,
                  icon: Icon(
                    Icons.camera_enhance,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, searchByCameraRoute)),
            ],
          ),
        ),
      ),
    );
  }
}
