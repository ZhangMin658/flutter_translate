import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_translate/function/page/home_drawer_page.dart';
import 'package:scan_and_translate/function/page/intro_page.dart';
import '../constant/navigation_constant.dart';
import '../../function/page/light_drawer_page.dart';
import '../../function/page/main_page.dart';
import '../../function/page/subscription_page.dart';
import '../../function/page/tutorial_page.dart';

Route generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case NavigationConstant.MAIN_PAGE:
      return buildRoute(settings, MainPage());
    case NavigationConstant.TUTORIAL_PAGE:
      return buildRoute(settings, IntroPages());
    case NavigationConstant.DRAWER_PAGE:
      return buildRoute(settings, LightDrawerPage());

    case NavigationConstant.HOME_DRAWER_PAGE:
      return buildRoute(settings, HomeDrawerPage());

    case NavigationConstant.SUBSCRIPTION_PAGE:
      return buildRoute(settings, SubscriptionPage());

    // case NavigationConstrants.ListWordChecked:
    //   var data = settings.arguments;
    //   return buildRoute(settings, ListWordChecked(data));
    default:
      return buildRoute(settings, MainPage());
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return new MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => builder,
  );
}

FlushbarRoute buildNotification(Flushbar type) {
  return FlushbarRoute(
    flushbar: type,
    settings: RouteSettings(name: FLUSHBAR_ROUTE_NAME),
  );
}
