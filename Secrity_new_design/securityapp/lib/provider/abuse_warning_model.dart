import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:securityapp/model/ApiAccess.dart';
import 'package:securityapp/spec/FlowState.dart';

class AbuseWarningModel with ChangeNotifier {
  FlowState _getAbuseListState = FlowState.Initial;
  List abuseList = [];
  String _personalCode = "";

  FlowState get getAbuseListState => _getAbuseListState;
  Future get getAbuseList => _getAbuseList();

  // Set init values for getting abuse list by personalCode
  set setAbuseReportPersonalCode(String personalCode) {
    _personalCode = personalCode;
    notifyListeners();
  }

  AbuseWarningModel() {
    _getAbuseList();
  }

  Future _getAbuseList() async {
    _getAbuseListState = FlowState.Loading;
    final lStorage = FlutterSecureStorage();
    final userToken = await lStorage.read(key: "uToken");
    ApiAccess api = ApiAccess();

    try {
      final abuseListResponse = await api.getAbuseList(
        token: userToken,
        personalCode: _personalCode,
      );
      abuseList = abuseListResponse;
      _getAbuseListState = FlowState.Loaded;
    } catch (e) {
      print("Error from getting abuse list model $e");
      _getAbuseListState = FlowState.Error;
    }

    notifyListeners();
  }
}
