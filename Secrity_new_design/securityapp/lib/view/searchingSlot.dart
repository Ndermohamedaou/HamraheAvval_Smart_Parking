import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/searchingController.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:securityapp/widgets/searchingButton.dart';
import 'package:securityapp/widgets/textField.dart';
import 'package:sizer/sizer.dart';

String slotNumber;
SearchingCar searchMethod = SearchingCar();

class SearchingBySlot extends StatefulWidget {
  @override
  _SearchingBySlotState createState() => _SearchingBySlotState();
}

class _SearchingBySlotState extends State<SearchingBySlot> {
  @override
  void initState() {
    slotNumber = "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void searchedBySlot({slotNum}) async {
      if (slotNum != "") {
        // init Flutter Secure Storage
        // First getting token form Flutter local storage
        final lStorage = FlutterSecureStorage();
        final token = await lStorage.read(key: "uToken");
        Map result =
            await searchMethod.searchingBySlot(token: token, slot: slotNum);
        // print(result["meta"]);
        if (result["meta"] != null)
          Navigator.pushNamed(
            context,
            searchResults,
            arguments: result["meta"],
          );
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
          title: "جست و جوی مورد خالی غیر ممکن است",
          msg: "حداقل یک جایگاه را برای جست و جو انتخاب کنید",
          icon: Icons.close,
          iconColor: Colors.red,
        );
      }
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(context, ModalRoute.withName(mainoRoute));
      },
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
                  text: slotText,
                  size: 10.0.sp,
                  fw: FontWeight.bold,
                  color: Colors.black,
                ),
                background: Image(
                    image: AssetImage("assets/images/searchSlot.png"),
                    fit: BoxFit.cover),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName(mainoRoute));
                },
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => Container(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 4.45.h),
                              TextFields(
                                keyType: TextInputType.emailAddress,
                                lblText: slotNumberInSearch,
                                textFieldIcon: Icons.playlist_add_check_rounded,
                                textInputType: false,
                                readOnly: false,
                                onChangeText: (onChangeSlot) =>
                                    setState(() => slotNumber = onChangeSlot),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                width: 85.0.w,
                                child: CustomText(
                                  text: slotSearchTip,
                                  size: 11.0.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5.0.h),
                              SearchBtn(
                                searchPressed: () =>
                                    searchedBySlot(slotNum: slotNumber),
                              ),
                            ],
                          ),
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
                tooltip: searchText,
                icon: Icon(
                  Icons.search_sharp,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  final currentRoutePath = ModalRoute.of(context).settings.name;
                  if (currentRoutePath != "plateSearch") {
                    Navigator.pushNamed(context, searchByPlateRoute);
                  } else
                    null;
                }),
            IconButton(
                tooltip: slotText,
                icon: Icon(
                  Icons.playlist_add_check_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  final currentRoutePath = ModalRoute.of(context).settings.name;
                  if (currentRoutePath != "slotSearch") {
                    Navigator.pushNamed(context, searchBySlotRoute);
                  } else
                    null;
                }),
          ],
        ),
      ),
    );
  }
}
