import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';

class TrafficsModel extends ChangeNotifier {
  FlowState _trafficsState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();

  List traffics = [];

  TrafficsModel() {
    _getTraffics();
  }

  FlowState get trafficsState => _trafficsState;
  Future get fetchTrafficsData => _getTraffics();

  Future<void> _getTraffics() async {
    final userToken = await lStorage.read(key: "token");
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
