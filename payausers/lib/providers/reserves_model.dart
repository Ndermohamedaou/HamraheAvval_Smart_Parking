import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';

class ReservesModel extends ChangeNotifier {
  FlowState _reserveState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  Map reserves = {};

  ReservesModel() {
    _getReserves();
  }

  FlowState get reserveState => _reserveState;
  Future get fetchReservesData => _getReserves();

  Future<void> _getReserves() async {
    final userToken = await lStorage.read(key: "token");
    ApiAccess api = ApiAccess(userToken);
    _reserveState = FlowState.Loading;

    try {
      Endpoint userReserves =
          apiEndpointsMap["reserveEndpoint"]["getUserReserves"];
      // Wait for a second for getting safe data.
      await Future.delayed(Duration(seconds: 1));
      final regularReserves =
          await api.requestHandler(userReserves.route, userReserves.method, {});
      reserves = regularReserves;
      _reserveState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _reserveState = FlowState.Error;
    }
    notifyListeners();
  }
}
