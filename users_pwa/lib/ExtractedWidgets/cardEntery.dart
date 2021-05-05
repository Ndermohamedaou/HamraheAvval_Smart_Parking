import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CardEntry extends StatelessWidget {
  const CardEntry(
      {this.albumTapped, this.cameraTapped, this.imgShow, this.customIcon});

  final cameraTapped;
  final albumTapped;
  final imgShow;
  final customIcon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double widthSizedResponse = size.width > 500 ? 20.0.w : 30.0.w;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0.w),
            child: imgShow == ""
                ? Image.asset(
                    customIcon,
                    width: widthSizedResponse,
                  )
                : Image.memory(
                    base64Decode(imgShow),
                    width: 50.0.w,
                    height: 50.0.w,
                    fit: BoxFit.fitWidth,
                  ),
          ),
          SizedBox(height: 10.0.w),
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
          SizedBox(height: 5.0.w),
          Container(
            margin: EdgeInsets.only(right: 40),
            child: Text(
              attentionToConfidance,
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
    var size = MediaQuery.of(context).size;
    final double boxSelectedSizedResponse = size.width >= 501
        ? 20.0.w
        : size.width < 500 && size.width > 421
            ? 30.0.w
            : size.width > 280 && size.width < 420
                ? 30.0.w
                : 50.0.w;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: boxSelectedSizedResponse,
        height: boxSelectedSizedResponse,
        decoration: BoxDecoration(
          color: themeChange.darkTheme ? darkBar : bgOfChoice,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: mainSectionCTA,
            ),
            Text(
              captureImage,
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

class AlbumTile extends StatelessWidget {
  const AlbumTile({
    this.onTap,
  });

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var size = MediaQuery.of(context).size;
    final double boxSelectedSizedResponse = size.width >= 501
        ? 20.0.w
        : size.width < 500 && size.width > 421
            ? 30.0.w
            : size.width > 280 && size.width < 420
                ? 30.0.w
                : 50.0.w;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: boxSelectedSizedResponse,
        height: boxSelectedSizedResponse,
        decoration: BoxDecoration(
          color: themeChange.darkTheme ? darkBar : bgOfChoice,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_album,
              color: mainSectionCTA,
            ),
            Text(
              useAlbumImage,
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
