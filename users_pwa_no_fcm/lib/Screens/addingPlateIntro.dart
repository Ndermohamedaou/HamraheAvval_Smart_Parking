import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

int pageIndex = 0;
PageController _pageController;

class AddingPlateIntro extends StatefulWidget {
  @override
  _AddingPlateIntroState createState() => _AddingPlateIntroState();
}

class _AddingPlateIntroState extends State<AddingPlateIntro> {
  @override
  void initState() {
    _pageController = PageController();
    pageIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          "ثبت پلاک به همراه اسناد",
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            color: themeChange.darkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (onChangeIndex) =>
              setState(() => pageIndex = onChangeIndex),
          children: [
            IntroInfo(),
            AddPlateOption(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            ClipOval(
              child: Material(
                color: mainCTA, // button color
                child: InkWell(
                  splashColor: mainSectionCTA, // inkwell color
                  child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(
                        pageIndex == 0
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  onTap: () {
                    pageIndex == 0
                        ? {
                            setState(() => pageIndex++),
                            _pageController.animateToPage(pageIndex,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.decelerate),
                          }
                        : setState(() => pageIndex--);
                    _pageController.animateToPage(pageIndex,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  },
                ),
              ),
            ),
            Row(
              children: [
                MenuIndecator(
                    colorIndicator:
                        pageIndex == 0 ? mainCTA : deactiveIndicator),
                SizedBox(width: 2.0.w),
                MenuIndecator(
                    colorIndicator:
                        pageIndex == 1 ? mainCTA : deactiveIndicator),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MenuIndecator extends StatelessWidget {
  const MenuIndecator({this.colorIndicator});

  final colorIndicator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: colorIndicator),
    );
  }
}

class IntroInfo extends StatelessWidget {
  const IntroInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double widthSizedResponseImg = size.width > 500 ? 50.0.w : 60.0.w;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10.0.h),
          Image.asset(
            "assets/images/AddingPlateSectionIntro.png",
            width: widthSizedResponseImg,
            filterQuality: FilterQuality.low,
            // height: 10.0.h,
          ),
          SizedBox(height: 1.0.h),
          Text(
            introSec1Title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.0.h),
          Text(
            introSec1Subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: 18,
                color: subtitleInIntro,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class AddPlateOption extends StatelessWidget {
  const AddPlateOption({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 5.0.h),
          Container(
            margin: EdgeInsets.only(right: 40, left: 20),
            child: Text(
              introSec2Title,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 1.0.h),
          Container(
            margin: EdgeInsets.only(right: 40),
            child: Text(
              introSec2Subtitle,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 18,
                  color: subtitleInIntro,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 1.0.h),
          // Options
          OptionChoser(
            infoColor: minPlateInfoIcon,
            bgColor: minPlate,
            mainTitle: minePlateTitleText,
            mainDsc: minePlateDescText,
            optionClicked: () =>
                Navigator.pushNamed(context, "/addingMinePlate"),
          ),
          OptionChoser(
            infoColor: familyPlateInfoIcon,
            bgColor: familyPlate,
            mainTitle: familyPlateTitleText,
            mainDsc: familyPlateDscText,
            optionClicked: () =>
                Navigator.pushNamed(context, "/addingFamilyPlate"),
          ),
          OptionChoser(
            infoColor: otherPlateInfoIcon,
            bgColor: otherPlate,
            mainTitle: otherPlateText,
            mainDsc: otherPlateDscText,
            optionClicked: () =>
                Navigator.pushNamed(context, "/addingOtherPlate"),
          ),
        ],
      ),
    );
  }
}

class OptionChoser extends StatelessWidget {
  const OptionChoser({
    this.bgColor,
    this.infoColor,
    this.mainTitle,
    this.mainDsc,
    this.optionClicked,
  });

  final infoColor;
  final bgColor;
  final mainTitle;
  final mainDsc;
  final Function optionClicked;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double widthSizedResponse =
        size.width > 500 ? 80.0.w : double.infinity;

    final double heightSizedResponse = size.width >= 501
        ? 120
        : size.width < 500 && size.width > 421
            ? 30.0.w
            : size.width > 280 && size.width < 420
                ? 50.0.w
                : 70.0.w;
    // print(size.width);

    final responsiveFontSize = size.width > 300 ? 13 : 13.0.sp;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      width: widthSizedResponse,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Material(
        color: bgColor,
        child: InkWell(
          onTap: optionClicked,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text("i"),
                  backgroundColor: infoColor,
                  radius: 10,
                ),
                title: CustomTextOption(mainTitle, mainFontSize),
                subtitle: CustomTextOption(mainDsc, subFontSize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextOption extends StatelessWidget {
  const CustomTextOption(this.text, this.fontSize);
  final text;
  final fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: mainFaFontFamily,
          fontSize: fontSize,
          color: Colors.white),
    );
  }
}
