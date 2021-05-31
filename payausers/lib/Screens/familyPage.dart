import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'package:payausers/providers/plate_model.dart';
import 'package:provider/provider.dart';

class FamilyPlateView extends StatefulWidget {
  @override
  _FamilyPlateViewState createState() => _FamilyPlateViewState();
}

int pageIndex = 0;
PageController _pageController;
List appBarTitle = [];
AddPlateProc addPlateProc = AddPlateProc();
FlutterSecureStorage lds = FlutterSecureStorage();
AlphabetList alp = AlphabetList();

// Providers
PlatesModel plateModel;

// Plate Modifire
String plate0 = "";
String plate2 = "";
String plate3 = "";
dynamic themeChange;
int _value = 0;
File ncCard;
File ncOwnerCard;
File ownerCarCard;
bool isAddingDocs = true;

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
    isAddingDocs = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future gettingNationalCard(ImageSource source) async {
    final image = await ImagePicker.pickImage(
      source: source,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() => ncCard = image);
    } else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: "تصویر کارت را انتخاب کنید یا با دوربین دستگاه تصویر برداری کنید",
        title: "عدم انتخاب تصویر",
      );
  }

  Future gettingOwnerNC(ImageSource source) async {
    final image = await ImagePicker.pickImage(
      source: source,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() => ncOwnerCard = image);
    } else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: "تصویر کارت را انتخاب کنید یا با دوربین دستگاه تصویر برداری کنید",
        title: "عدم انتخاب تصویر",
      );
  }

  Future gettingOwnerCarCard(ImageSource source) async {
    final image = await ImagePicker.pickImage(
      source: source,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() => ownerCarCard = image);
    } else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: "تصویر کارت را انتخاب کنید یا با دوربین دستگاه تصویر برداری کنید",
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
      if (plate0.length == 2 && plate2.length == 3 && plate3.length == 2) {
        setState(() => isAddingDocs = false);
        final uToken = await lds.read(key: "token");
        List<dynamic> lsPlate = [plate0, plate1, plate2, plate3];
        String _selfMelliImg = await imgConvertor.img2Base64(nationalCardImg);
        String _ownerMelliImg =
            await imgConvertor.img2Base64(ownerNationalCard);
        String _ownerCarCard = await imgConvertor.img2Base64(ownerCarCard);
        // print(plate0);
        // print(plate1);
        // print(plate2);
        // print(plate3);
        // print(_melliImg);
        // print(_ownerMelliImg);
        // print(_ownerCarCard);
        int result = await addPlateProc.familyPlateReq(
            token: uToken,
            plate: lsPlate,
            selfMelli: _selfMelliImg,
            ownerMelli: _ownerMelliImg,
            ownerCarCard: _ownerCarCard);

        if (result == 200) {
          // Update Plate in Provider
          plateModel.fetchPlatesData;

          // Prevent to twice tapping happen
          setState(() => isAddingDocs = true);
          // Twice poping
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
          showStatusInCaseOfFlush(
              context: context,
              title: successfullPlateAddTitle,
              msg: successfullPlateAddDsc,
              iconColor: Colors.green,
              icon: Icons.done_outline);
        }

        if (result == 100) {
          // Twice poping
          int count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: warnningOnAddPlate,
              msg: moreThanPlateAdded,
              iconColor: Colors.red,
              icon: Icons.close);
        }
        if (result == 1) {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: existUserPlateTitleErr,
              msg: existUserPlateDescErr,
              iconColor: Colors.red,
              icon: Icons.close);
        }
        if (result == -1) {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: errorPlateAddTitle,
              msg: errorPlateAddDsc,
              iconColor: Colors.red,
              icon: Icons.close);
        }
      } else {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: "خطا در ارسال پلاک",
            msg: "لطفا پلاک معتبر وارد نمایید",
            iconColor: Colors.red,
            icon: Icons.close);
      }
    } else {
      setState(() => isAddingDocs = true);

      showStatusInCaseOfFlush(
          context: context,
          title: "اطلاعات خود را تکمیل کنید",
          msg: "اطلاعات خود را تکمیل کنید و سپس اقدام به ارسال کنید",
          iconColor: Colors.red,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    plateModel = Provider.of<PlatesModel>(context);

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
        hasCondition: isAddingDocs,
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
