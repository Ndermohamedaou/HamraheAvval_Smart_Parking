import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';

class ReserveWeeks extends ChangeNotifier {
  // Flow state for loading, loaded, error.
  FlowState _reserveWeeksState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  // Final list of weeks reserves.
  List finalReserveWeeks = [];

  ReserveWeeks() {
    _getReserveWeeks();
  }

  FlowState get reserveWeeksState => _reserveWeeksState;
  Future get fetchReserveWeeks => _getReserveWeeks();

  Future<void> _getReserveWeeks() async {
    final userToken = await lStorage.read(key: "token");
    ApiAccess api = ApiAccess(userToken);
    _reserveWeeksState = FlowState.Loading;

    try {
      Endpoint reserveWeeks =
          apiEndpointsMap["reserveEndpoint"]["getReserveWeeks"];
      await Future.delayed(Duration(seconds: 1));
      final getReserveWeeks =
          await api.requestHandler(reserveWeeks.route, reserveWeeks.method, {});
      finalReserveWeeks = getReserveWeeks;
      _reserveWeeksState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _reserveWeeksState = FlowState.Error;
    }
    notifyListeners();
  }
}
