import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddingPlateIntro extends StatefulWidget {
  @override
  _AddingPlateIntroState createState() => _AddingPlateIntroState();
}

class _AddingPlateIntroState extends State<AddingPlateIntro> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        centerTitle: true,
        title: Text(
          "ثبت پلاک به همراه اسناد",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            fontSize: subTitleSize,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.information,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/addPlateGuideView");
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddPlateOption(),
            ],
          ),
        ),
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
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.0.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: themeChange.darkTheme ? darkBar : lightBar,
              borderRadius: BorderRadius.circular(10.0),
            ),
            alignment: Alignment.centerRight,
            child: Text(
              t.translate("plates.addPlate.addPlateNote"),
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 1.0.h),
          UploadDocumentMethod(
            title: t.translate("plates.addPlate.selfPlate.title"),
            iconLeading: "assets/images/self.png",
            onPressed: () => Navigator.pushNamed(context, "/addingMinePlate"),
          ),
          Divider(
            color: Colors.grey,
            thickness: .25,
            indent: 20,
            height: 10,
          ),
          UploadDocumentMethod(
            title: t.translate("plates.addPlate.familyPlate.title"),
            iconLeading: "assets/images/family.png",
            onPressed: () => Navigator.pushNamed(context, "/addingFamilyPage"),
          ),
          Divider(
            color: Colors.grey,
            thickness: .25,
            indent: 20,
            height: 10,
          ),
          UploadDocumentMethod(
            title: t.translate("plates.addPlate.otherPlate.title"),
            iconLeading: "assets/images/other.png",
            onPressed: () => Navigator.pushNamed(context, "/addingOtherPlate"),
          ),
          Divider(
            color: Colors.grey,
            thickness: .25,
            indent: 20,
            height: 10,
          ),
        ],
      ),
    );
  }
}

class UploadDocumentMethod extends StatelessWidget {
  const UploadDocumentMethod({
    this.onPressed,
    this.title,
    this.iconLeading,
  });
  final Function onPressed;
  final String title;
  final String iconLeading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            leading: Image.asset(
              iconLeading,
              width: 40,
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}
