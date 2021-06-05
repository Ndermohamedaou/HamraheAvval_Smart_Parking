import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservesModel extends ChangeNotifier {
  FlowState _reserveState = FlowState.Initial;
  ApiAccess api = ApiAccess();
  List reserves = [];

  ReservesModel() {
    _getReserves();
  }

  FlowState get reserveState => _reserveState;
  Future get fetchReservesData => _getReserves();

  Future<void> _getReserves() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");

    _reserveState = FlowState.Loading;
    try {
      await Future.delayed(Duration(seconds: 2));
      final regularReserves = await api.userReserveHistory(token: userToken);
      reserves = regularReserves;
      _reserveState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _reserveState = FlowState.Error;
    }
    notifyListeners();
  }
}
