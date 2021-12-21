import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/spec/enum_state.dart';

class StaffInfoModel extends ChangeNotifier {
  FlowState _staffLoadState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();
  ApiAccess api = ApiAccess();

  Map staffInfo = {};

  StaffInfoModel() {
    _getStaffInfo();
  }

  FlowState get staffLoadState => _staffLoadState;
  Future get fetchStaffInfo => _getStaffInfo();

  Future<void> _getStaffInfo() async {
    final userToken = await lStorage.read(key: "token");
    _staffLoadState = FlowState.Loading;

    try {
      await Future.delayed(Duration(seconds: 1));

      final initInfo = await api.getStaffInfo(token: userToken);
      staffInfo = initInfo;
      _staffLoadState = FlowState.Loaded;
    } catch (e) {
      print("Error in getting data from staffInfo notifier $e");
      _staffLoadState = FlowState.Error;
    }
    notifyListeners();
  }
}
