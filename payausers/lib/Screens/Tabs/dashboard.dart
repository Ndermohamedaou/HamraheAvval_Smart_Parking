import 'package:payausers/ExtractedWidgets/dashboardTiles/Tiles.dart';
import 'package:payausers/ExtractedWidgets/userCard.dart';
import 'package:payausers/controller/gettingLocalData.dart';
import 'package:payausers/Classes/streamAPI.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    this.openUserDashSettings,
  });
  final Function openUserDashSettings;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AutomaticKeepAliveClientMixin<Dashboard> {
  LocalDataGetterClass localDataGetterClass = LocalDataGetterClass();
  StreamAPI streamAPI = StreamAPI();
  GridTiles gridTile = GridTiles();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Create Responsive Grid Container view
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 4;
    final double itemWidth = size.width;
    LocalDataGetterClass loadLocalData = LocalDataGetterClass();

    // Check if device be in portrait or Landscape
    final double widthSizedResponse = size.width >= 410 && size.width < 600
        ? (itemWidth / itemHeight) / 3
        : size.width >= 390 && size.width <= 409
            ? (itemWidth / itemHeight) / 2.4
            : size.width <= 380
                ? (itemWidth / itemHeight) / 3.2
                : size.width >= 700 && size.width < 1000
                    ? (itemWidth / itemHeight) / 6
                    : (itemWidth / itemHeight) / 2.0.w;

    Widget userLeadingCircleAvatar(avatar) => GestureDetector(
          onTap: widget.openUserDashSettings,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                ),
              ],
            ),
          ),
        );

    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: loadLocalData.getLocalUserAvatar(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return userLeadingCircleAvatar(snapshot.data);
              } else if (snapshot.hasError) {
                return userLeadingCircleAvatar("");
              } else {
                return userLeadingCircleAvatar("");
              }
            },
          ),
          SizedBox(height: 10),
          FutureBuilder(
            future: loadLocalData.getStaffInfoFromLocal(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return UserCard(
                  qrCodeString: snapshot.data['userId'],
                  fullname: snapshot.data['name'],
                  persCode: snapshot.data['personalCode'],
                  lastVisit: "${snapshot.data['lastLogin']}",
                );
              } else if (snapshot.hasError) {
                return UserCard(
                  qrCodeString: "-",
                  fullname: "-",
                  persCode: "-",
                  lastVisit: "Error",
                );
              } else {
                return UserCard(
                  qrCodeString: "-",
                  fullname: "-",
                  persCode: "-",
                  lastVisit: "-",
                );
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(4.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: widthSizedResponse,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Traffics Tile
                StreamBuilder(
                  stream: streamAPI.getUserTrafficsReal(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData) {
                      // print(snapshot.data.length);
                      return gridTile.trafficsTile("${snapshot.data.length}");
                    } else if (snapshot.hasError)
                      return gridTile.trafficsTile("-");
                    else
                      return gridTile.trafficsTile("0");
                  },
                ),
                // reserve tile
                StreamBuilder(
                  stream: streamAPI.getUserReserveReal(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData)
                      return gridTile.reserveTile("${snapshot.data.length}");
                    else
                      return gridTile.reserveTile("-");
                  },
                ),
                // Vehicle Situation
                StreamBuilder(
                  stream: localDataGetterClass.getUserInfoInReal(),
                  builder: (BuildContext context, snapshot) {
                    // print("YOUR CAR IS :: ${snapshot.data}");
                    if (snapshot.hasData) {
                      try {
                        return gridTile.situationTile(
                            "${snapshot.data["location"]["slot"]}",
                            "${snapshot.data["location"]["building"]}");
                      } catch (e) {
                        return gridTile.situationTile(
                            "", "${snapshot.data["location"]}");
                      }
                    } else
                      return gridTile.situationTile("-", "-");
                  },
                ),
                // user len plate
                StreamBuilder(
                  stream: streamAPI.getUserPlatesReal(),
                  builder: (BuildContext context, snapshot) {
                    // print("YOUR PLATE IS :: ${snapshot.data}");
                    if (snapshot.hasData)
                      return gridTile.plateTile("${snapshot.data.length}");
                    else
                      return gridTile.plateTile("-");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
