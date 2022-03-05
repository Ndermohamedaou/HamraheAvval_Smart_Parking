import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  final Locale locale;
  Map<String, dynamic> _localizedStrings;

  Future<void> load() async {
    String jsonString = await rootBundle
        .loadString("assets/translations/${locale.languageCode}.json");
    _localizedStrings = json.decode(jsonString);
  }

  String translate(String keys) {
    ///
    /// Will get all keys you need as String!
    /// and Strings will split by '.' notation, and will have
    /// list of keys, we will set new value to _localizedStrings
    /// and per return value list will push to next index value.
    final keysInList = keys.split('.');
    dynamic value = _localizedStrings;
    try {
      // Will prepare value[key1][key2][etc..]
      keysInList.forEach((key) => value = value[key]);
      return value;
    } catch (e) {
      return "";
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
