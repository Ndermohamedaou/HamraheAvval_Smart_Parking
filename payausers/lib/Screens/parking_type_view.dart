import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:payausers/ConstFiles/initialConst.dart';
import 'package:payausers/ExtractedWidgets/custom_text.dart';
import 'package:payausers/ExtractedWidgets/log_loading.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/Model/theme_color.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/controller/flushbar_status.dart';
import 'package:payausers/localization/app_localization.dart';
import 'package:payausers/providers/avatar_model.dart';
import 'package:payausers/providers/public_parking_model.dart';
import 'package:payausers/providers/terms_of_service_model.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:provider/provider.dart';

class ParkingTypeView extends StatefulWidget {
  const ParkingTypeView({Key key}) : super(key: key);

  @override
  _ParkingTypeViewState createState() => _ParkingTypeViewState();
}

class _ParkingTypeViewState extends State<ParkingTypeView> {
  String parkingTypeIdSelected;
  String parkingTypeNameSelected;
  String parkingName;

  @override
  void initState() {
    parkingTypeIdSelected = "";
    parkingTypeNameSelected = "";
    parkingName = "";

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    PublicParkingModel publicParkingModel =
        Provider.of<PublicParkingModel>(context);
    TermsOfServiceModel termsOfServiceModel =
        Provider.of<TermsOfServiceModel>(context);

    AppLocalizations t = AppLocalizations.of(context);
    LogLoading logLoadingWidgets = LogLoading();
    AvatarModel localData = Provider.of<AvatarModel>(context);

    List<DropdownMenuItem<dynamic>> dropdownPublicParkingItemList = [
      DropdownMenuItem(
        value: "1",
        onTap: () => setState(() => parkingTypeNameSelected =
            t.translate("parkingType.organizationParking")),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            CustomText(
              text: t.translate("parkingType.organizationParking"),
              size: 18.0,
            ),
            Icon(Icons.home_work_outlined)
          ],
        ),
      ),
      DropdownMenuItem(
        value: "2",
        onTap: () => setState(() =>
            parkingTypeNameSelected = t.translate("parkingType.publicParking")),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            CustomText(
              text: t.translate("parkingType.publicParking"),
              size: 18.0,
            ),
            Icon(Icons.home_work_outlined)
          ],
        ),
      ),
    ];

    final dropdownPublicParkingListItem =
        publicParkingModel.publicParkings.map((parking) {
      return DropdownMenuItem(
        value: parking,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            CustomText(
              text: parking,
              size: 18.0,
            ),
            Icon(Icons.home_work_outlined)
          ],
        ),
      );
    }).toList();

    submitParkingTypeByUser() async {
      print(localData.userToken);
      if (parkingTypeIdSelected == "" && parkingName == "") {
        showStatusInCaseOfFlush(
            context: context,
            mainBackgroundColor: "#F38137",
            title: t.translate("global.warnings.fillAllFieldsTitle"),
            msg: t.translate("global.warnings.fillAllFieldsDesc"),
            iconColor: Colors.white,
            icon: Icons.close);
      } else {
        ApiAccess api = ApiAccess(localData.userToken);
        Endpoint parkingTypeEndpoint =
            apiEndpointsMap["changeParkingTypeStatus"];
        try {
          final result = await api.requestHandler(
              "${parkingTypeEndpoint.route}?parking_type=$parkingTypeIdSelected&parking_type_fa=$parkingName",
              parkingTypeEndpoint.method, {});

          print(result);

          if (result == "200")
            Navigator.pushNamed(context, "/dashboard");
          else
            showStatusInCaseOfFlush(
                context: context,
                mainBackgroundColor: "#F38137",
                title: t.translate("global.errors.parkingTypeErrorTitle"),
                msg: t.translate("global.errors.parkingTypeErrorDesc"),
                iconColor: Colors.white,
                icon: Icons.close);
        } catch (e) {
          print(e);
          showStatusInCaseOfFlush(
              context: context,
              mainBackgroundColor: "#F38137",
              title: t.translate("global.errors.serverError"),
              msg: t.translate("global.errors.connectionError"),
              iconColor: Colors.white,
              icon: Icons.close);
        }
      }
    }

    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            t.translate("parkingType.title"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: mainFaFontFamily,
              fontSize: subTitleSize,
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          leading: SizedBox(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Builder(
              builder: (BuildContext context) {
                if (publicParkingModel.publicParkingState == FlowState.Loading)
                  return logLoadingWidgets.loading;

                if (publicParkingModel.publicParkingState == FlowState.Error)
                  return logLoadingWidgets.internetProblem;

                return Column(
                  children: [
                    Builder(builder: (context) {
                      if (termsOfServiceModel.termsOfServiceStatus ==
                          FlowState.Loading) return logLoadingWidgets.loading;

                      if (termsOfServiceModel.termsOfServiceStatus ==
                          FlowState.Error)
                        return logLoadingWidgets.internetProblem;

                      return SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, right: 0.0, left: 20.0),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: MarkdownBody(
                              fitContent: true,
                              shrinkWrap: true,
                              data: termsOfServiceModel.termsOfParkingPrimary,
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
                      );
                    }),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        margin:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: DropdownButton(
                          // value: parkingTypeIdSelected,
                          hint: CustomText(
                            text: parkingTypeNameSelected == ""
                                ? t.translate(
                                    "parkingType.dropdownHintParkingType")
                                : parkingTypeNameSelected,
                            size: 18.0,
                          ),
                          isExpanded: true,
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.location_city_outlined,
                            color: mainCTA,
                          ),
                          items: dropdownPublicParkingItemList,
                          onChanged: (parkingTypeId) {
                            setState(
                                () => parkingTypeIdSelected = parkingTypeId);
                          },
                        ),
                      ),
                    ),
                    parkingTypeIdSelected == "2"
                        ? Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: DropdownButton(
                                hint: CustomText(
                                  text: parkingName == ""
                                      ? t.translate(
                                          "parkingType.dropdownHintParkingName")
                                      : parkingName,
                                  size: 18.0,
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                items: dropdownPublicParkingListItem,
                                icon: Icon(
                                  Icons.location_city_outlined,
                                  color: mainCTA,
                                ),
                                // items: dropItemList,
                                onChanged: (parkingNameInDropdown) => setState(
                                    () => parkingName = parkingNameInDropdown),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Material(
                        elevation: 10.0,
                        borderRadius: BorderRadius.circular(8.0),
                        color: mainSectionCTA,
                        child: MaterialButton(
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () => submitParkingTypeByUser(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: t.translate("parkingType.submitParking"),
                                color: Colors.white,
                                size: 20.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
