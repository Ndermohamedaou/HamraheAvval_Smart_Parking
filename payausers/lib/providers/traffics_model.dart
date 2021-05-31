import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';

class TrafficsModel extends ChangeNotifier {
  FlowState _trafficsState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  ApiAccess api = ApiAccess();

  List traffics = [];

  TrafficsModel() {
    _getTraffics();
  }

  FlowState get trafficsState => _trafficsState;
  Future get fetchTrafficsData => _getTraffics();

  Future<void> _getTraffics() async {
    final userToken = await lStorage.read(key: "token");
    _trafficsState = FlowState.Loading;
    try {
      Future.delayed(Duration(seconds: 2));
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
