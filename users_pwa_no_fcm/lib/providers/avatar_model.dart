import 'package:flutter/material.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarModel extends ChangeNotifier {
  FlowState _avatarState = FlowState.Initial;

  String avatar = "";
  String fullname = "";

  AvatarModel() {
    _getUserAvatar();
  }

  FlowState get avatarState => _avatarState;
  Future get fetchUserAvatar => _getUserAvatar();

  Future<void> _getUserAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final localAvatar = prefs.getString("avatar");
    final localfullname = prefs.getString("name");

    _avatarState = FlowState.Loading;

    try {
      _avatarState = FlowState.Loaded;

      avatar = localAvatar;
      fullname = localfullname;
    } catch (e) {
      print("Error in Getting data from reserve notifier $e");
      _avatarState = FlowState.Error;
    }
    notifyListeners();
  }
}
