import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';

class InstantReserveModel extends ChangeNotifier {
  FlowState _instantReserveState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  // API will return a status that has 0 or 1 to having instant reserve.
  var canInstantReserve;

  InstantReserveModel() {
    _getInstantReserve();
  }

  FlowState get instantReserveState => _instantReserveState;
  Future get fetchInstantReserve => _getInstantReserve();

  Future<void> _getInstantReserve() async {
    // Getting the token from the storage.
    final userToken = await lStorage.read(key: "token");
    _instantReserveState = FlowState.Loading;
    try {
      // Getting data from API.
      ApiAccess api = ApiAccess(userToken);
      Endpoint instantReserveEndpoint =
          apiEndpointsMap["reserveEndpoint"]["canInstantReserve"];
      // Have a duration to wait for the response.
      await Future.delayed(Duration(seconds: 1));
      final result = await api.requestHandler(
          instantReserveEndpoint.route, instantReserveEndpoint.method, {});
      // Gdtting instant reserve and cast it to Map.
      canInstantReserve = jsonDecode(result)["status"];
      // print("Can instant reserve? $canInstantReserve");
    } catch (e) {
      // print("Error in getting data from instant reserve model $e");
      _instantReserveState = FlowState.Error;
    }
  }
}
