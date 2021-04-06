import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dashboardTiles.dart';
import 'package:payausers/ExtractedWidgets/userCard.dart';
import 'package:payausers/ExtractedWidgets/userLeading.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    this.openUserDashSettings,
    this.fullnameMeme,
    this.userPersonalCodeMeme,
    this.avatarMeme,
    this.temporarLogo,
    this.userQRCode,
    this.section,
    this.role,
    this.userPlateNumber,
    this.userTrafficNumber,
    this.userReserveNumber,
    this.lastLogin,
  });
  final Function openUserDashSettings;
  final String fullnameMeme;
  final String userPersonalCodeMeme;
  final String avatarMeme;
  final String userQRCode;
  final String temporarLogo;
  final String section;
  final String role;
  final String userPlateNumber;
  final String userTrafficNumber;
  final String userReserveNumber;
  final String lastLogin;

  @override
  Widget build(BuildContext context) {
    // print("avatar in Dashboard: $avatarMeme");
    // Create Responsive Grid Container view
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 4;
    final double itemWidth = size.width;
    // Check if device be in portrait or Landscape
    final double widthSizedResponse = size.width >= 410 && size.width < 600
        ? (itemWidth / itemHeight) / 3
        : size.width >= 390 && size.width <= 409
            ? (itemWidth / itemHeight) / 2.4
            : size.width <= 380
                ? (itemWidth / itemHeight) / 3.2
                : size.width > 1000
                    ? (itemWidth / itemHeight) / 6
                    : size.width >= 700 && size.width < 1000
                        ? (itemWidth / itemHeight) / 6
                        : (itemWidth / itemHeight) / 5;

    final countGridItem = size.width > 1000 ? 4 : 2;

    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          // User Summery details on dashboard screen
          Directionality(
            textDirection: TextDirection.rtl,
            child: UserLeading(
              imgPressed: openUserDashSettings,
              fullname: fullnameMeme,
              userPersonalCode: userPersonalCodeMeme,
              avatarImg: avatarMeme,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          UserCard(
            qrCodeString: qrUserCode,
            fullname: fullnameMeme,
            persCode: userPersonalCodeMeme,
            lastVisit: lastLogin,
          ),

          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: GridView.count(
              crossAxisCount: countGridItem,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: widthSizedResponse,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                DashboardTiles(
                  tileColor: [trafficsTileC1, trafficsTileC2],
                  icon: Icons.directions_car,
                  iconColor: trafficsTileC1,
                  text: qty,
                  subText: transactionsText,
                  subSubText: untilTodayText,
                  subSubTextColor: HexColor("#AC292E"),
                  lenOfStuff: userTrafficNumber,
                ),
                DashboardTiles(
                  tileColor: [reservesTileC1, reservesTileC2],
                  icon: Icons.book,
                  iconColor: reservesTileC1,
                  text: qty,
                  subText: allReserveText,
                  subSubText: untilTodayText,
                  subSubTextColor: Colors.white,
                  lenOfStuff: userReserveNumber,
                ),
                DashboardTiles(
                  tileColor: [currentLocationTileC1, currentLocationTileC2],
                  icon: Icons.account_balance,
                  iconColor: currentLocationTileC1,
                  text: "موقعیت",
                  subText: "جایگاه",
                  subSubText: role,
                  subSubTextColor: currentLocationTileC1,
                  lenOfStuff: section,
                ),
                DashboardTiles(
                  tileColor: [userPlateNumberTileC1, userPlateNumberTileC2],
                  icon: Icons.layers_sharp,
                  iconColor: userPlateNumberTileC1,
                  text: qty,
                  subText: yourPlateText,
                  subSubText: inSystemText,
                  subSubTextColor: HexColor("#216DCD"),
                  lenOfStuff: userPlateNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
