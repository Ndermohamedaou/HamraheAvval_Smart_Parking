import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';

class PlatesModel extends ChangeNotifier {
  FlowState _platesState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  ApiAccess api = ApiAccess();

  List plates = [];

  PlatesModel() {
    _getPlates();
  }

  FlowState get platesState => _platesState;
  Future get fetchPlatesData => _getPlates();

  Future<void> _getPlates() async {
    final userToken = await lStorage.read(key: "token");
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
