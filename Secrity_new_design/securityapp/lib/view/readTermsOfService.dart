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

class ReadTermsOfService extends StatefulWidget {
  const ReadTermsOfService({Key key}) : super(key: key);

  @override
  _ReadTermsOfServiceState createState() => _ReadTermsOfServiceState();
}

class _ReadTermsOfServiceState extends State<ReadTermsOfService> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    TermsOfServiceModel termsOfServiceModel =
        Provider.of<TermsOfServiceModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(
          color: themeChange.darkTheme ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        title: Text(
          "قوانین و مقررات",
          style: TextStyle(
            fontFamily: mainFont,
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
                      child: Builder(builder: (context) {
                        if (termsOfServiceModel.termsStatus ==
                            FlowState.Loading)
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
                    fontFamily: mainFont,
                    fontSize: 20.0,
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
