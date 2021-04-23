import 'dart:io';

import 'package:flutter/material.dart';
import 'package:payausers/Classes/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/cardEntery.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payausers/Screens/confirmInfo.dart';
import 'package:payausers/controller/addPlateProcess.dart';
import 'package:payausers/controller/flushbarStatus.dart';

class MinPlateView extends StatefulWidget {
  @override
  _MinPlateViewState createState() => _MinPlateViewState();
}

int pageIndex = 0;
PageController _pageController;
List appBarTitle = [];
AddPlateProc addPlateProc = AddPlateProc();
AlphabetList alp = AlphabetList();

// Plate Modifire
String plate0 = "";
String plate2 = "";
String plate3 = "";
dynamic themeChange;
int _value = 0;
File ncCard;
File carCard;

class _MinPlateViewState extends State<MinPlateView> {
  @override
  void initState() {
    _pageController = PageController();
    pageIndex = 0;
    appBarTitle = [addPlateNumAppBar, nationalCardAppBar, carCardAppBar];
    plate0 = "";
    plate2 = "";
    plate3 = "";
    _value = 0;
    ncCard = null;
    carCard = null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future gettingNationalCard(ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() => ncCard = image);
    } else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: "تصویر کارت را انتخاب کنید یا با دوربین دسنگاه تصویر برداری کنید",
        title: "عدم انتخاب تصویر",
      );
  }

  Future gettingCarCard(ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() => carCard = image);
    } else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: "تصویر کارت را انتخاب کنید یا با دوربین دسنگاه تصویر برداری کنید",
        title: "عدم انتخاب تصویر",
      );
  }

  void addPlateProcInNow(
      {plate0,
      plate1,
      plate2,
      plate3,
      File nationalCardImg,
      File carCardImg}) async {
    if (plate0 != "" &&
        plate1 != null &&
        plate2 != "" &&
        plate3 != "" &&
        nationalCardImg != null &&
        carCardImg != null) {
      String _ncImage64 = await imgConvertor.img2Base64(nationalCardImg);
      String _ccImage64 = await imgConvertor.img2Base64(carCardImg);
      // Loading will be create
      // TODO: Connect this where to Controller
      // if result of Controller into connected an api is true
      // and only in true result will save a data in lds to confrim from Confirmation page view
      // show alert => success and do following action
      // int count = 0;
      // Navigator.popUntil(context, (route) {
      //   return count++ == 2;
      // });
      // else if result of api is false
      // Laoding => false
      // alert => faild and do above action

    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainCTA,
        centerTitle: true,
        title: Text(
          appBarTitle[pageIndex],
          style: TextStyle(fontFamily: mainFaFontFamily),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (onChangePage) =>
              setState(() => pageIndex = onChangePage),
          children: [
            PlateEntery(
              plate0: plate0,
              plate0Adder: (value) => setState(() => plate0 = value),
              plate1: _value,
              plate1Adder: (value) => setState(() => _value = value),
              plate2: plate2,
              plate2Adder: (value) => setState(() => plate2 = value),
              plate3: plate3,
              plate3Adder: (value) => setState(() => plate3 = value),
            ),
            CardEntry(
              customIcon: "assets/images/nationalCardIcon.png",
              imgShow: ncCard,
              albumTapped: () => gettingNationalCard(ImageSource.gallery),
              cameraTapped: () => gettingNationalCard(ImageSource.camera),
            ),
            CardEntry(
              customIcon: "assets/images/OwnerCarCard.png",
              imgShow: carCard,
              albumTapped: () => gettingCarCard(ImageSource.gallery),
              cameraTapped: () => gettingCarCard(ImageSource.camera),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        text: pageIndex == 2 ? "ثبت اطلاعات" : nextLevel1,
        ontapped: () => pageIndex == 2
            ? addPlateProcInNow(
                plate0: plate0,
                plate1: alp.getAlphabet()[_value].item,
                plate2: plate2,
                plate3: plate3,
                nationalCardImg: ncCard,
                carCardImg: carCard,
              )
            : nextPage(),
      ),
    );
  }

  void nextPage() {
    if (pageIndex < 2) {
      setState(() => pageIndex++);
      _pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }
  }
}
