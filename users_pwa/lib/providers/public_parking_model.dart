import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicParkingModel extends ChangeNotifier {
  FlowState _publicParkingState = FlowState.Initial;
  List publicParkings = [];

  FlowState get publicParkingState => _publicParkingState;
  Future get fetchPublicParking => _getPublicParking();

  Future<void> _getPublicParking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final localToken = prefs.getString("token");

    ApiAccess api = ApiAccess(localToken);
    _publicParkingState = FlowState.Loading;

    try {
      Endpoint userReserves = apiEndpointsMap["getPublicParkingTypes"];
      // Wait for a second for getting safe data.
      await Future.delayed(Duration(seconds: 1));
      final parkingList =
          await api.requestHandler(userReserves.route, userReserves.method, {});
      publicParkings = parkingList;
      _publicParkingState = FlowState.Loaded;
    } catch (e) {
      print("Error in Getting data from Public Parking notifier $e");
      _publicParkingState = FlowState.Error;
    }
    notifyListeners();
  }
}
