import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrafficsModel extends ChangeNotifier {
  FlowState _trafficsState = FlowState.Initial;
  ApiAccess api = ApiAccess();

  List traffics = [];

  TrafficsModel() {
    _getTraffics();
  }

  FlowState get trafficsState => _trafficsState;
  Future get fetchTrafficsData => _getTraffics();

  Future<void> _getTraffics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");

    _trafficsState = FlowState.Loading;
    try {
      await Future.delayed(Duration(seconds: 2));
      final trafficsList = await api.getUserTrafficLogs(token: userToken);
      traffics = trafficsList;
      _trafficsState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from traffics class notifier $e");
      _trafficsState = FlowState.Error;
    }
    notifyListeners();
  }
}
