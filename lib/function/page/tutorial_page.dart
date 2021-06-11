import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:scan_and_translate/common/constant/assets_constant.dart';
import 'package:scan_and_translate/common/prefs/shared_preference.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/widget/intro_page.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../common/constant/navigation_constant.dart';

class TutorialPage extends StatefulWidget {
  @override
  _TutorialPageState createState() {
    return _TutorialPageState();
  }
}

class _TutorialPageState extends State<TutorialPage> {
  List<Container> _pages = List<Container>();

  @override
  void initState() {
    ///Init OnBoarding Pages info
    _pages.add(Container(
      child: IntroPage(
        btnRightText: "Skip",
        title: "Convert everything to word",
        description:
            "The application use multi-input as camera take photo, import photo from image album or live scan for converting document to word and recognizes text in 103 different languages.",
        endColor: Color(0xFF54a0ff),
        startColor: Color(0xFF00d2d3),
        imagePath: ImageDefine.image_ocr_text,
        btnRightOnPressed: () {
          _goDrawerPage();
        },
      ),
    ));

    _pages.add(Container(
      child: IntroPage(
        btnRightText: "Skip",
        title: "Translate for high precision",
        description:
            "Our document translation api are available in more than 170 languages. With the application, you can translate the document scanned to multi-language with AI for high precision in every context.",
        endColor: Color(0xFF5f27cd),
        startColor: Color(0xFF54a0ff),
        imagePath: ImageDefine.image_translate_intro,
        btnRightOnPressed: () {
          _goDrawerPage();
        },
      ),
    ));

    _pages.add(Container(
      child: IntroPage(
        btnRightText: "Let's Go !",
        title: "Easy export to email",
        description:
            "Which will allow you to save the history scan as a backup to a storage unlimited. And export full the backup sent to email at anytime.",
        endColor: Color(0xFFee5253),
        startColor: Color(0xFF5f27cd),
        imagePath: ImageDefine.image_document_save,
        btnRightOnPressed: () {
          _goDrawerPage();
        },
        isLastPage: true,
      ),
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Villain(
      villainAnimation: VillainAnimation.scale(
        fromScale: 0.0,
        toScale: 1.0,
        from: Duration(milliseconds: 100),
        to: Duration(milliseconds: 500),
      ),
      animateExit: true,
      secondaryVillainAnimation: VillainAnimation.fade(),
      child: LiquidSwipe(
        pages: _pages,
        enableLoop: false,
        enableSlideIcon: true,
        slideIconWidget: Icon(
          Icons.blur_circular,
          color: Colors.white54,
          size: ScreenSizeConfig.blockSizeVertical * 4,
        ),
        waveType: WaveType.liquidReveal,
      ),
    );
  }

  _goDrawerPage() {
    //save to skip tutorial
    Prefs.saveBool(Prefs.SHOW_INTRO_PAGE_PREFS_KEY, false);
    // Navigator.pushNamedAndRemoveUntil(context, NavigationConstant.DRAWER_PAGE,
    //     (Route<dynamic> route) => false);
    Navigator.pushNamedAndRemoveUntil(context, NavigationConstant.HOME_DRAWER_PAGE,
            (Route<dynamic> route) => false);
  }
}
