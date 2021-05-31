import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Classes/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';

class ReservesModel extends ChangeNotifier {
  FlowState _reserveState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  ApiAccess api = ApiAccess();
  List reserves = [];

  ReservesModel() {
    _getReserves();
  }

  FlowState get reserveState => _reserveState;
  Future get fetchReservesData => _getReserves();

  Future<void> _getReserves() async {
    final userToken = await lStorage.read(key: "token");
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
