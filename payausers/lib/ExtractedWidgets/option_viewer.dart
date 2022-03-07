import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class GalleryViewerOption extends StatelessWidget {
  const GalleryViewerOption({this.galleryChoose, this.cameraChoose});

  final galleryChoose;
  final cameraChoose;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      "روش انتخاب تصویر",
                      style: TextStyle(
                        fontFamily: mainFaFontFamily,
                        fontSize: 18,
                        color: mainSectionCTA,
                      ),
                    ),
                    Icon(
                      Icons.photo,
                      color: mainSectionCTA,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: cameraChoose,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Lottie.asset(
                                "assets/lottie/cameraOption.json",
                                width: 60),
                          ),
                          // SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 20),
                            child: Text(
                              "دوربین",
                              style: TextStyle(fontFamily: mainFaFontFamily),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: galleryChoose,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 0),
                            child: Lottie.asset(
                                "assets/lottie/gelleryOption.json",
                                width: 110),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 0),
                            child: Text(
                              "گالری",
                              style: TextStyle(fontFamily: mainFaFontFamily),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}
