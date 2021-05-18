import 'package:flutter/material.dart';
import 'package:payausers/ConstFiles/initialConst.dart';

class InstantReservePage extends StatefulWidget {
  @override
  _InstantReservePageState createState() => _InstantReservePageState();
}

class _InstantReservePageState extends State<InstantReservePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "رزرو لحظه ای",
          style: TextStyle(fontFamily: mainFaFontFamily),
        ),
        backgroundColor: mainCTA,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
