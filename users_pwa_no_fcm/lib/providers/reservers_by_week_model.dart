import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservesByWeek extends ChangeNotifier {
  // Flow state for loading, loaded, error.
  FlowState _reservesByWeekState = FlowState.Initial;
  ApiAccess api = ApiAccess();
  // Final list of weeks reserves.
  List reservesList = [];
  String startDate = "";

  FlowState get reservesByWeekState => _reservesByWeekState;
  Future get fetchReserveWeeks => _reservesByWeek();

  // Setter date for getting all reserver by start week.
  set setStartDate(String date) {
    startDate = date;
    _reservesByWeek();
    notifyListeners();
  }

  Future<void> _reservesByWeek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");
    _reservesByWeekState = FlowState.Loading;

    try {
      await Future.delayed(Duration(seconds: 2));
      final reserversOfWeek = await api.userReservesByWeeks(
          token: userToken, startWeekDate: startDate);
      reservesList = reserversOfWeek;
      _reservesByWeekState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _reservesByWeekState = FlowState.Error;
    }
    notifyListeners();
  }
}
