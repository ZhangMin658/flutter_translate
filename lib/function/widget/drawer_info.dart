import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_set/animation_set.dart';
import 'package:flutter_animation_set/animator.dart';
import 'package:scan_and_translate/common/constant/assets_constant.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/navigation_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/common/view/oval_right_clipper.dart';
import 'package:scan_and_translate/function/utils/my_iap.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerInfo extends StatelessWidget {
  final Color primary = Colors.white;
  final Color active = ColorConstant.FLOATTING_MAIN;
  final Color divider = Colors.grey.shade600;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
            color: ColorConstant.BAR_MAIN,
            boxShadow: [BoxShadow(color: ColorConstant.BUTTON_MAIN)],
          ),
          width: ScreenSizeConfig.blockSizeHorizontal * 30,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: active,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            ColorConstant.ACTIVE_TEXT,
                            ColorConstant.ACTIVE_TEXT,
                          ],
                          tileMode: TileMode.clamp,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    child: ClipOval(
                        child: Image.asset(
                      ImageDefine.icon,
                      fit: BoxFit.cover,
                      width: 85.0,
                      height: 85.0,
                    )),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "App Name",
                    style: TextStyle(
                        color: ColorConstant.BUTTON_MAIN,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "#1 Application for Utilities",
                    style: TextStyle(color: active, fontSize: 16.0),
                  ),
                  SizedBox(height: 30.0),
                  MyIAP.iap.isPremiumUserAvalible
                      ? Center()
                      : _buildPremiumButton(context),
                  _buildDivider(),
                  _buildRow(Icons.settings, "Introduction"),
                  _buildDivider(),
                  _buildTextContent(
                      "The application is utility software designed to provide feature as scan document and recognizes text in 103 different languages and translate the document scanned to multi-language with AI for high precision in every context. The application uses the library of Google as Machine learning Kit, cloud translate API. We hope to bring the best utility to users.\n\nThe application developed by ©ABC"),
                  _buildDivider(),
                  _buildRow(Icons.email, "Contact us"),
                  _buildDivider(),
                  _buildTextContent(
                      "© ABC\n\nAddress: 55- California\nEmail: support@abc.com\nDetail: www.abc.com"),
                  _buildDivider(),
                  _buildRow(Icons.receipt, "Privacy policy"),
                  _buildDivider(),
                  _buildTextContent("www.abc.com/privacy-policy/"),
                  _buildDivider(),
                  _buildRow(Icons.info_outline, "Version"),
                  _buildDivider(),
                  _buildTextContent(
                      "v: 1.0.0\nThis is a version soft launch for received feedback!"),
                  _buildDivider(),
                  _buildRow(Icons.rate_review, "Rate this app"),
                  _buildDivider(),
                  _buildTextContent(
                      "You like this app ? Then take a little bit of your time to leave a rating"),
                  FlatButton(
                    onPressed: () {
                      _launchURL();
                    },
                    child: Text(
                      "Rate now",
                      style: TextStyle(
                        color: ColorConstant.BUTTON_MAIN,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: [
        Icon(
          icon,
          color: active,
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
        Spacer(),
        showBadge
            ? Material(
                color: Colors.deepOrange,
                elevation: 5.0,
                shadowColor: Colors.red,
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    "10+",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : Center(),
      ]),
    );
  }

  _buildTextContent(String text) {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
      ),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: ColorConstant.INACTIVE_TEXT,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style: TextStyle(
          color: ColorConstant.INACTIVE_TEXT,
        ),
      ),
    );
  }

  _buildPremiumButton(BuildContext context) {
    return AnimatorSet(
      child: Container(
        decoration: BoxDecoration(
          //shape: BoxShape.circle,
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: FlatButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context,
                NavigationConstant.SUBSCRIPTION_PAGE,
                (Route<dynamic> route) => false);
          },
          child: Text(
            "GET PREMIUM",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.ACTIVE_TEXT,
              decoration: TextDecoration.none,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.5,
            ),
          ),
        ),
      ),
      animatorSet: [
        TX(
          from: 0,
          to: 5.0,
          duration: 400,
          delay: 0,
          curve: Curves.fastOutSlowIn,
        ),
        TX(
          from: 5.0,
          to: 0,
          duration: 400,
          curve: Curves.fastOutSlowIn,
        ),
      ],
    );
  }

  _launchURL() async {
    String url;
    if (Platform.isIOS) {
      url = "https://itunes.apple.com/app/id/[app_id]?action=write-review";
    } else {
      url = "http://play.google.com/store/apps/details?id=[package]";
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
