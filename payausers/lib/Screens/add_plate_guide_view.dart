import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/guide_opetion.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:provider/provider.dart';

class AddPlateGuideView extends StatefulWidget {
  const AddPlateGuideView({Key key}) : super(key: key);

  @override
  _AddPlateGuideViewState createState() => _AddPlateGuideViewState();
}

class _AddPlateGuideViewState extends State<AddPlateGuideView> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          t.translate("plates.addPlate.addPlateGuide"),
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
                text: t.translate("plates.addPlate.selfPlate.title") +
                    "\n" +
                    t.translate("plates.addPlate.selfPlate.desc")),
            SizedBox(height: 8),
            Option(
                themeChange: themeChange,
                text: t.translate("plates.addPlate.familyPlate.title") +
                    "\n" +
                    t.translate("plates.addPlate.familyPlate.desc")),
            SizedBox(height: 8),
            Option(
                themeChange: themeChange,
                text: t.translate("plates.addPlate.otherPlate.title") +
                    "\n" +
                    t.translate("plates.addPlate.otherPlate.desc")),
          ],
        ),
      ),
    );
  }
}
