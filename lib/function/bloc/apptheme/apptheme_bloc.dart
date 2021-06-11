import 'dart:async';
import 'package:flutter/material.dart';
import '../../../common/config/themes.dart';
import '../../../common/prefs/shared_preference.dart';
import 'package:rxdart/rxdart.dart';

class AppThemeBloc {
  static AppThemeBloc _this;
  final Stream<ThemeData> themeDataStream;
  final Sink<Themes> selectedTheme;

  factory AppThemeBloc() {
    final selectedTheme = PublishSubject<Themes>();
    final themeDataStream =
        selectedTheme.distinct().map((theme) => getThemeByType(theme));
    if (_this == null) {
      _this = AppThemeBloc._(themeDataStream, selectedTheme);
    }

    return _this;
  }

  const AppThemeBloc._(this.themeDataStream, this.selectedTheme);

  Future<Themes> initialTheme() async {
    Themes theme = Themes.light;
    await Prefs.getInt(Prefs.THEME_SELECTED_PREFS_KEY).then((result) {
      theme = Themes.values.elementAt(result);
    });
    return theme;
  }
}
