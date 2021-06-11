import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/config/themes.dart';
import 'package:scan_and_translate/common/prefs/shared_preference.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/apptheme/apptheme_bloc.dart';

class ThemeSelectWidget extends StatefulWidget {
  ThemeSelectWidget({Key key}) : super(key: key);
  @override
  _ThemeSelectWidgetState createState() {
    return _ThemeSelectWidgetState();
  }
}

class _ThemeSelectWidgetState extends State<ThemeSelectWidget> {
  Map _listTheme = {
    "Light theme": Themes.light,
    "Dark theme": Themes.dark,
    "Organizer theme": Themes.organizer,
  };
  List<DropdownMenuItem<Themes>> _dropDownMenuItems;
  Themes _currentTheme;
  final AppThemeBloc _appthemeBloc = AppThemeBloc();

  @override
  void initState() {
    Prefs.getInt(Prefs.THEME_SELECTED_PREFS_KEY).then((result) {
      setState(() {
        _currentTheme = Themes.values.elementAt(result);
        _dropDownMenuItems = _getDropDownMenuItems();
      });
    });
    _dropDownMenuItems = _getDropDownMenuItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Card(
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(
          //   width: 1,
          //   color: getThemeByType(_currentTheme).primaryColor,
          // ),
          borderRadius: BorderRadius.circular(5),
          gradient: ThemeColor.getGradientPrinaryColor(_currentTheme),
        ),
        width: ScreenSizeConfig.blockSizeHorizontal * 30,
        padding: EdgeInsets.all(20),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Choose app theme!",
              style: TextStyle(
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Container(
              padding: new EdgeInsets.all(5.0),
            ),
            new DropdownButton(
              value: _currentTheme,
              items: _dropDownMenuItems,
              onChanged: _changedDropDownItem,
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Themes>> _getDropDownMenuItems() {
    List<DropdownMenuItem<Themes>> items = new List();
    _listTheme.forEach((str, theme) {
      items.add(
        new DropdownMenuItem(
          value: theme,
          child: theme == _currentTheme
              ? Text(
                  str,
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: ScreenSizeConfig.safeBlockHorizontal * 2,
                  ),
                )
              : Text(
                  str,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: ScreenSizeConfig.safeBlockHorizontal * 2,
                  ),
                ),
        ),
      );
    });
    return items;
  }

  void _changedDropDownItem(Themes selectedTheme) {
    setState(() {
      _currentTheme = selectedTheme;
      _dropDownMenuItems = _getDropDownMenuItems();
      _appthemeBloc.selectedTheme.add(_currentTheme);
    });
    Prefs.saveInt(Prefs.THEME_SELECTED_PREFS_KEY,
            Themes.values.indexOf(_currentTheme))
        .then((result) => print("Save Prefs Status: $result"));
  }
}
