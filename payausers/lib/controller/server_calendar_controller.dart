import 'package:payausers/ConstFiles/constText.dart';

class ServerCalendarController {
  List calculateCalendar(Map persianCalendar) {
    ///
    /// Prepare data of the proper calendar.
    /// prepare data of calendar base on the real calendar.
    /// for example:
    /// شنبه  یکشنبه دوشنبه چهارشنبه پنجشنبه جمعه
    ///  ۳      ۲       ۱
    ///  ۹      ۸       ۷       ۶       ۵     ۴
    // Static Persian week
    const daysOfWeek = [sat, sun, mon, tues, wed, thurs, fri];
    // Define month of year
    List serverMonths = persianCalendar["months"];
    // Final date of month
    List calendar = [];
    List monthCalendar = [];

    try {
      for (String month in serverMonths) {
        // Getting days of specific month
        List serverCalendar = persianCalendar["calendar"][month];
        for (String day in daysOfWeek) {
          for (int i = 0; i < serverCalendar.length; i++) {
            if (i == 0 && serverCalendar[i]["date_fa"] != day) {
              monthCalendar.add({
                "date": "",
                "date_fa": "",
                "day": "",
                "isSelected": false,
                "clickable": false,
                "holiday": false,
                "event_desc": "",
              });
              break;
            } else {
              monthCalendar.add({
                "date": serverCalendar[i]["date"],
                "date_fa": serverCalendar[i]["date_fa"],
                "day": splitDateAtLastOne(serverCalendar[i]["date"]),
                "isSelected": serverCalendar[i]["isSelected"],
                "clickable": serverCalendar[i]["clickable"],
                "holiday": serverCalendar[i]["holiday"],
                "event_desc": serverCalendar[i]["event_desc"],
              });
            }
          }
        }
        calendar.add(monthCalendar);
        monthCalendar = [];
      }
    } catch (e) {
      return [];
    }

    return calendar;
  }

  splitDateAtLastOne(String day) {
    List<String> dateInSplit = day.split("-");
    return dateInSplit[dateInSplit.length - 1][0] == "0"
        ? dateInSplit[dateInSplit.length - 1][1]
        : dateInSplit[dateInSplit.length - 1];
  }
}
