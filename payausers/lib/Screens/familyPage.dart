import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/cardEntry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/addPlateProcess.dart';
import 'package:payausers/controller/changeAvatar.dart';
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
ImageConvetion imageConvetion = ImageConvetion();

// Providers
PlatesModel plateModel;

// Plate Modifire
String plate0 = "";
String plate2 = "";
String plate3 = "";
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
      // ownerNationalCardAppBar,
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
    );
    if (imageConvetion.imgSizeChecker(image)) if (image != null)
      setState(() => ncCard = image);
    else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.white,
        title: ignoreToPickImageFromSystemDesc,
        msg: ignoreToPickImageFromSystemTitle,
      );
    else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.white,
        title: imageIgnoredByHugeSizeTitle,
        msg: imageIgnoredByHugeSizeDesc,
      );
  }

  /// For future if you want add national card of car owner to system
  // Future gettingOwnerNC(ImageSource source) async {
  //   final image = await ImagePicker.pickImage(
  //     source: source,
  //     maxHeight: 500,
  //     maxWidth: 500,
  //     imageQuality: 50,
  //   );
  //   if (image != null) {
  //     setState(() => ncOwnerCard = image);
  //   } else
  //     showStatusInCaseOfFlushBottom(
  //       context: context,
  //       icon: Icons.close,
  //       iconColor: Colors.red,
  //       msg: "تصویر کارت را انتخاب کنید یا با دوربین دستگاه تصویر برداری کنید",
  //       title: "عدم انتخاب تصویر",
  //     );
  // }

  Future gettingOwnerCarCard(ImageSource source) async {
    final image = await ImagePicker.pickImage(
      source: source,
    );

    if (imageConvetion.imgSizeChecker(image)) if (image != null)
      setState(() => ownerCarCard = image);
    else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.white,
        title: ignoreToPickImageFromSystemDesc,
        msg: ignoreToPickImageFromSystemTitle,
      );
    else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.white,
        title: imageIgnoredByHugeSizeTitle,
        msg: imageIgnoredByHugeSizeDesc,
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
        // ownerNationalCard != null &&
        ownerCarCard != null) {
      if (plate0.length == 2 && plate2.length == 3 && plate3.length == 2) {
        // Defining the loader indicator
        setState(() => isAddingDocs = false);
        final uToken = await lds.read(key: "token");
        // Preparing plate number for send to server
        List<dynamic> lsPlate = [plate0, plate1, plate2, plate3];
        // Convert byte image to base64 image
        String _selfMelliImg = await imageConvetion.checkSize(nationalCardImg);
        // String _ownerMelliImg =
        //     await imgConvertor.img2Base64(ownerNationalCard);
        String _ownerCarCard = await imageConvetion.checkSize(ownerCarCard);

        // Seding data
        int result = await addPlateProc.familyPlateReq(
            token: uToken,
            plate: lsPlate,
            selfMelli: _selfMelliImg,
            // ownerMelli: _ownerMelliImg,
            ownerCarCard: _ownerCarCard);

        // If all documents sent successfully
        // You will see successfull flush message from top of the phone
        if (result == 200) {
          // Update Plate in Provider
          plateModel.fetchPlatesData;
          // Delay for getting plates in right time
          await Future.delayed(Duration(seconds: 1));

          // Prevent to twice tapping happen
          setState(() => isAddingDocs = true);
          // Twice poping
          int count = 0;
          // Back to home page or maino dashboard view
          // with popUntill twice back in application
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
          showStatusInCaseOfFlush(
              context: context,
              title: successfullPlateAddTitle,
              msg: successfullPlateAddDsc,
              iconColor: Colors.white,
              icon: Icons.done_outline);
        }

        // If you have more than 3 plate in db you will get warning message
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
              iconColor: Colors.white,
              icon: Icons.close);
        }

        // If you enter repetitious plate you will get warning message
        if (result == 1) {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: existUserPlateTitleErr,
              msg: existUserPlateDescErr,
              iconColor: Colors.white,
              icon: Icons.close);
        }

        // If server can't handle request of add document to db you will get error message
        if (result == -1) {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: errorPlateAddTitle,
              msg: errorPlateAddDsc,
              iconColor: Colors.white,
              icon: Icons.close);
        }
      } else {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: errorInSendPlateTitle,
            msg: errorInSendPlateDsc,
            iconColor: Colors.white,
            icon: Icons.close);
      }
    } else {
      setState(() => isAddingDocs = true);
      showStatusInCaseOfFlush(
          context: context,
          title: completeInformationTitle,
          msg: completeInformationDesc,
          iconColor: Colors.white,
          icon: Icons.close);
    }
  }

  bool isPlateValid() {
    /// We check length of entry plate at this function.
    ///
    /// After checking length of the plate number, we will send request
    /// to check this plate does exist or not for preventing from duplicate error at last.
    return plate0.length == 2 && plate2.length == 3 && plate3.length == 2
        ? true
        : false;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    plateModel = Provider.of<PlatesModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        title: Text(
          appBarTitle[pageIndex],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (onChangePage) => isPlateValid()
              ? setState(() => pageIndex = onChangePage)
              : showStatusInCaseOfFlush(
                  context: context,
                  title: isPlateValidTitle,
                  msg: isPlateValidDesc,
                  iconColor: Colors.white,
                  icon: Icons.close),
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
              customIcon: "assets/images/paper2.png",
              imgShow: ncCard,
              albumTapped: () => gettingNationalCard(ImageSource.gallery),
              cameraTapped: () => gettingNationalCard(ImageSource.camera),
            ),
            // CardEntry(
            //   customIcon: "assets/images/nationalCardIcon.png",
            //   imgShow: ncOwnerCard,
            //   albumTapped: () => gettingOwnerNC(ImageSource.gallery),
            //   cameraTapped: () => gettingOwnerNC(ImageSource.camera),
            // ),
            CardEntry(
              customIcon: "assets/images/paper1.png",
              imgShow: ownerCarCard,
              albumTapped: () => gettingOwnerCarCard(ImageSource.gallery),
              cameraTapped: () => gettingOwnerCarCard(ImageSource.camera),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        hasCondition: isAddingDocs,
        text: pageIndex == 2 ? "ثبت اطلاعات" : nextLevel1,
        color: mainSectionCTA,
        ontapped: () => pageIndex == 2
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

  void doNextPage() {
    /// In this Function we only change page index to increate view.
    ///
    /// This function is called when user tap on next button in bottom navigation bar.
    setState(() => pageIndex++);
    _pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void nextPage() {
    /// Next page checker function.
    ///
    /// Next page has a plate number validator and when it's not valid
    /// we will show error message to complete user plate.
    if (pageIndex < 2) {
      if (pageIndex == 0)
        isPlateValid()
            ? doNextPage()
            : showStatusInCaseOfFlush(
                context: context,
                title: isPlateValidTitle,
                msg: isPlateValidDesc,
                iconColor: Colors.white,
                icon: Icons.close);
      else if (pageIndex == 1 || pageIndex == 2)
        ncCard != null || ownerCarCard != null
            ? doNextPage()
            : showStatusInCaseOfFlush(
                context: context,
                title: documentMustNotNullTitle,
                msg: documentMustNotNullDesc,
                iconColor: Colors.white,
                icon: Icons.close);
      else
        doNextPage();
    }
  }
}
