import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dashboardTiles.dart';

class GridTiles {
  Widget trafficsTile(trafficsLen) => DashboardTiles(
        tileColor: [trafficsTileC1, trafficsTileC2],
        icon: Icons.directions_car,
        iconColor: trafficsTileC1,
        text: qty,
        subText: transactionsText,
        subSubText: untilTodayText,
        subSubTextColor: HexColor("#AC292E"),
        lenOfStuff: trafficsLen,
      );
  Widget reserveTile(reserveLen) => DashboardTiles(
        tileColor: [reservesTileC1, reservesTileC2],
        icon: Icons.book,
        iconColor: reservesTileC1,
        text: qty,
        subText: allReserveText,
        subSubText: untilTodayText,
        subSubTextColor: Colors.white,
        lenOfStuff: reserveLen,
      );
  Widget situationTile(role, section) => DashboardTiles(
        tileColor: [currentLocationTileC1, currentLocationTileC2],
        icon: Icons.account_balance,
        iconColor: currentLocationTileC1,
        text: "موقعیت",
        subText: "جایگاه",
        subSubText: role,
        subSubTextColor: currentLocationTileC1,
        lenOfStuff: section,
      );

  Widget plateTile(plateLen) => DashboardTiles(
        tileColor: [userPlateNumberTileC1, userPlateNumberTileC2],
        icon: Icons.layers_sharp,
        iconColor: userPlateNumberTileC1,
        text: qty,
        subText: yourPlateText,
        subSubText: inSystemText,
        subSubTextColor: HexColor("#216DCD"),
        lenOfStuff: plateLen,
      );
}
