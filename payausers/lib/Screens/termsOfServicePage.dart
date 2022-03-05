import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:payausers/ExtractedWidgets/logLoading.dart';
import 'package:payausers/Model/ThemeColor.dart';
import 'package:payausers/ConstFiles/constText.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/bottomBtnNavigator.dart';
import 'package:payausers/providers/terms_of_service_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

bool acceptedTerms = false;

class TermsOfServiceView extends StatefulWidget {
  @override
  _TermsOfServiceViewState createState() => _TermsOfServiceViewState();
}

class _TermsOfServiceViewState extends State<TermsOfServiceView> {
  @override
  void initState() {
    acceptedTerms = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    TermsOfServiceModel termsOfServiceModel =
        Provider.of<TermsOfServiceModel>(context);
    LogLoading logLoadingWidgets = LogLoading();

    void goToLogin() => Navigator.pushNamed(context, '/login');

    return Scaffold(
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
            Directionality(
              textDirection: TextDirection.rtl,
              child: CheckboxListTile(
                  activeColor: mainSectionCTA,
                  title: Text(
                    acceptAllTermsOfService,
                    style: TextStyle(fontFamily: mainFaFontFamily),
                  ),
                  value: acceptedTerms,
                  onChanged: (value) => setState(() => acceptedTerms = value)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButton(
        color: mainCTA,
        text: acceptedTerms ? finalLoginText : mustAcceptTerms,
        hasCondition: acceptedTerms,
        onTapped: goToLogin,
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
                "$termsLastUpdate ${now.year}",
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
