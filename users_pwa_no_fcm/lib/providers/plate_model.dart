import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatesModel extends ChangeNotifier {
  FlowState _platesState = FlowState.Initial;

  List plates = [];

  PlatesModel() {
    _getPlates();
  }

  FlowState get platesState => _platesState;
  Future get fetchPlatesData => _getPlates();

  Future<void> _getPlates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");
    // Getting api broker.
    ApiAccess api = ApiAccess(userToken);

    _platesState = FlowState.Loading;
    try {
      Endpoint userPlate = apiEndpointsMap["plateEndpoint"]["getUserPlates"];
      await Future.delayed(Duration(seconds: 1));
      // Getting data.
      final plateList =
          await api.requestHandler(userPlate.route, userPlate.method, {});
      plates = plateList;
      _platesState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from plates notifier $e");
      _platesState = FlowState.Error;
    }

    notifyListeners();
  }
}
