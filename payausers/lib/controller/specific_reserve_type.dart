import 'package:payausers/localization/app_localization.dart';

class SpecificReserveType {
  final context;
  SpecificReserveType(this.context);

  String checkReserveTypeString(String type) {
    /// Check Reserve Type String.
    ///
    /// type: [String] in range of (list, instant, weekly).
    /// Will Check type of reserve in week tab.
    /// And will return proper string indicator of reserve type.
    // TODO: Convert this function to a simple map
    AppLocalizations t = AppLocalizations.of(context);

    switch (type) {
      case "list":
        return t.translate("reserves.reserveCategories.static");
        break;
      case "instant":
        return t.translate("reserves.reserveCategories.instant");
        break;
      case "weekly":
        return t.translate("reserves.reserveCategories.weekly");
        break;
      default:
        return t.translate("reserves.reserveCategories.unknown");
    }
  }
}
