import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReserveWeeks extends ChangeNotifier {
  // Flow state for loading, loaded, error.
  FlowState _reserveWeeksState = FlowState.Initial;
  ApiAccess api = ApiAccess();
  // Final list of weeks reserves.
  List finalReserveWeeks = [];

  ReserveWeeks() {
    _getReserveWeeks();
  }

  FlowState get reserveWeeksState => _reserveWeeksState;
  Future get fetchReserveWeeks => _getReserveWeeks();

  Future<void> _getReserveWeeks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");
    _reserveWeeksState = FlowState.Loading;

    try {
      await Future.delayed(Duration(seconds: 2));
      final reserveWeeks = await api.reserveWeeks(token: userToken);
      print(reserveWeeks);
      finalReserveWeeks = reserveWeeks;
      _reserveWeeksState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _reserveWeeksState = FlowState.Error;
    }
    notifyListeners();
  }
}
