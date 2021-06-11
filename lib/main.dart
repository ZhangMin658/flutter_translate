import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'common/config/themes.dart';
import 'common/config/routes.dart';
import 'common/constant/navigation_constant.dart';
import 'common/util/app_orientation.dart';
import 'common/view/error_handle_page.dart';
import 'function/bloc/apptheme/apptheme_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppThemeBloc _appthemeBloc = AppThemeBloc();
  final Themes _theme = Themes.light;

  @override
  Widget build(BuildContext context) {
    AppOrientation.setPreferredOrientationPortrait();
    AppOrientation.setFullScreenApp();

    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return ErrorHandlePage.getErrorWidget(context, errorDetails);
    };

    _appthemeBloc.initialTheme().then((onValue) {
      _appthemeBloc.selectedTheme.add(onValue);
    });

    return StreamBuilder<ThemeData>(
      initialData: getThemeByType(_theme),
      stream: _appthemeBloc.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'Just scan everything',
          debugShowCheckedModeBanner: false,
          theme: snapshot.data,
          initialRoute: '/',
          onGenerateRoute: generateRoutes,
          navigatorKey: NavigationConstant.navKey,
          navigatorObservers: [new VillainTransitionObserver()],
        );
      },
    );
  }
}
//end class MyApp
