import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_translate/function/page/Settings.dart';
import 'package:scan_and_translate/function/page/home_page.dart';
import 'package:scan_and_translate/function/page/light_drawer_page.dart';
import 'package:scan_and_translate/function/page/translate_page.dart';

class HomeDrawerPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeDrawerPage> {
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home",),
          TabData(
              iconData: Icons.home_repair_service_outlined,
              title: "Translations"),
          TabData(
              iconData: Icons.camera_enhance_sharp,
              title: "Camera"),
          TabData(iconData: Icons.settings, title: "Settings",)
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),

    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return HomePage();
      case 1:
        return TranslatePage();
      case 2:
        return LightDrawerPage();
      case 3:
        return Settings();
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the basket page"),
            RaisedButton(
              child: Text(
                "Start new page",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            )
          ],
        );
    }
  }
}