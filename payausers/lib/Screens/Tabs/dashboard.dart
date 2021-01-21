import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dashboardTiles.dart';
import 'package:payausers/ExtractedWidgets/userLeading.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Dashboard extends StatelessWidget {
  const Dashboard(
      {this.fullnameMeme, this.userPersonalCodeMeme, this.avatarMeme, this.userQRCode});
  final String fullnameMeme;
  final String userPersonalCodeMeme;
  final String avatarMeme;
  final String userQRCode;

  @override
  Widget build(BuildContext context) {
    // Create Responsive Grid Container view
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 4;
    final double itemWidth = size.width;
    // Check if device be in Portrate or Landscape
    final double widthSizedResponse = size.width < 500
        ? size.width <= 375
            ? (itemWidth / itemHeight) / 2.9
            : (itemWidth / itemHeight) / 2.5
        : (itemWidth / itemHeight) / 5;

    // print(size.width);
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          // User Summery details on dashboard screen
          Directionality(
            textDirection: TextDirection.rtl,
            child: UserLeading(
              fullname: fullnameMeme,
              userPersonalCode: userPersonalCodeMeme,
              avatarImg: avatarMeme,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, right: 20),
                  width: 26,
                  height: 26,
                  child: Icon(
                    Icons.qr_code,
                    color: Colors.blue,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: bgColorTrendingUp),
                ),
                Text(
                  qrUserCode,
                  style: TextStyle(
                      fontFamily: mainFaFontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainTitleColor),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // QRCode Section
          Container(
            alignment: Alignment.center,
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: HexColor("#EBEAFA"),
                borderRadius: BorderRadius.circular(10.0)),
            child: QrImage(
              data: userQRCode,
              version: QrVersions.auto,
              padding: EdgeInsets.all(20),
              foregroundColor: HexColor("#000000"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: widthSizedResponse,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DashboardTiles(
                  tileColor: "#FEEBE7",
                  icon: Icons.directions_car,
                  iconColor: HexColor("#AC292E"),
                  text: qty,
                  subText: transactionsText,
                  subSubText: untilTodayText,
                  subSubTextColor: HexColor("#AC292E"),
                  lenOfStuff: "20",
                ),
                DashboardTiles(
                  tileColor: "#EDE5FC",
                  icon: Icons.book,
                  iconColor: HexColor("#6C2BDF"),
                  text: qty,
                  subText: allReserveText,
                  subSubText: untilTodayText,
                  subSubTextColor: HexColor("#6C2BDF"),
                  lenOfStuff: "13",
                ),
                DashboardTiles(
                  tileColor: "#E0FFED",
                  icon: Icons.account_balance,
                  iconColor: HexColor('#66D29F'),
                  text: "موقعیت",
                  subText: "فعلی شما",
                  subSubText: "",
                  subSubTextColor: HexColor("#66D29F"),
                ),
                DashboardTiles(
                  tileColor: "#E2EEFE",
                  icon: Icons.layers_sharp,
                  iconColor: HexColor("#216DCD"),
                  text: qty,
                  subText: yourPlateText,
                  subSubText: inSystemText,
                  subSubTextColor: HexColor("#216DCD"),
                  lenOfStuff: "5",
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
