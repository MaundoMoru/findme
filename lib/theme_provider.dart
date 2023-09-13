import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeProvider themeProvider = ThemeProvider();

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = false;

  ThemeData get currentTheme => isDarkTheme
      ? ThemeData(
          primaryColor: Colors.black,
          brightness: Brightness.dark,

          // accentColor: Colors.blue,
          // accentIconTheme: const IconThemeData(color: Colors.blue),
          dividerColor: Colors.black38,
          // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
          //     .copyWith(background: const Color(0xFF212121)),
        )
      : ThemeData(
          primaryColor: Colors.white,
          brightness: Brightness.light,

          scaffoldBackgroundColor: Colors.grey.shade100,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(background: const Color(0xFFE5E5E5)),
          // accentColor: Colors.blue,
          // accentIconTheme: const IconThemeData(color: Colors.blue),
          // dividerColor: Colors.white70,
        );

  ThemeProvider() {
    loadTheme();
  }

  void toggleTheme() {
    isDarkTheme = !isDarkTheme;
    saveTheme();
    notifyListeners();
  }

  void saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('themeMode', isDarkTheme);
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool('themeMode') ?? false;
    notifyListeners();
  }
}
