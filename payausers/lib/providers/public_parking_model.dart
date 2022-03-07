import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/api_access.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';

class PublicParkingModel extends ChangeNotifier {
  FlowState _publicParkingState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  List publicParkings = [];

  FlowState get publicParkingState => _publicParkingState;
  Future get fetchPublicParking => _getPublicParking();

  Future<void> _getPublicParking() async {
    final userToken = await lStorage.read(key: "token");
    ApiAccess api = ApiAccess(userToken);
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
