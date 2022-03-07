import 'package:flutter/material.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:provider/provider.dart';

class FilterMenu extends StatelessWidget {
  const FilterMenu({
    this.text,
    this.filterPressed,
  });

  final String text;
  final Function filterPressed;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return TextButton(
        onPressed: filterPressed,
        clipBehavior: Clip.hardEdge,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: themeChange.darkTheme ? Colors.white : Colors.black,
                    fontFamily: mainFaFontFamily,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
