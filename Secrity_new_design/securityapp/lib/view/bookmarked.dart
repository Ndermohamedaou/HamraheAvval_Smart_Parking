import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:securityapp/constFile/initRouteString.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/controller/localDataController.dart';
import 'package:securityapp/controller/sendImgCheckerProcess.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/model/sqfliteLocalCheck.dart';
import 'package:securityapp/widgets/CustomText.dart';
import 'package:securityapp/widgets/alert.dart';
import 'package:securityapp/widgets/flushbarStatus.dart';
import 'package:sizer/sizer.dart';

SavedSecurity saveSecurity = SavedSecurity();
LoadingLocalData LLDs = LoadingLocalData();
List savedList = [];
ImgProcessing imgProcessing = ImgProcessing();

class Bookmarked extends StatefulWidget {
  @override
  _BookmarkedState createState() => _BookmarkedState();
}

class _BookmarkedState extends State<Bookmarked> {
  @override
  void initState() {
    findLocalSave();
    super.initState();
  }

  findLocalSave() async {
    final saves = await saveSecurity.readySavedSecurity();
    setState(() => savedList = saves);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    twicePop() {
      // Twice poping
      int count = 0;
      // Back to home page or maino dashboard view
      // with popUntill twice back in application
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
    }

    sendItAgain({savedId, img, status, type}) async {
      final lStorage = FlutterSecureStorage();
      final token = await lStorage.read(key: "uToken");
      String buildingName = await lStorage.read(key: "buildingName");
      // print(token);
      // print(status);
      // print(savedId);

      try {
        final result = await imgProcessing.sendingImage(
          token: token,
          img: img,
          state: status,
          buildingName: buildingName,
          type: type,
        );

        // TODO: Fix this for future, we need class of Alarm for specific type.
        if (result["status"] == "success") {
          rAlert(
            context: context,
            title: result["message"]["title"],
            desc: result["message"]["desc"],
            tAlert: AlertType.success,
            onTapped: () => twicePop(),
          );

          bool delSaved = await saveSecurity.delSavedSecurity(id: savedId);
          if (delSaved) {
            // Getting relist from local data
            final reList = await saveSecurity.readySavedSecurity();
            setState(() => savedList = reList);
          }
        }

        if (result["status"] == "warning")
          rAlert(
            context: context,
            title: result["message"]["title"],
            desc: result["message"]["desc"],
            tAlert: AlertType.warning,
            onTapped: () => twicePop(),
          );

        if (result["status"] == "failed")
          rAlert(
            context: context,
            title: result["message"]["title"],
            desc: result["message"]["desc"],
            tAlert: AlertType.error,
            onTapped: () => twicePop(),
          );
      } catch (e) {
        showStatusInCaseOfFlush(
          context: context,
          icon: Icons.done,
          iconColor: Colors.white,
          title: updaingProblemTitle,
          msg: updaingProblemDsc,
        );
      }
    }

    final sliverList = SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        String trafficStatus = savedList[index]['trafficType'] == "0"
            ? "?????????? ???????? ?????????? ??????????"
            : "?????????? ???????? ?????????? ??????????";
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.5,
          child: Container(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 2.0.h,
                  ),
                  FlatButton(
                    onPressed: () => sendItAgain(
                      savedId: savedList[index]['id'],
                      img: savedList[index]['img'],
                      status: savedList[index]['trafficType'],
                      type: savedList[index]['trafficType'] == "0"
                          ? "entry"
                          : "exit",
                    ),
                    child: SavedContainer(
                      themeChange: themeChange,
                      trafficStatus: trafficStatus,
                      image: base64.decode(savedList[index]['img']),
                    ),
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconSlideAction(
              caption: '?????? ????????',
              color: Colors.red,
              icon: Icons.delete_outline_rounded,
              onTap: () async {
                final delResult = await saveSecurity.delSavedSecurity(
                    id: savedList[index]['id']);
                if (delResult) {
                  // Fetch again
                  final reList = await saveSecurity.readySavedSecurity();
                  setState(() => savedList = reList);
                  showStatusInCaseOfFlush(
                    context: context,
                    title: "?????? ????????",
                    msg: "???????? ???????? ?????? ?????? ???? ???????????? ???? ?????????? ?????????? ?????? ????",
                    icon: Icons.done,
                    iconColor: Colors.green,
                  );
                } else {
                  showStatusInCaseOfFlush(
                    context: context,
                    title: loginIsFailedByUsernameorPassTitle,
                    msg: loginIsFailedByUsernameorPassDsc,
                    icon: Icons.close,
                    iconColor: Colors.red,
                  );
                }
              },
            ),
          ],
        );
      }, childCount: savedList.isNotEmpty ? savedList.length : 0),
    );

    final placeholderSliver = SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            Container(
                alignment: Alignment.center,
                child: CustomText(
                  text: notFoundInfoInBookmarkStorage,
                  size: 15.0.sp,
                )),
          ],
        );
      }, childCount: 1),
    );

    final sliverListContent =
        savedList.isNotEmpty ? sliverList : placeholderSliver;

    // print(savedList);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 40.0.h,
            floating: false,
            pinned: true,
            backgroundColor: mainCTA,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: CustomText(
                text: saved,
                fw: FontWeight.bold,
                size: 10.0.sp,
              ),
              background: Image(
                image: AssetImage(
                    "assets/images/purple-parking-lot-with-no-cars.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName(mainoRoute));
              },
            ),
          ),
          sliverListContent
        ],
      ),
    );
  }
}

class SavedContainer extends StatelessWidget {
  const SavedContainer({
    Key key,
    @required this.themeChange,
    @required this.trafficStatus,
    this.image,
  }) : super(key: key);

  final DarkThemeProvider themeChange;
  final String trafficStatus;
  final image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      width: double.infinity,
      height: 20.0.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: themeChange.darkTheme ? darkOptionBg : lightOptionBg,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(image),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: themeChange.darkTheme ? darkOptionBg : lightOptionBg,
                ),
                child: CustomText(
                  text: trafficStatus,
                  size: 14.0.sp,
                  align: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
