import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/cardEntry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/controller/addPlateProcess.dart';
import 'package:payausers/controller/changeAvatar.dart';
import 'package:payausers/controller/flushbarStatus.dart';
import 'package:payausers/controller/image_picker_controller.dart';
import 'package:payausers/controller/validate_plate.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
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
ImageConversion imageConversion = ImageConversion();
AvatarModel localData;

// Providers
PlatesModel plateModel;

// Plate modify
String plate0 = "";
String plate2 = "";
String plate3 = "";
int _value = 0;
File ncCard;
File ncOwnerCard;
File ownerCarCard;
bool isAddingDocs = true;
AppLocalizations t;

class _FamilyPlateViewState extends State<FamilyPlateView> {
  @override
  void initState() {
    _pageController = PageController();
    pageIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    plateModel = Provider.of<PlatesModel>(context);
    localData = Provider.of<AvatarModel>(context);
    appBarTitle = [
      t.translate("plates.addPlate.addPlateNumAppBar"),
      t.translate("plates.addPlate.familyPlate.appBar.nationalCardAppBar"),
      t.translate("plates.addPlate.familyPlate.appBar.ownerCarCardAppBar"),
    ];

    // TODO: Use one function to pick image.
    Future gettingNationalCard(ImageSource source) async {
      FlutterMediaPicker flutterMediaPicker = FlutterMediaPicker();
      final image = await flutterMediaPicker.pickImage(
        source: source,
      );

      if (image != null)
        setState(() => ncCard = image);
      else
        showStatusInCaseOfFlushBottom(
          context: context,
          icon: Icons.close,
          iconColor: Colors.white,
          title: t.translate("plates.mediaPicker.imagePickCanceledTitle"),
          msg: t.translate("plates.mediaPicker.imagePickCanceledDesc"),
        );
    }

    Future gettingOwnerCarCard(ImageSource source) async {
      FlutterMediaPicker flutterMediaPicker = FlutterMediaPicker();
      final image = await flutterMediaPicker.pickImage(
        source: source,
      );

      if (image != null)
        setState(() => ownerCarCard = image);
      else
        showStatusInCaseOfFlushBottom(
          context: context,
          icon: Icons.close,
          iconColor: Colors.white,
          title: t.translate("plates.mediaPicker.imagePickCanceledTitle"),
          msg: t.translate("plates.mediaPicker.imagePickCanceledDesc"),
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
          // Convert byte image to base64 image
          String _selfMelliImg =
              await imageConversion.checkSize(nationalCardImg);
          String _ownerCarCard = await imageConversion.checkSize(ownerCarCard);

          // Preparing plate number for sending to the server
          PlateStructure plate = PlateStructure(plate0, plate1, plate2, plate3);

          int result = await addPlateProc.uploadDocument(
            token: uToken,
            plate: plate,
            type: "family",
            data: {
              "melli_card_image": _selfMelliImg,
              "car_card_image": _ownerCarCard
            },
          );

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
                title: t.translate("plates.addPlate.addSuccessTitle"),
                msg: t.translate(
                    "plates.addPlate.familyPlate.plateAddedSuccessfulDesc"),
                mainBackgroundColor: "#00c853",
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
                title: t.translate("plates.addPlate.addPlateMoreThanNum"),
                msg: t.translate("plates.addPlate.addPlateMoreThanNumDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
          }

          // If you enter repetitious plate you will get warning message
          if (result == 1) {
            setState(() => isAddingDocs = true);
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate("plates.addPlate.repeatedPlateTitle"),
                msg: t.translate("plates.addPlate.repeatedPlateDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
          }

          // If server can't handle request of add document to db you will get error message
          if (result == -1) {
            setState(() => isAddingDocs = true);
            showStatusInCaseOfFlush(
                context: context,
                title: t.translate("plates.addPlate.addPlateServerErrorTitle"),
                msg: t.translate("plates.addPlate.addPlateServerErrorDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
          }
        } else {
          setState(() => isAddingDocs = true);
          showStatusInCaseOfFlush(
              context: context,
              title: t.translate("plates.addPlate.invalidPlateTitle"),
              msg: t.translate("plates.addPlate.invalidPlateDesc"),
              iconColor: Colors.white,
              icon: Icons.close);
        }
      } else {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: t.translate("plates.addPlate.completeInfoTitle"),
            msg: t.translate("plates.addPlate.completeInfoDesc"),
            iconColor: Colors.white,
            icon: Icons.close);
      }
    }

    void doNextPage() {
      /// In this Function we only change page index to increase view.
      ///
      /// This function is called when user tap on next button in bottom navigation bar.
      setState(() => pageIndex++);
      _pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }

    void nextPage() async {
      /// Next page checker function.
      ///
      /// Next page has a plate number validator and when it's not valid
      /// we will show error message to complete user plate.

      ValidatePlate plateValidation = ValidatePlate(context);

      final result = await plateValidation.isPlateValid(plate0,
          alp.getAlphabet()[_value].item, plate2, plate3, localData.userToken);
      if (pageIndex < 2) {
        if (pageIndex == 0)
          result["plateNumber"] && result["plateExist"]
              ? doNextPage()
              : showStatusInCaseOfFlush(
                  context: context,
                  title: result["title"],
                  msg: result["desc"],
                  iconColor: Colors.white,
                  icon: Icons.close);
        else if (pageIndex == 1 || pageIndex == 2)
          ncCard != null || ownerCarCard != null
              ? doNextPage()
              : showStatusInCaseOfFlush(
                  context: context,
                  title:
                      t.translate("plates.addPlate.documentMustNotNullTitle"),
                  msg: t.translate("plates.addPlate.documentMustNotNullDesc"),
                  iconColor: Colors.white,
                  icon: Icons.close);
        else
          doNextPage();
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
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
          onPageChanged: (onChangePage) =>
              setState(() => pageIndex = onChangePage),
          children: [
            PlateEntry(
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
            CardEntry(
              customIcon: "assets/images/carCardWithNationalCard.png",
              imgShow: ownerCarCard,
              attentionText:
                  t.translate("plates.addPlate.familyPlate.attention"),
              albumTapped: () => gettingOwnerCarCard(ImageSource.gallery),
              cameraTapped: () => gettingOwnerCarCard(ImageSource.camera),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        hasCondition: isAddingDocs,
        text: pageIndex == 2
            ? t.translate("global.actions.confirmInfo")
            : t.translate("navigation.next"),
        color: mainSectionCTA,
        onTapped: () => pageIndex == 2
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
}
