import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:securityapp/constFile/initStrings.dart';
import 'package:securityapp/constFile/initVar.dart';
import 'package:securityapp/model/classes/ThemeColor.dart';
import 'package:securityapp/provider/term_of_service_model.dart';
import 'package:securityapp/spec/FlowState.dart';
import 'package:securityapp/widgets/CustomText.dart';

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
    final themeChange = Provider.of<DarkThemeProvider>(context);
    TermsOfServiceModel termsOfServiceModel =
        Provider.of<TermsOfServiceModel>(context);

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
                    child: Builder(builder: (context) {
                      if (termsOfServiceModel.termsStatus == FlowState.Loading)
                        return CupertinoActivityIndicator();

                      if (termsOfServiceModel.termsStatus == FlowState.Error)
                        return CustomText(text: "خطا");

                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: MarkdownBody(
                          data: termsOfServiceModel.termsOfService,
                          styleSheet: MarkdownStyleSheet.fromTheme(
                            ThemeData(
                              textTheme: TextTheme(
                                bodyText1: TextStyle(
                                    fontSize: 15.0,
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: mainFont),
                                bodyText2: TextStyle(
                                    fontSize: 15.0,
                                    color: themeChange.darkTheme
                                        ? Colors.white
                                        : Colors.black,
                                    fontFamily: mainFont),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
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
