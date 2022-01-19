import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey,
      thickness: 1,
      indent: 20,
      height: 10,
    );
  }
}
