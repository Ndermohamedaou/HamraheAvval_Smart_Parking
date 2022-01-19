import 'package:payausers/ConstFiles/constText.dart';

class SpecificReserveType {
  String checkReserveTypeString(String type) {
    /// Check Reserve Type String.
    ///
    /// type: [String] in range of (list, instant, weekly).
    /// Will Check type of reserve in week tab.
    /// And will return proper string indicator of reserve type.
    switch (type) {
      case "list":
        return staticReserveText;
        break;
      case "instant":
        return instantReserveText;
        break;
      case "weekly":
        return weeklyReserveText;
        break;
      default:
        return unknownReserve;
    }
  }
}
