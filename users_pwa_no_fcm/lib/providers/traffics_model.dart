import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrafficsModel extends ChangeNotifier {
  FlowState _trafficsState = FlowState.Initial;

  List traffics = [];

  TrafficsModel() {
    _getTraffics();
  }

  FlowState get trafficsState => _trafficsState;
  Future get fetchTrafficsData => _getTraffics();

  Future<void> _getTraffics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");
    ApiAccess api = ApiAccess(userToken);
    _trafficsState = FlowState.Loading;

    try {
      // Getting stucture of endpoint.
      Endpoint userTrafficEndpoint = apiEndpointsMap["getUserTraffic"];
      await Future.delayed(Duration(seconds: 1));
      final trafficsList = await api.requestHandler(
          userTrafficEndpoint.route, userTrafficEndpoint.method, {});

      traffics = trafficsList;
      _trafficsState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from traffics class notifier $e");
      _trafficsState = FlowState.Error;
    }
    notifyListeners();
  }
}
