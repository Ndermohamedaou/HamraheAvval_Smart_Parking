import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReserveWeeks extends ChangeNotifier {
  // Flow state for loading, loaded, error.
  FlowState _reserveWeeksState = FlowState.Initial;
  // Final list of weeks reserves.
  Map finalReserveWeeks = {};

  ReserveWeeks() {
    _getReserveWeeks();
  }

  FlowState get reserveWeeksState => _reserveWeeksState;
  Future get fetchReserveWeeks => _getReserveWeeks();

  Future<void> _getReserveWeeks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");
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
