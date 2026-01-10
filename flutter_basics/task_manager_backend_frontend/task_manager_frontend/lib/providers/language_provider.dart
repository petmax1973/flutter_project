import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale(
    'it',
  ); // Default to Italian as per user preference

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locele) {
    if (_currentLocale == locele) return;
    _currentLocale = locele;
    notifyListeners();
  }

  void toggleLanguage() {
    if (_currentLocale.languageCode == 'it') {
      _currentLocale = const Locale('en');
    } else {
      _currentLocale = const Locale('it');
    }
    notifyListeners();
  }
}
