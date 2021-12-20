import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:provider/provider.dart';

class ReadTermsOfService extends StatefulWidget {
  const ReadTermsOfService({Key key}) : super(key: key);

  @override
  _ReadTermsOfServiceState createState() => _ReadTermsOfServiceState();
}

class _ReadTermsOfServiceState extends State<ReadTermsOfService> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        title: Text(
          "قوانین و مقررات",
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            color: themeChange.darkTheme ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppBarAsNavigate(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: MarkdownBody(
                          data: terms,
                          styleSheet: MarkdownStyleSheet.fromTheme(
                            ThemeData(
                              textTheme: TextTheme(
                                bodyText1: TextStyle(
                                    fontSize: 15.0,
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: mainFaFontFamily),
                                bodyText2: TextStyle(
                                    fontSize: 15.0,
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: mainFaFontFamily),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                    fontFamily: mainFaFontFamily,
                    fontSize: subTitleSize,
                    fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.verified_user_outlined,
                color: Colors.grey.shade400,
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "$termsLastUpdate ${DateTime.now().year}",
                style: TextStyle(
                    fontFamily: mainFaFontFamily,
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
