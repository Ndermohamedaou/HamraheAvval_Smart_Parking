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

class FamilyPlateView extends StatefulWidget {
  @override
  _FamilyPlateViewState createState() => _FamilyPlateViewState();
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
File ncOwnerCard;
File ownerCarCard;

class _FamilyPlateViewState extends State<FamilyPlateView> {
  @override
  void initState() {
    _pageController = PageController();
    pageIndex = 0;
    appBarTitle = [
      addPlateNumAppBar,
      nationalCardAppBar,
      ownerNationalCardAppBar,
      ownerCarCardAppBar
    ];
    plate0 = "";
    plate2 = "";
    plate3 = "";
    _value = 0;
    ncCard = null;
    ncOwnerCard = null;
    ownerCarCard = null;
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

  Future gettingOwnerNC(ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() => ncOwnerCard = image);
    } else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: "تصویر کارت را انتخاب کنید یا با دوربین دسنگاه تصویر برداری کنید",
        title: "عدم انتخاب تصویر",
      );
  }

  Future gettingOwnerCarCard(ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() => ownerCarCard = image);
    } else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: "تصویر کارت را انتخاب کنید یا با دوربین دسنگاه تصویر برداری کنید",
        title: "عدم انتخاب تصویر",
      );
  }

  void addPlateProcInNow({
    plate0,
    plate1,
    plate2,
    plate3,
    File nationalCardImg,
    File ownerNationalCard,
    File ownerCarCard,
  }) async {
    if (plate0 != "" &&
        plate1 != null &&
        plate2 != "" &&
        plate3 != "" &&
        nationalCardImg != null &&
        ownerNationalCard != null &&
        ownerCarCard != null) {
      String _ncImage64 = await imgConvertor.img2Base64(nationalCardImg);
      String _ownerNcImage64 = await imgConvertor.img2Base64(ownerNationalCard);
      String _ownerCcImage64 = await imgConvertor.img2Base64(ownerCarCard);
      // TODO: Connect this where to Controller
      print(plate0);
      print(plate1);
      print(plate2);
      print(plate3);
      print(_ncImage64);
      print(_ownerNcImage64);
      print(_ownerCcImage64);
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
              customIcon: "assets/images/nationalCardIcon.png",
              imgShow: ncOwnerCard,
              albumTapped: () => gettingOwnerNC(ImageSource.gallery),
              cameraTapped: () => gettingOwnerNC(ImageSource.camera),
            ),
            CardEntry(
              customIcon: "assets/images/OwnerCarCard.png",
              imgShow: ownerCarCard,
              albumTapped: () => gettingOwnerCarCard(ImageSource.gallery),
              cameraTapped: () => gettingOwnerCarCard(ImageSource.camera),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        text: pageIndex == 3 ? "ثبت اطلاعات" : nextLevel1,
        ontapped: () => pageIndex == 3
            ? addPlateProcInNow(
                plate0: plate0,
                plate1: alp.getAlphabet()[_value].item,
                plate2: plate2,
                plate3: plate3,
                nationalCardImg: ncCard,
                ownerNationalCard: ncOwnerCard,
                ownerCarCard: ownerCarCard,
              )
            : nextPage(),
      ),
    );
  }

  void nextPage() {
    if (pageIndex < 3) {
      setState(() => pageIndex++);
      _pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }
  }
}
