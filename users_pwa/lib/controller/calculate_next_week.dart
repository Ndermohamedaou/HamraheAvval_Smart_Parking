import 'package:shamsi_date/shamsi_date.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class DateTimeCalculator {
  List getAWeek() {
    /// Get next week that will start with Saturday.
    ///
    /// With this function you can get a free week from Saturday to Thursday.
    /// This DateTime shall be Persian DateTime to show users, what is their selected dates.
    /// This method will perform saturday to wednesday.
    Jalali now = Jalali.now();
    var weekDay = now.weekDay;
    var firstOfTheWeek = now - weekDay + 8;
    // Define a list of 5 days of week.
    List week = [];

    for (var i = 0; i < 5; i++) {
      final date = firstOfTheWeek + i;
      // Create zero before date;
      final correctMonth = date.month < 10 ? '0${date.month}' : date.month;
      final correctDate = date.day < 10 ? '0${date.day}' : date.day;
      // Prepared data
      final dateString = "${date.year}-$correctMonth-$correctDate";
      final dateTimeLabel =
          "${date.formatter.wN} ${date.formatter.d.toPersianDigit()} ${date.formatter.mN} ${date.formatter.yyyy.toPersianDigit()}";

      week.add({"value": dateString, "label": dateTimeLabel});
    }

    return week;
  }

  parseDatesFromNextWeek(List selectedReserveList) {
    // This is final value of reserve list.
    List finalSelectedList = [];
    List nextWeekDates = [];
    List nextWeek = getAWeek();

    // Getting only dates of next week helper method
    for (int i = 0; i < nextWeek.length; i++) {
      nextWeekDates.add(nextWeek[i]["value"]);
    }

    for (String date in nextWeekDates) {
      finalSelectedList.add({
        "date": date,
        "isSelected": selectedReserveList.contains(date) ? 1 : 0,
      });
    }

    return finalSelectedList;
  }
}
