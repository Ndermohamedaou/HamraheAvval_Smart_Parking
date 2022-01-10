import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';

class ReserveWeeks extends ChangeNotifier {
  // Flow state for loading, loaded, error.
  FlowState _reserveWeeksState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  ApiAccess api = ApiAccess();
  // Final list of weeks reserves.
  List finalReserveWeeks = [];

  ReserveWeeks() {
    _getReserveWeeks();
  }

  FlowState get reserveWeeksState => _reserveWeeksState;
  Future get fetchReserveWeeks => _getReserveWeeks();

  Future<void> _getReserveWeeks() async {
    final userToken = await lStorage.read(key: "token");
    _reserveWeeksState = FlowState.Loading;

    try {
      await Future.delayed(Duration(seconds: 2));
      final reserveWeeks = await api.reserveWeeks(token: userToken);
      // print(reserveWeeks);
      finalReserveWeeks = reserveWeeks;
      _reserveWeeksState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _reserveWeeksState = FlowState.Error;
    }
    notifyListeners();
  }
}
