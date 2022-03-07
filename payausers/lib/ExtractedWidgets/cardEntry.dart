import 'package:flutter/material.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CardEntry extends StatelessWidget {
  const CardEntry(
      {this.albumTapped,
      this.cameraTapped,
      this.imgShow,
      this.customIcon,
      this.attentionText =
          "کاربر گرامی، جهت ارسال مدارک خود بایستی تصویر خود را به کمتر از ۱ مگابایت برسانید"});

  final cameraTapped;
  final albumTapped;
  final imgShow;
  final customIcon;
  final String attentionText;

  @override
  Widget build(BuildContext context) {
    AppLocalizations t = AppLocalizations.of(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
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
              attentionText,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 10.0.w, bottom: 10.0.w, right: 10.0.w, left: 10.0.w),
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 200.0,
            decoration: BoxDecoration(
              color: themeChange.darkTheme ? darkBar : lightBar,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: imgShow == null
                ? Image.asset(
                    customIcon,
                    width: 40.0.w,
                  )
                : Image.file(
                    imgShow,
                    width: 70.0.w,
                    fit: BoxFit.fitWidth,
                  ),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CameraTile(onTap: cameraTapped),
                SizedBox(width: 2.0.h),
                AlbumTile(
                  onTap: albumTapped,
                ),
              ],
            ),
          ),
          SizedBox(height: 2.0.w),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              t.translate("plates.addPlate.uploadDocumentAttention1"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraTile extends StatelessWidget {
  const CameraTile({
    this.onTap,
  });

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    AppLocalizations t = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.0.w,
        height: 30.0.w,
        decoration: BoxDecoration(
          color: themeChange.darkTheme ? darkBar : bgOfChoice,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/myCamera.png",
              width: 10.0.w,
            ),
            Text(
              t.translate("global.actions.imageCapture"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: Remove this widget and swap with top
class AlbumTile extends StatelessWidget {
  const AlbumTile({
    this.onTap,
  });

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    AppLocalizations t = AppLocalizations.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.0.w,
        height: 30.0.w,
        decoration: BoxDecoration(
          color: themeChange.darkTheme ? darkBar : bgOfChoice,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/myGallery.png",
              width: 10.0.w,
            ),
            Text(
              t.translate("global.actions.galleryPick"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: mainFaFontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
