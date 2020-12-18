import 'package:flutter/material.dart';

class FloorSlots extends StatelessWidget {
  FloorSlots({this.data, this.slotsLen, this.floor});

  final Map data;
  final int slotsLen;
  final int floor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: slotsLen,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              decoration: BoxDecoration(
                  color: data["${floor}"][index]["status"] == 1
                      ? Colors.red
                      : data["${floor}"][index]["status"] == -1
                          ? Colors.orange
                          : data["${floor}"][index]["status"] == 0
                              ? Colors.blue
                              : Colors.white,
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Text("${data["${floor}"][index]["id"]}"),
            ),
          );
        },
      ),
    );
  }
}
