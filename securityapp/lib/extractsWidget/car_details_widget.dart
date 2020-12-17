import 'package:flutter/material.dart';

// Per Image Shower
// ignore: camel_case_types
class imgShower extends StatelessWidget {
  imgShower({this.path});

  final Image path;

  @override
  Widget build(BuildContext context) {
    return Container(child: path);
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
