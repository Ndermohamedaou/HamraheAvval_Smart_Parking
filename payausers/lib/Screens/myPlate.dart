import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/Classes/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:payausers/ExtractedWidgets/plateViwer.dart';
import 'package:provider/provider.dart';

List userPlates = [];

class MYPlateScreen extends StatefulWidget {
  @override
  _MYPlateScreenState createState() => _MYPlateScreenState();
}

class _MYPlateScreenState extends State<MYPlateScreen> {
  @override
  void initState() {
    super.initState();

    gettingMyPlates().then((plate) {
      setState(() {
        userPlates = plate;
      });
    });
  }

  Future<List> gettingMyPlates() async {
    ApiAccess api = ApiAccess();
    FlutterSecureStorage lds = FlutterSecureStorage();
    final userToken = await lds.read(key: "token");
    final plates = await api.getUserPlate(token: userToken);
    return plates;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Widget plates = Column(
      children: [
        Lottie.asset("assets/lottie/loadingUserPlate.json"),
        CarouselSlider(
          options: CarouselOptions(
              height: 90.0,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: false),
          items: userPlates.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  // decoration: BoxDecoration(color: Colors.amber),
                  child: PlateViewer(
                    plate0: i['plate0'],
                    plate1: i['plate1'],
                    plate2: i['plate2'],
                    plate3: i['plate3'],
                    themeChange: themeChange.darkTheme
                  ),
                );
              },
            );
          }).toList(),
        )
      ],
    );

    Widget searchingProcess = Column(
      children: [
        Lottie.asset("assets/lottie/searching.json"),
        Text(searchingProcessText,
            style: TextStyle(fontFamily: mainFaFontFamily, fontSize: 18)),
      ],
    );

    final plateContext = userPlates.isEmpty ? searchingProcess : plates;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_rounded)
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        myPlateText,
                        style: TextStyle(
                            fontFamily: mainFaFontFamily,
                            fontSize: subTitleSize),
                      ),
                    ),
                  ],
                ),
              ),
              plateContext
            ],
          ),
        ),
      ),
    );
  }
}
