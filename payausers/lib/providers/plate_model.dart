import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';

class PlatesModel extends ChangeNotifier {
  FlowState _platesState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
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
      // Getting api broker.
      ApiAccess api = ApiAccess(userToken);
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
