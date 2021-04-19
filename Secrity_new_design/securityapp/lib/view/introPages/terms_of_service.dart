import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';

class Terms extends StatelessWidget {
  const Terms({
    this.themeChange,
    this.acceptedTerms,
    this.setCheckTerms,
  });

  final bool themeChange;
  final bool acceptedTerms;
  final Function setCheckTerms;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AppBarAsNavigate(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: MarkdownBody(
                        data: terms,
                        styleSheet: MarkdownStyleSheet.fromTheme(ThemeData(
                            textTheme: TextTheme(
                                body1: TextStyle(
                                    fontSize: 18.0,
                                    color: themeChange
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: mainFont)))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: CheckboxListTile(
                activeColor: mainCTA,
                title: Text(
                  "تمام شرایط را می پذیرم",
                  style: TextStyle(fontFamily: mainFont),
                ),
                value: acceptedTerms,
                onChanged: setCheckTerms),
          ),
        ],
      ),
    );
  }
}

class AppBarAsNavigate extends StatelessWidget {
  const AppBarAsNavigate({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                termsAndLicense,
                style: TextStyle(
                    fontFamily: mainFont,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.verified_user_outlined,
                color: Colors.grey.shade400,
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "${termsLastUpdate} ${DateTime.now().year}",
                style: TextStyle(
                    fontFamily: mainFont,
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ]),
            Divider(
              height: 50,
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}
