import 'package:flutter/material.dart';
import 'package:payausers/Model/ApiAccess.dart';
import 'package:payausers/Model/endpoints.dart';
import 'package:payausers/spec/enum_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerBaseCalendarModel extends ChangeNotifier {
  FlowState _calendarLoadState = FlowState.Initial;
  Map calendar = {};

  ServerBaseCalendarModel() {
    _getCalendar();
  }

  FlowState get calendarState => _calendarLoadState;
  Future get fetchCalendar => _getCalendar();

  Future<void> _getCalendar() async {
    ///
    /// Getting Server base Calendar data like this structure:
    /// {
    ///  "current": {
    ///     "year": "1400",
    ///     "month": "بهمن"
    /// },
    /// "months": [
    ///     "دی",
    ///     "بهمن",
    ///     "اسفند"
    /// ],
    /// "calendar": {
    ///     "دی": [
    ///         {
    ///           "date": "1400-10-01",
    ///           "date_fa": "چهارشنبه",
    ///           "clickable": false,
    ///           "holiday": false,
    ///           "event_desc": ""
    ///         },
    ///       ...
    ///      ]
    ///   }
    /// }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString("token");
    ApiAccess api = ApiAccess(userToken);
    _calendarLoadState = FlowState.Loading;

    try {
      Endpoint calendarEndpoint = apiEndpointsMap["getCalendarDates"];
      await Future.delayed(Duration(seconds: 1));
      final serverCalendar = await api
          .requestHandler(calendarEndpoint.route, calendarEndpoint.method, {});
      calendar = serverCalendar;

      _calendarLoadState = FlowState.Loaded;
    } catch (e) {
      print("Error from getting data of calendar $e");

      _calendarLoadState = FlowState.Error;
    }

    notifyListeners();
  }
}
