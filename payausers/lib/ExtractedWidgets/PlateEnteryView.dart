import 'package:flutter/material.dart';
import 'package:payausers/ExtractedWidgets/plateEditor.dart';
import 'package:sizer/sizer.dart';

class PlateEntery extends StatelessWidget {
  const PlateEntery({
    this.plate0,
    this.plate0Adder,
    this.plate1,
    this.plate1Adder,
    this.value,
    this.plate2,
    this.plate2Adder,
    this.plate3,
    this.plate3Adder,
  });

  final plate0;
  final Function plate0Adder;
  final plate1;
  final Function plate1Adder;
  final int value;
  final plate2;
  final Function plate2Adder;
  final plate3;
  final Function plate3Adder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20.0.w),
              child: Image.asset(
                "assets/images/plateWriting.png",
                width: 50.0.w,
              ),
            ),
            SizedBox(height: 15.0.w),
            PlateEditor(
              plate0: plate0,
              plate0Adder: plate0Adder,
              plate1: plate1,
              plate1Adder: plate1Adder,
              plate2: plate2,
              plate2Adder: plate2Adder,
              plate3: plate3,
              plate3Adder: plate3Adder,
            ),
          ],
        ),
      ),
    );
  }
}
