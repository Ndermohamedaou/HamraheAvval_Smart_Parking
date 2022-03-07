import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/guide_opetion.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:provider/provider.dart';

class ReserveGuideView extends StatefulWidget {
  const ReserveGuideView({Key key}) : super(key: key);

  @override
  _ReserveGuideViewState createState() => _ReserveGuideViewState();
}

class _ReserveGuideViewState extends State<ReserveGuideView> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          t.translate("reserves.guide.guideAppBar"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Option(
                themeChange: themeChange,
                text: t.translate("reserves.guide.colorIndicatorDescription")),
            SizedBox(height: 8),
            LeadingOption(
                themeChange: themeChange,
                indicatorColor: Colors.green,
                title: t.translate("reserves.guide.greenColorTitle"),
                subTitle: t.translate("reserves.guide.greenColorDesc")),
            LeadingOption(
                themeChange: themeChange,
                indicatorColor: Colors.orange,
                title: t.translate("reserves.guide.orangeColorTitle"),
                subTitle: t.translate("reserves.guide.orangeColorDesc")),
            LeadingOption(
                themeChange: themeChange,
                indicatorColor: Colors.red,
                title: t.translate("reserves.guide.redColorTitle"),
                subTitle: t.translate("reserves.guide.redColorDesc")),
            LeadingOption(
                themeChange: themeChange,
                indicatorColor: Colors.grey,
                title: t.translate("reserves.guide.greyColorTitle"),
                subTitle: t.translate("reserves.guide.greyColorDesc")),
            LeadingOption(
                themeChange: themeChange,
                indicatorColor: Colors.blue,
                title: t.translate("reserves.guide.blueColorTitle"),
                subTitle: t.translate("reserves.guide.blueColorTitle")),
            LeadingOption(
                themeChange: themeChange,
                indicatorColor: Colors.brown,
                title: t.translate("reserves.guide.brownColorTitle"),
                subTitle: t.translate("reserves.guide.brownColorDesc")),
          ],
        ),
      ),
    );
  }
}

class LeadingOption extends StatelessWidget {
  const LeadingOption({
    @required this.themeChange,
    this.indicatorColor,
    this.title,
    this.subTitle,
  });

  final DarkThemeProvider themeChange;
  final Color indicatorColor;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      width: double.infinity,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: themeChange.darkTheme ? darkBar : lightBar,
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignment: Alignment.centerRight,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          leading: CircleAvatar(backgroundColor: indicatorColor, radius: 10.0),
          title: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            subTitle,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: mainFaFontFamily,
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
