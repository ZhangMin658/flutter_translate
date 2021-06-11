import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:scan_and_translate/common/constant/assets_constant.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/prefs/shared_preference.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/widget/intro_page.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../../common/constant/navigation_constant.dart';

class IntroPages extends StatefulWidget {
  @override
  _IntroPagesState createState() {
    return _IntroPagesState();
  }
}

class _IntroPagesState extends State<IntroPages> {
  List<Container> _pages = List<Container>();


  int _current = 0;
  AlignmentDirectional _alignmentDirectional;


  @override
  void initState() {
    ///Init OnBoarding Pages info
    _pages.add(Container(
      child: Center(
        child: Image.asset(ImageDefine.image_translate_intro),
      ),
    ));

    _pages.add(Container(
    ));

    _pages.add(Container(
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              height: ScreenSizeConfig.safeBlockVertical * 70,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
              // autoPlay: false,
            ),
            items: _pages,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _pages.map((url) {
              int index = _pages.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin:
            EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            //color: ColorConstant.BUTTON_MAIN,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: ColorConstant.BUTTON_MAIN,
              ),
              color: ColorConstant.BUTTON_MAIN,
              borderRadius:
              BorderRadius.circular(ScreenSizeConfig.safeBlockVertical ),
            ),
            child: SizedBox(
              height: 30,
              width: double.infinity,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: ()  {
                  _goDrawerPage();
                },
                child: Text(
                  "Get Started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstant.ACTIVE_TEXT,
                  ),
                ),
              ),
            ),
          ),
        ],
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
