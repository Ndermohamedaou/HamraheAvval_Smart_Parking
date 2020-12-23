import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:securityapp/constFile/ConstFile.dart';
import 'package:securityapp/constFile/texts.dart';
import 'package:toast/toast.dart';

class FloorSlots extends StatelessWidget {
  FloorSlots({this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data['floors'].length,
          itemBuilder: (BuildContext context, int item) {
            return Column(
              children: [
                Text("${data["floors"][item]} طبقه ",
                    style: TextStyle(fontFamily: mainFontFamily, fontSize: 25)),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: data[data["floors"][item]].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Toast.show(
                            "${data[data["floors"][item]][index]["floor"]}: طبقه"
                            "\n"
                            "${data[data["floors"][item]][index]["id"]}: شناسه"
                            "\n"
                            " وضعیت جایگاه : ${data[data["floors"][item]][index]["status"] == -1 ? "رزور" : data[data["floors"][item]][index]["status"] == 0 ? "خالی" : "پر"}",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                            textColor: Colors.white);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                        decoration: BoxDecoration(
                            color:
                                data[data["floors"][item]][index]["status"] == 1
                                    ? Colors.red
                                    : data[data["floors"][item]][index]
                                                ["status"] ==
                                            -1
                                        ? Colors.orange
                                        : data[data["floors"][item]][index]
                                                    ["status"] ==
                                                0
                                            ? Colors.blue
                                            : Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: data[data["floors"][item]][index]["status"] == 1
                            ? Image.asset("assets/images/car1.png")
                            : data[data["floors"][item]][index]["status"] == 0
                                ? Container(
                                    child: Text(
                                      'P',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40),
                                    ),
                                  )
                                : Icon(CupertinoIcons.map_pin_ellipse),
                        // Text("${data[data["floors"][item]][index]["id"]}")
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
