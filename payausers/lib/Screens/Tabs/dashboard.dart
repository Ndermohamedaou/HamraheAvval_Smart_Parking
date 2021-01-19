import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/dashboardTiles.dart';
import 'package:payausers/ExtractedWidgets/userLeading.dart';

class Dashboard extends StatelessWidget {
  const Dashboard(
      {this.fullnameMeme, this.userPersonalCodeMeme, this.avatarMeme});
  final String fullnameMeme;
  final String userPersonalCodeMeme;
  final Widget avatarMeme;

  @override
  Widget build(BuildContext context) {
    // Create Responsive Grid Container view
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 4;
    final double itemWidth = size.width;
    // Check if device be in Portrate or Landscape
    final double widthSizedResponse = size.width < 500
        ? (itemWidth / itemHeight) / 2.49
        : (itemWidth / itemHeight) / 6.5;

    print(size.width);

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
            height: 20,
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
                    Icons.trending_up_sharp,
                    color: Colors.blue,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: bgColorTrendingUp),
                ),
                Text(
                  todayWeather,
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
                  text: "تعداد",
                  subText: "کل ترددها",
                  subSubText: "امروز",
                  subSubTextColor: HexColor("#AC292E"),
                  lenOfStuff: "20",
                ),
                DashboardTiles(
                  tileColor: "#EDE5FC",
                  icon: Icons.book,
                  iconColor: HexColor("#6C2BDF"),
                  text: "تعداد",
                  subText: "کل رزروها",
                  subSubText: "تا به امروز",
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
                  text: "تعداد",
                  subText: "پلاک های شما",
                  subSubText: "پلاک هایی که در \n سامانه ثبت کرده اید",
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
