import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatesModel extends ChangeNotifier {
  FlowState _platesState = FlowState.Initial;
  ApiAccess api = ApiAccess();

  List plates = [];

  PlatesModel() {
    _getPlates();
  }

  FlowState get platesState => _platesState;
  Future get fetchPlatesData => _getPlates();

  Future<void> _getPlates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");

    _platesState = FlowState.Loading;
    try {
      await Future.delayed(Duration(seconds: 2));
      final plateList = await api.getUserPlate(token: userToken);
      plates = plateList;
      _platesState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from plates notifier $e");
      _platesState = FlowState.Error;
    }
    notifyListeners();
  }
}
