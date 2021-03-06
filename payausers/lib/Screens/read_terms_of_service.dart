import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/log_loading.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/terms_of_service_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

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
    LogLoading logLoadingWidgets = LogLoading();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultAppBarColor,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          "قوانین و مقررات",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: mainFaFontFamily,
            color: Colors.black,
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
                        if (termsOfServiceModel.termsOfServiceStatus ==
                            FlowState.Loading) return logLoadingWidgets.loading;

                        if (termsOfServiceModel.termsOfServiceStatus ==
                            FlowState.Error)
                          return logLoadingWidgets.internetProblem;

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
    AppLocalizations t = AppLocalizations.of(context);
    // Getting now date time in jalali DateTime.
    Jalali now = Jalali.now();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                t.translate("terms.termsOfServiceTitle"),
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
                "${t.translate("terms.termsLastUpdate")} ${now.year}",
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
