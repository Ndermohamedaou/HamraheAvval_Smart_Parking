import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class PlatePicker extends StatelessWidget {
  const PlatePicker({this.mainContext, this.plateForShow, this.selectedPlate});

  final mainContext;
  final plateForShow;
  final selectedPlate;

  @override
  Widget build(BuildContext context) {
    final titlePlateText = plateForShow != null
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "پلاک پیش فرض",
                        style: TextStyle(
                          fontFamily: mainFaFontFamily,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Text(
            "شما پلاک پیش فرضی ندارید",
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: 18,
            ),
          );
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),
          plateForShow,
          SizedBox(height: 40),
          FlatButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                enableDrag: true,
                bounce: true,
                duration: const Duration(milliseconds: 550),
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: Column(
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, right: 20),
                            child: Text(
                              "پلاک های شما",
                              style: TextStyle(
                                  fontFamily: mainFaFontFamily,
                                  fontSize: subTitleSize),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Icon(Icons.card_giftcard),
                          ),
                        ],
                      ),
                      mainContext
                    ],
                  ),
                ),
              );
            },
            color: mainCTA,
            child: Text(
              "پلاک خود را انتخاب کنید",
              style:
                  TextStyle(fontFamily: mainFaFontFamily, color: Colors.white),
              textDirection: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }
}
