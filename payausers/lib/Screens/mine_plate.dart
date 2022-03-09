import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/alphabet_class_List.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/Plate_entry_view.dart';
import 'package:payausers/ExtractedWidgets/bottom_btn_navigator.dart';
import 'package:payausers/ExtractedWidgets/card_entry.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/controller/add_plate_process.dart';
import 'package:payausers/controller/change_avatar.dart';
import 'package:payausers/controller/flushbar_status.dart';
import 'package:payausers/controller/image_picker_controller.dart';
import 'package:payausers/controller/validate_plate.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:provider/provider.dart';

class MinePlateView extends StatefulWidget {
  @override
  _MinePlateViewState createState() => _MinePlateViewState();
}

int pageIndex = 0;
PageController _pageController;
List appBarTitle = [];
AddPlateProc addPlateProc = AddPlateProc();
FlutterSecureStorage lds = FlutterSecureStorage();
AlphabetList alp = AlphabetList();
ImageConversion imageConversion = ImageConversion();

// Provider
PlatesModel plateModel;

// Plate modify,
// note plate1 is middle character.
String plate0 = "";
String plate2 = "";
String plate3 = "";
int _value = 0;
File ncCard;
File carCard;
bool isAddingDocs = true;
AvatarModel localData;
AppLocalizations t;

class _MinePlateViewState extends State<MinePlateView> {
  @override
  void initState() {
    // Init all variable for ready side effecting from useState
    _pageController = PageController();
    pageIndex = 0;

    // rm nationalCardAppBar view
    plate0 = "";
    plate2 = "";
    plate3 = "";
    _value = 0;
    ncCard = null;
    carCard = null;
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
    appBarTitle = [
      t.translate("plates.addPlate.addPlateNumAppBar"),
      t.translate("plates.addPlate.selfPlate.carCardAppBar"),
    ];
    plateModel = Provider.of<PlatesModel>(context);
    localData = Provider.of<AvatarModel>(context);

    Future gettingCarCard(ImageSource source) async {
      // Getting image from the phone system and convert it to bytes
      // Config new settings to grep image from the Mobile file system or gallery
      // I put my source as main source with maximum height and width size for sending to server
      // imageQuality is half but is okay for sending document to the system.
      FlutterMediaPicker flutterMediaPicker = FlutterMediaPicker();
      final image = await flutterMediaPicker.pickImage(
        source: source,
      );

      if (image != null)
        setState(() => carCard = image);
      else
        showStatusInCaseOfFlushBottom(
          context: context,
          icon: Icons.close,
          iconColor: Colors.red,
          title: t.translate("plates.mediaPicker.imagePickCanceledTitle"),
          msg: t.translate("plates.mediaPicker.imagePickCanceledDesc"),
        );
    }

    // Final process for preparing document, send to the server
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
          // nationalCardImg != null &&
          carCardImg != null) {
        // Active loading indicator for waiting for server response
        setState(() => isAddingDocs = false);
        // Validating plate number
        if (plate0.length == 2 && plate2.length == 3 && plate3.length == 2) {
          final uToken = await lds.read(key: "token");
          // Preparing plate number for sending to the server
          PlateStructure plate = PlateStructure(plate0, plate1, plate2, plate3);
          String _selfCarCard = await imageConversion.checkSize(carCardImg);

          int result = await addPlateProc.uploadDocument(
            token: uToken,
            plate: plate,
            type: "self",
            data: {
              // selfMelli: _selfMelliCard,
              "car_card_image": _selfCarCard,
            },
          );

          // If all documents sent successfully
          // You will see successful flush message from top of the phone
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
            iconColor: Colors.red,
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
      /// Next page has a plate number validator and when it's not valid
      /// we will show error message to complete user plate.

      ValidatePlate plateValidation = ValidatePlate(context);

      final result = await plateValidation.isPlateValid(plate0,
          alp.getAlphabet()[_value].item, plate2, plate3, localData.userToken);

      if (pageIndex < 1) {
        if (pageIndex == 0)
          result["plateNumber"] && result["plateExist"]
              ? doNextPage()
              : showStatusInCaseOfFlush(
                  context: context,
                  title: result["title"],
                  msg: result["desc"],
                  iconColor: Colors.white,
                  icon: Icons.close);
        else if (pageIndex == 1)
          carCard == null
              ? showStatusInCaseOfFlush(
                  context: context,
                  title:
                      t.translate("plates.addPlate.documentMustNotNullTitle"),
                  msg: t.translate("plates.addPlate.documentMustNotNullDesc"),
                  iconColor: Colors.white,
                  icon: Icons.close)
              : doNextPage();
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
              customIcon: "assets/images/paper1.png",
              imgShow: carCard,
              albumTapped: () => gettingCarCard(ImageSource.gallery),
              cameraTapped: () => gettingCarCard(ImageSource.camera),
              attentionText:
                  t.translate("plates.addPlate.selfPlate.carCardAttention"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        hasCondition: isAddingDocs,
        text: pageIndex == 1
            ? t.translate("global.actions.confirmInfo")
            : t.translate("navigation.next"),
        color: mainSectionCTA,
        onTapped: () => pageIndex == 1
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
}
