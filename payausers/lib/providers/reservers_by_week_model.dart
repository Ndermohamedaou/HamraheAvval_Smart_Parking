import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';

class ReservesByWeek extends ChangeNotifier {
  // Flow state for loading, loaded, error.
  FlowState stateReservesByWeekState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  // Final list of weeks reserves.
  List reservesList = [];
  String startDate = "";

  FlowState get reservesByWeekState => stateReservesByWeekState;
  Future get fetchReserveWeeks => _reservesByWeek();

  // Setter date for getting all reserver by start week.
  set setStartDate(String date) {
    startDate = date;
    _reservesByWeek();
    notifyListeners();
  }

  Future<void> _reservesByWeek() async {
    final userToken = await lStorage.read(key: "token");
    ApiAccess api = ApiAccess(userToken);
    stateReservesByWeekState = FlowState.Loading;

    try {
      // Getting Endpoint class of userReservesByWeek.
      Endpoint getUserReservesByWeek =
          apiEndpointsMap["reserveEndpoint"]["getUserReservesByWeek"];
      await Future.delayed(Duration(seconds: 1));
      // Getting data.
      final reserversOfWeek = await api.requestHandler(
          "${getUserReservesByWeek.route}?week=$startDate",
          getUserReservesByWeek.method, {});

      reservesList = reserversOfWeek;
      stateReservesByWeekState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      stateReservesByWeekState = FlowState.Error;
    }
    notifyListeners();
  }
}
