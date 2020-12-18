import 'package:flutter/material.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'package:securityapp/constFile/ConstFile.dart';

class FloorSlots extends StatelessWidget {
  FloorSlots({this.data});

  final Map data;

  int floorStepper = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int item) {
            return Column(
              children: [
                Text(" ${item + 1} طبقه ",
                    style: TextStyle(fontFamily: mainFontFamily, fontSize: 25)),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: data["${item + 1}"].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                        decoration: BoxDecoration(
                            color: data["${item + 1}"][index]["status"] == 1
                                ? Colors.red
                                : data["${item + 1}"][index]["status"] == -1
                                    ? Colors.orange
                                    : data["${item + 1}"][index]["status"] == 0
                                        ? Colors.blue
                                        : Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        child: Text("${data["${item + 1}"][index]["id"]}"),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ));
  }
}
