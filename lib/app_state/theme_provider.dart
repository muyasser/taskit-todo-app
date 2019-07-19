import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

final ThemeData _lightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  textTheme: TextTheme(
    button: TextStyle(color: Colors.white),
    title: TextStyle(
      color: Colors.black.withOpacity(.8),
    ),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.indigoAccent,
    unselectedLabelColor: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    actionsIconTheme: IconThemeData(
      color: Colors.black.withOpacity(.8),
    ),
  ),
  bottomAppBarColor: Colors.transparent,
  toggleableActiveColor: Colors.indigoAccent,
  accentIconTheme: IconThemeData(
    color: Colors.red,
  ),
  accentTextTheme: TextTheme(
    button: TextStyle(
      color: Colors.black87,
    ),
  ),
);

final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Colors.indigoAccent,
  splashColor: Colors.transparent,
  iconTheme: IconThemeData(color: Colors.white),
  highlightColor: Colors.transparent,
  tabBarTheme: TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey,
  ),
  textTheme: TextTheme(
    button: TextStyle(color: Colors.white),
    title: TextStyle(
      color: Colors.grey[300],
    ),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    actionsIconTheme: IconThemeData(
      color: Colors.grey[300],
    ),
  ),
  toggleableActiveColor: Colors.indigoAccent,

  //bottomAppBarColor: Colors.transparent,

  bottomAppBarColor: Colors.transparent,

  buttonColor: Colors.grey[400],

  accentTextTheme: TextTheme(
    button: TextStyle(
      color: Colors.grey[100],
    ),
  ),
);

class ThemeProvider {
  ThemeProvider._createInstance() {
    _init();
  }

  static bool _isDark;

  static ThemeData _currentTheme;

  static ThemeProvider _themeProvider;

  static SharedPreferences _prefs;

  static BehaviorSubject<ThemeData> _themeController = BehaviorSubject();

  Stream<ThemeData> get themeStream => _themeController.stream;

  // our singleton
  static ThemeProvider get instance {
    if (_themeProvider == null) {
      _themeProvider = ThemeProvider._createInstance();
    }

    return _themeProvider;
  }

  void _init() async {
    _prefs = await SharedPreferences.getInstance();

    _isDark = (_prefs.getBool('isDark'));

    if (_isDark == null) {
      _isDark = false;
    }

    _themeController.add(_isDark == true ? _darkTheme : _lightTheme);
  }

  static void dispose() {
    _themeController.close();
  }

  static void toggleTheme() async {
    print('theme changed');
    //_prefs = await SharedPreferences.getInstance();

    await _prefs.setBool('isDark', _isDark == true ? false : true);

    _themeController.sink.add(_isDark == true ? _lightTheme : _darkTheme);

    _isDark = !_isDark;
  }
}
