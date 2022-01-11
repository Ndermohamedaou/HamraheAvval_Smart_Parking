import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payausers/spec/enum_state.dart';

class AvatarModel extends ChangeNotifier {
  FlowState _avatarState = FlowState.Initial;
  final lStorage = FlutterSecureStorage();

  String userToken = "";
  String avatar = "";
  String fullname = "";

  AvatarModel() {
    _getUserAvatar();
  }

  FlowState get avatarState => _avatarState;
  Future get fetchUserAvatar => _getUserAvatar();

  Future<void> _getUserAvatar() async {
    final localAvatar = await lStorage.read(key: "avatar");
    final localfullname = await lStorage.read(key: "name");
    final localToken = await lStorage.read(key: "token");
    _avatarState = FlowState.Loading;

    try {
      _avatarState = FlowState.Loaded;
      // Init data from the Local Storage
      userToken = localToken;
      avatar = localAvatar;
      fullname = localfullname;
    } catch (e) {
      print("Error in Getting data from avatar notifier $e");
      _avatarState = FlowState.Error;
    }
    notifyListeners();
  }
}
