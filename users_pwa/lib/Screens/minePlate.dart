import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/Model/Plate.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/Model/imageConvertor.dart';
import 'package:payausers/controller/validate_plate.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/plate_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/cardEntry.dart';
import 'package:payausers/controller/addPlateProcess.dart';
import 'package:payausers/controller/flushbarStatus.dart';

class MinePlateView extends StatefulWidget {
  @override
  _MinePlateViewState createState() => _MinePlateViewState();
}

int pageIndex = 0;
PageController _pageController;
List appBarTitle = [];
AddPlateProc addPlateProc = AddPlateProc();
ImgConversion imgConvertor = ImgConversion();
AlphabetList alp = AlphabetList();

// Plate Modifire
String plate0 = "";
String plate2 = "";
String plate3 = "";
dynamic themeChange;
int _value = 0;
String ncCard;
String carCard;
bool isAddingDocs = true;
AvatarModel localData;

// Providers
PlatesModel plateModel;

class _MinePlateViewState extends State<MinePlateView> {
  @override
  void initState() {
    // Init all variable for ready side effecting from useState statemanager
    _pageController = PageController();
    pageIndex = 0;

    // rm nationalCardAppBar view
    appBarTitle = [addPlateNumAppBar, carCardAppBar];
    plate0 = "";
    plate2 = "";
    plate3 = "";
    _value = 0;
    ncCard = "";
    carCard = "";
    isAddingDocs = true;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future gettingCarCard() async {
    // Getting image from the phone system and convert it to bytes
    final pickedImage =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    // Convert bytes image to base64
    String carCard64Img = await imgConvertor.img2Base64(pickedImage);
    // If user doen't select any image from the file system or gallery
    if (pickedImage != null)
      setState(() => carCard = carCard64Img);
    else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.white,
        title: ignoreToPickImageFromSystemTitle,
        msg: ignoreToPickImageFromSystemDesc,
      );
  }

  // Final process for preparing document, send to the server
  void addPlateProcInNow(
      {plate0, plate1, plate2, plate3, nationalCardImg, carCardImg}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (plate0 != "" &&
        plate1 != null &&
        plate2 != "" &&
        plate3 != "" &&
        // nationalCardImg != "" &&
        carCardImg != "") {
      setState(() => isAddingDocs = false);
      final uToken = prefs.getString("token");

      // Preparing plate number for sending to the server
      PlateStructure plate = PlateStructure(plate0, plate1, plate2, plate3);
      int result = await addPlateProc.uploadDocument(
        token: uToken,
        plate: plate,
        type: "self",
        data: {
          // selfMelli: _selfMelliCard,
          "car_card_image": carCardImg,
        },
      );

      // If all documents sent successfully
      // You will see successfull flush message from top of the phone
      if (result == 200) {
        // Update Plate in Provider
        plateModel.fetchPlatesData;
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
            title: successfulPlateAddTitle,
            msg: successfulPlateAddDsc,
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
          title: completeInformationTitle,
          msg: completeInformationDesc,
          iconColor: Colors.white,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    localData = Provider.of<AvatarModel>(context);
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
            // CardEntry(
            //   customIcon: "assets/images/nationalCardIcon.png",
            //   imgShow: ncCard,
            //   albumTapped: () => gettingNationalCard(),
            //   cameraTapped: () => gettingNationalCard(),
            // ),
            CardEntry(
              customIcon: "assets/images/paper1.png",
              imgShow: carCard,
              albumTapped: () => gettingCarCard(),
              cameraTapped: () => gettingCarCard(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        hasCondition: isAddingDocs,
        text: pageIndex == 1 ? "ثبت اطلاعات" : nextLevel1,
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

  void doNextPage() {
    /// In this Function we only change page index to increate view.
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

    ValidatePlate plateValidation = ValidatePlate();

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
                title: documentMustNotNullTitle,
                msg: documentMustNotNullDesc,
                iconColor: Colors.red,
                icon: Icons.close)
            : doNextPage();
      else
        doNextPage();
    }
  }
}
