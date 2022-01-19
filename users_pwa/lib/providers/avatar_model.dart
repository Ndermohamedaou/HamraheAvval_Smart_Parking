import 'package:flutter/material.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarModel extends ChangeNotifier {
  FlowState _avatarState = FlowState.Initial;

  String userToken = "";
  String avatar = "";
  String fullname = "";
  String userID = "";

  AvatarModel() {
    _getUserAvatar();
  }

  FlowState get avatarState => _avatarState;
  Future get fetchUserAvatar => _getUserAvatar();

  Future<void> _getUserAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final localAvatar = prefs.getString("avatar");
    final localfullname = prefs.getString("name");
    final localToken = prefs.getString("token");
    final localUserID = prefs.getString("user_id");

    _avatarState = FlowState.Loading;

    try {
      _avatarState = FlowState.Loaded;
      // Init data from the Local Storage
      userToken = localToken;
      avatar = localAvatar;
      fullname = localfullname;
      userID = localUserID;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _avatarState = FlowState.Error;
    }
    notifyListeners();
  }
}
