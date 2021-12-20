import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/Model/imageConvertor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payausers/Model/AlphabetClassList.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/PlateEnteryView.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/ExtractedWidgets/cardEntry.dart';
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
ImgConversion imgConvertor = ImgConversion();
AlphabetList alp = AlphabetList();

// Plate Modifire
String plate0 = "";
String plate2 = "";
String plate3 = "";
dynamic themeChange;
int _value = 0;
String ncCard;
String ncOwnerCard;
String ownerCarCard;
bool isAddingDocs = true;

class _FamilyPlateViewState extends State<FamilyPlateView> {
  @override
  void initState() {
    // Init all side effect variables :)
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
    ncCard = "";
    ncOwnerCard = "";
    ownerCarCard = "";
    isAddingDocs = true;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future gettingNationalCard() async {
    // Getting image from the phone system and convert it to bytes
    final pickedImage =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    // Convert bytes image to base64
    String melliCard64Img = await imgConvertor.img2Base64(pickedImage);

    // If user doen't select any image from the file system or gallery
    if (pickedImage != null)
      setState(() => ncCard = melliCard64Img);
    else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: ignoreToPickImageFromSystemTitle,
        title: ignoreToPickImageFromSystemDesc,
      );
  }

  /// For future if you want add national card of car owner to system
  // Future gettingOwnerNC() async {
  //   final pickedImage =
  //       await ImagePickerWeb.getImage(outputType: ImageType.bytes);
  //   String ownerMelliCard64Img = await imgConvertor.img2Base64(pickedImage);
  //   if (pickedImage != null) {
  //     setState(() => ncOwnerCard = ownerMelliCard64Img);
  //   } else
  //     showStatusInCaseOfFlushBottom(
  //       context: context,
  //       icon: Icons.close,
  //       iconColor: Colors.red,
  //       msg: "تصویر کارت را انتخاب کنید یا با دوربین دسنگاه تصویر برداری کنید",
  //       title: "عدم انتخاب تصویر",
  //     );
  // }

  Future gettingOwnerCarCard() async {
    // Getting image from the phone system and convert it to bytes
    final pickedImage =
        await ImagePickerWeb.getImage(outputType: ImageType.bytes);
    // Convert bytes image to base64
    String ownerCarCard64Img = await imgConvertor.img2Base64(pickedImage);

    if (pickedImage != null)
      setState(() => ownerCarCard = ownerCarCard64Img);
    else
      showStatusInCaseOfFlushBottom(
        context: context,
        icon: Icons.close,
        iconColor: Colors.red,
        msg: ignoreToPickImageFromSystemTitle,
        title: ignoreToPickImageFromSystemDesc,
      );
  }

  // Final process for preparing document, send to the server
  void addPlateProcInNow({
    plate0,
    plate1,
    plate2,
    plate3,
    nationalCardImg,
    ownerNationalCard,
    ownerCarCard,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (plate0 != "" &&
        plate1 != null &&
        plate2 != "" &&
        plate3 != "" &&
        nationalCardImg != "" &&
        // ownerNationalCard != "" &&
        ownerCarCard != "") {
      // Defining the loader indicator
      setState(() => isAddingDocs = false);
      final uToken = prefs.getString("token");
      // Preparing plate number for send to server
      List<dynamic> lsPlate = [plate0, plate1, plate2, plate3];
      int result = await addPlateProc.familyPlateReq(
          token: uToken,
          plate: lsPlate,
          selfMelli: nationalCardImg,
          ownerMelli: ownerNationalCard,
          ownerCarCard: ownerCarCard);

      // If all documents sent successfully
      // You will see successfull flush message from top of the phone
      if (result == 200) {
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
            iconColor: Colors.green,
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
            iconColor: Colors.red,
            icon: Icons.close);
      }

      // If you enter repetitious plate you will get warning message
      if (result == 1) {
        setState(() => isAddingDocs = true);
        showStatusInCaseOfFlush(
            context: context,
            title: existUserPlateTitleErr,
            msg: existUserPlateDescErr,
            iconColor: Colors.red,
            icon: Icons.close);
      }

      // If server can't handle request of add document to db you will get error message
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
          title: completeInformationTitle,
          msg: completeInformationDesc,
          iconColor: Colors.red,
          icon: Icons.close);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        title: Text(
          appBarTitle[pageIndex],
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            color: themeChange.darkTheme ? Colors.white : Colors.black,
          ),
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
              albumTapped: () => gettingNationalCard(),
              cameraTapped: () => gettingNationalCard(),
            ),
            // CardEntry(
            //   customIcon: "assets/images/nationalCardIcon.png",
            //   imgShow: ncOwnerCard,
            //   albumTapped: () => gettingOwnerNC(),
            //   cameraTapped: () => gettingOwnerNC(),
            // ),
            CardEntry(
              customIcon: "assets/images/OwnerCarCard.png",
              imgShow: ownerCarCard,
              albumTapped: () => gettingOwnerCarCard(),
              cameraTapped: () => gettingOwnerCarCard(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        hasCondition: isAddingDocs,
        text: pageIndex == 2 ? "ثبت اطلاعات" : nextLevel1,
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

  void nextPage() {
    if (pageIndex < 2) {
      setState(() => pageIndex++);
      _pageController.animateToPage(pageIndex,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    }
  }
}
