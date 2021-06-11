import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_set/animation_set.dart';
import 'package:flutter_animation_set/animator.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';

import '../../common/config/themes.dart';

class IntroPage extends StatelessWidget {
  final Color startColor;
  final Color endColor;
  final String title;
  final String imagePath;
  final String description;
  final String btnRightText;
  final GestureTapCallback btnRightOnPressed;
  final String btnLeftText;
  final GestureTapCallback btnLeftOnPressed;
  final bool isLastPage;

  IntroPage({
    this.btnRightText,
    this.description = "",
    this.endColor,
    this.imagePath,
    this.btnRightOnPressed,
    this.startColor,
    this.title,
    this.btnLeftText = "",
    this.btnLeftOnPressed,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: ThemeColor.getLinearGradientColor(startColor, endColor),
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(
                            ScreenSizeConfig.blockSizeVertical * 7),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          height: ScreenSizeConfig.blockSizeVertical * 20,
                        ),
                      ),
                      Container(
                          //height: ScreenSizeConfig.blockSizeVertical * 1,
                          ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenSizeConfig.safeBlockVertical * 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: ScreenSizeConfig.blockSizeVertical * 3,
                      ),
                      _buildTextContent(description),
                      // Text(
                      //   description,
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: ScreenSizeConfig.safeBlockVertical * 2,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(
                            ScreenSizeConfig.safeBlockVertical * 2),
                        child: btnLeftText != ""
                            ? FlatButton(
                                child: Text(
                                  btnLeftText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        ScreenSizeConfig.safeBlockVertical * 2,
                                  ),
                                ),
                                onPressed: btnLeftOnPressed,
                              )
                            : Center(),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: isLastPage
                            ? Icon(
                                Icons.check_circle_outline,
                                color: Color(0xFF1dd1a1),
                                size: ScreenSizeConfig.safeBlockVertical * 4,
                              )
                            : AnimatorSet(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_back,
                                      color: ColorConstant.ACTIVE_TEXT,
                                      size:
                                          ScreenSizeConfig.safeBlockHorizontal *
                                              3.5,
                                    ),
                                    Text(
                                      " Swipe to next page",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenSizeConfig
                                                .safeBlockHorizontal *
                                            3,
                                      ),
                                    ),
                                  ],
                                ),
                                animatorSet: [
                                  Serial(
                                    duration: 2000,
                                    serialList: [
                                      TX(
                                          from: ScreenSizeConfig
                                                  .blockSizeHorizontal *
                                              10,
                                          to: -ScreenSizeConfig
                                                  .blockSizeHorizontal *
                                              10,
                                          curve: Curves.easeInOut),
                                      O(
                                          from: 0.5,
                                          to: 0.9,
                                          delay: 1000,
                                          curve: Curves.easeInOut),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.all(
                            ScreenSizeConfig.blockSizeHorizontal * 2),
                        child: btnRightText != ""
                            ? FlatButton(
                                child: Text(
                                  btnRightText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        ScreenSizeConfig.safeBlockVertical * 2,
                                  ),
                                ),
                                onPressed: btnRightOnPressed,
                              )
                            : Center(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // FancyBackgroundApp(
          //   child: Center(),
          //   // Container(
          //   //   decoration: BoxDecoration(
          //   //     gradient: ThemeColor.getLinearGradientColor(startColor, endColor),
          //   //   ),
          //   //   child: Center(),
          //   // ),
          // ),
        ],
      ),
    );
  }

  _buildTextContent(String text) {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenSizeConfig.blockSizeHorizontal * 15,
        right: ScreenSizeConfig.blockSizeHorizontal * 15,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: ColorConstant.ACTIVE_TEXT,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorConstant.ACTIVE_TEXT,
        ),
      ),
    );
  }
}
