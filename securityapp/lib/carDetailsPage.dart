import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constFile/ConstFile.dart';
import 'extractsWidget/optStyle.dart';
import 'extractsWidget/car_details_widget.dart';
import 'classes/Base64Convertor.dart';
import 'constFile/texts.dart';

// Data from Searching Plate
Map<String, Object> data = {};

class CarDetails extends StatefulWidget {
  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  @override
  Widget build(BuildContext context) {
    // Plates Data
    data = ModalRoute.of(context).settings.arguments;
    String parkMode = "";
    if (data['status'] == -1) {
      setState(() {
        parkMode = "رزور";
      });
    } else if (data['status'] == 1) {
      setState(() {
        parkMode = "پر";
      });
    } else if (data['status'] == 0) {
      setState(() {
        parkMode = "خالی";
      });
    }

    // Getting my conversion class (base64) 2 image
    Base64Convertor convert2Img = Base64Convertor();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(fontFamily: mainFontFamily),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PageViewContainer(
                imgPath: [
                  imgShower(
                    path: convert2Img.dataFromBase64String(
                        data['Plate_img'], BoxFit.fitWidth),
                  ),
                  imgShower(
                      path: convert2Img.dataFromBase64String(
                          data['car_img'], BoxFit.cover)),
                ],
              ),
              OptionsViewer(
                text: opt1Search,
                desc: "جایگاه ${data['slot']}",
                avatarIcon: slotIcon,
                avatarBgColor: slotBgColorIcon,
                iconColor: iconColor,
              ),
              OptionsViewer(
                text: opt2Status,
                desc: parkMode,
                avatarIcon: slotStatus,
                avatarBgColor: slotBgColorIconStatus,
                iconColor: bothIconNativeColor,
              ),
              OptionsViewer(
                text: opt3EntryTime,
                desc: "${data['entry_datetime']}",
                avatarIcon: entrySlotIcon,
                avatarBgColor: entryBgColor,
                iconColor: iconColorEntry,
              ),
              OptionsViewer(
                text: opt4ExitTime,
                desc: "${data['exit_datetime']}",
                avatarIcon: exitIcon,
                avatarBgColor: exitBgColorIcon,
                iconColor: bothIconNativeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
