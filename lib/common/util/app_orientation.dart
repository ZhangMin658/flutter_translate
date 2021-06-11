import 'dart:io';

import 'package:flutter/services.dart';

class AppOrientation {
  static setPreferredOrientationLandscape() {
    DeviceOrientation deviceOrientation;
    Platform.isAndroid
        ? deviceOrientation = DeviceOrientation.landscapeLeft
        : deviceOrientation = DeviceOrientation.landscapeRight;
    SystemChrome.setPreferredOrientations([deviceOrientation]);
  }

  static setPreferredOrientationPortrait() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static setFullScreenApp() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
}
