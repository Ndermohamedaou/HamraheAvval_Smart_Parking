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
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            choosePlate,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
            ),
          ),
          SizedBox(height: 60),
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
            color: selectedPlate != "" ? null : HexColor("#6f03fc"),
            child: selectedPlate != ""
                ? null

                // PlateViewer(
                //     plate0: endUserSelectedPlate['plate0'],
                //     plate1: endUserSelectedPlate['plate1'],
                //     plate2: endUserSelectedPlate['plate2'],
                //     plate3: endUserSelectedPlate['plate3'],
                //     themeChange: themeChange.darkTheme)
                : Text(
                    "پلاک خود را انتخاب کنید",
                    style: TextStyle(
                        fontFamily: mainFaFontFamily, color: Colors.white),
                    textDirection: TextDirection.ltr,
                  ),
          ),
        ],
      ),
    );
  }
}
