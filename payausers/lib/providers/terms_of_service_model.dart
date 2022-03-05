import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';

class TermsOfServiceModel extends ChangeNotifier {
  FlowState _termsOfServiceStatus = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  dynamic termsOfService = "";
  dynamic termsOfParkingPrimary = "";

  TermsOfServiceModel() {
    _getTermsOfService();
  }

  FlowState get termsOfServiceStatus => _termsOfServiceStatus;
  Future get fetchingTermsOfService => _getTermsOfService();

  Future<void> _getTermsOfService() async {
    final userToken = await lStorage.read(key: "token");
    ApiAccess api = ApiAccess(userToken);
    _termsOfServiceStatus = FlowState.Loading;

    try {
      // Wait for a second for getting safe data.
      await Future.delayed(Duration(seconds: 1));
      final theTermsOfService = await api.requestHandler(
          "https://smartparking.mci.ir/parking_tos.md", "GET", {});

      final parkingTypesData = await api.requestHandler(
          "https://smartparking.mci.ir/parking_types.md", "GET", {});

      termsOfService = theTermsOfService;
      termsOfParkingPrimary = parkingTypesData;

      _termsOfServiceStatus = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from terms of service notifier $e");
      _termsOfServiceStatus = FlowState.Error;
    }
    notifyListeners();
  }
}
