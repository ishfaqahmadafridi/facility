import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  bool get isUrdu => _locale.languageCode == 'ur';

  void setLocale(Locale locale) {
    if (!['en', 'ur'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = isUrdu ? const Locale('en') : const Locale('ur');
    notifyListeners();
  }
}
