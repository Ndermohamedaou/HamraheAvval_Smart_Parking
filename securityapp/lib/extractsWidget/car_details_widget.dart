import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:securityapp/classes/SharedClass.dart';
import 'package:securityapp/constFile/ConstFile.dart';

// Per Image Shower
// ignore: camel_case_types
class imgShower extends StatelessWidget {
  imgShower({this.path});

  final Image path;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: path
    );
  }
}

class PageViewContainer extends StatelessWidget {
  PageViewContainer({this.imgPath});

  final List<Widget> imgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: PageView(
        children: imgPath,
      ),
    );
  }
}

// Graphical Plate
// class GraphicalPlate extends StatelessWidget {
//   GraphicalPlate(
//       {this.plate0, this.plate1, this.plate2, this.plate3});
//
//   final plate0;
//   final plate1;
//   final plate2;
//   final plate3;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 70,
//       // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       margin: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 5),
//       decoration: BoxDecoration(
//           border: Border.all(
//               color: themeChange.darkTheme ? Colors.white : Colors.black,
//               width: 2.8),
//           borderRadius: BorderRadius.circular(8)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             width: 50,
//             height: 70,
//             decoration: BoxDecoration(
//               color: Colors.blue[900],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(height: 2),
//                 Image.asset(
//                   "assets/images/iranFlag.png",
//                   width: 35,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'I.R.',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     Text(
//                       'I R A N',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 50,
//             height: 70,
//             margin: EdgeInsets.only(top: 0),
//             child: TextFormField(
//               showCursor: false,
//               style: TextStyle(
//                   fontSize: 26,
//                   fontFamily: mainFontFamily,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//               initialValue: plate0,
//               decoration:
//                   InputDecoration(counterText: "", border: InputBorder.none),
//               maxLength: 2,
//               readOnly: true,
//             ),
//           ),
//           Container(
//               width: 50,
//               height: 70,
//               margin: EdgeInsets.only(top: 5),
//               child: Text(
//                 plate1,
//                 style: TextStyle(
//                     fontSize: 40,
//                     fontFamily: mainFontFamily,
//                     fontWeight: FontWeight.bold),
//               )),
//           Container(
//             width: 50,
//             height: 70,
//             margin: EdgeInsets.only(top: 0, right: 0),
//             child: TextFormField(
//               initialValue: plate2,
//               style: TextStyle(
//                   fontSize: 26,
//                   fontFamily: mainFontFamily,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//               decoration:
//                   InputDecoration(counterText: "", border: InputBorder.none),
//               maxLength: 3,
//               readOnly: true,
//             ),
//           ),
//           VerticalDivider(
//               width: 1,
//               color: themeChange.darkTheme ? Colors.white : Colors.black,
//               thickness: 3),
//           Container(
//             width: 50,
//             height: 70,
//             margin: EdgeInsets.only(top: 0, right: 10),
//             child: TextFormField(
//               initialValue: plate3,
//               style: TextStyle(
//                   fontSize: 26,
//                   fontFamily: mainFontFamily,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//               decoration:
//                   InputDecoration(counterText: "", border: InputBorder.none),
//               maxLength: 2,
//               readOnly: true,
//             ),
//           ),
//         ],
//         crossAxisAlignment: CrossAxisAlignment.center,
//         textBaseline: TextBaseline.alphabetic,
//       ),
//     );
//   }
// }
