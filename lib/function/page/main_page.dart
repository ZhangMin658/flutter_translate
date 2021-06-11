import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/config/themes.dart';
import 'package:scan_and_translate/common/constant/assets_constant.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/navigation_constant.dart';
import 'package:scan_and_translate/common/prefs/shared_preference.dart';
import 'package:scan_and_translate/common/util/connectivity.dart';
import 'package:scan_and_translate/function/utils/my_iap.dart';
import 'package:scan_and_translate/function/widget/fancy_background_anim.dart';

import '../../common/util/screen_size_config.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  bool _isShowIntroPage = true;
  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Stack(
      children: <Widget>[
        ///layer img background
        Container(
          decoration: BoxDecoration(
            gradient: ThemeColor.getLinearGradientColor(
              Color(0xff1dd1a1),
              Color(0xff48dbfb),
            ),
          ),
        ),
        FancyBackgroundApp(
          child: Container(),
        ),
        Column(
          children: <Widget>[
            Container(
              margin:
                  EdgeInsets.only(top: ScreenSizeConfig.blockSizeVertical * 15),
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstant.ACTIVE_TEXT,
              ),
              child: ClipOval(
                child: Image.asset(
                  ImageDefine.icon,
                  fit: BoxFit.cover,
                  width: 110.0,
                  height: 110.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: Text(
                "Scan & Translate",
                style: TextStyle(
                  color: ColorConstant.BAR_MAIN,
                  decoration: TextDecoration.none,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ), //animation background
      ],
    );
  }

  _loadData() async {
    //Check internet connection
    bool isConnected = await Connecttivity.checkInternetConnection();
    bool isSubscriptionAvailble = false;
    //Call init IAP if have connected
    if (isConnected) {
      // await MyIAP.iap.initStoreInfo();
    }

    //Get show intro page or/no
    _isShowIntroPage = await Prefs.getBool(Prefs.SHOW_INTRO_PAGE_PREFS_KEY,
        defaultValue: true);
    await Future.delayed(Duration(milliseconds: 400), () {});
    if (isConnected) {
      // isSubscriptionAvailble = await MyIAP.iap.isMySubscriptionAvalible();
    }
    //Cheating for always goto tutorial
    //Todo: Let removed '|| true'
    if (_isShowIntroPage || true) {
      ///Go to App OnBoarding
      _goTutorial();
    } else {
      if (!isConnected ||
          MyIAP.iap.productDetails.length <= 0 ||
          isSubscriptionAvailble) {
        ///Go to main page.
        _goDrawerPage();
      } else {
        ///Go to subscription page for buy iap
        _goSubscriptionPage();
      }
    }
  }

  _goTutorial() {
    Navigator.pushNamedAndRemoveUntil(context, NavigationConstant.TUTORIAL_PAGE,
        (Route<dynamic> route) => false);
  }

  _goDrawerPage() {
    Navigator.pushNamedAndRemoveUntil(context, NavigationConstant.DRAWER_PAGE,
        (Route<dynamic> route) => false);
  }

  _goSubscriptionPage() {
    Navigator.pushNamedAndRemoveUntil(context,
        NavigationConstant.SUBSCRIPTION_PAGE, (Route<dynamic> route) => false);
  }
}
