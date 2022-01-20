import 'package:shamsi_date/shamsi_date.dart';

class ConvertDate {
  List<String> splitDateTime(String dateTime) {
    try {
      if (dateTime.length > 17) {
        List<String> dateTimeList = dateTime.split(" ");
        return dateTimeList;
      } else
        return ["", ""];
    } catch (e) {
      return ["", ""];
    }
  }

  String convertDateToString(String date) {
    /// Convert Date to name String.
    ///
    /// At first split our date to get day, month and year.
    /// Example: date = "1400-10-30" to ["1400", "10", "30"].
    List<String> splitDate = date.split("-");
    Jalali jalali = Jalali(int.parse(splitDate[0]), int.parse(splitDate[1]),
        int.parse(splitDate[2]));

    return jalali.formatter.wN;
  }
}
