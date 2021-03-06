import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/spec/enum_state.dart';

class AvatarModel extends ChangeNotifier {
  FlowState _avatarState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();

  String userToken = "";
  String avatar = "http://via.placeholder.com/350x150";
  String fullname = "";
  String userID = "";

  AvatarModel() {
    _getUserAvatar();
  }

  FlowState get avatarState => _avatarState;
  Future get fetchUserAvatar => _getUserAvatar();

  set refreshToken(String value) {
    userToken = value;
    notifyListeners();
  }

  Future<void> _getUserAvatar() async {
    final localAvatar = await lStorage.read(key: "avatar");
    final localfullname = await lStorage.read(key: "name");
    final localToken = await lStorage.read(key: "token");
    final localUserID = await lStorage.read(key: "user_id");

    _avatarState = FlowState.Loading;

    try {
      _avatarState = FlowState.Loaded;
      // Init data from the Local Storage
      userToken = localToken;
      avatar = localAvatar;
      fullname = localfullname;
      userID = localUserID;
    } catch (e) {
      print("Error in Getting data from avatar notifier $e");
      _avatarState = FlowState.Error;
    }

    notifyListeners();
  }
}
