import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_set/animation_set.dart';
import 'package:flutter_animation_set/animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:scan_and_translate/common/config/themes.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/constant/navigation_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/bloc.dart';
import 'package:scan_and_translate/function/widget/fancy_background_anim.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SubscriptionPageState();
  }
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _packSelected = 0;
  IapBloc _iapBloc;
  List<ProductDetails> _products;

  @override
  void initState() {
    _iapBloc = IapBloc();
    _iapBloc.purchaseResultCallback = _onPurchaseCallback;
    _iapBloc.add(LoadIAPEvent());
    super.initState();
  }

  @override
  void dispose() {
    _iapBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ScreenSizeConfig().init(context);
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ///layer img background
          Container(
            decoration: BoxDecoration(
              gradient: ThemeColor.getLinearGradientColor(
                Color(0xfff368e0),
                Color(0xff5f27cd),
              ),
            ),
          ),
          //Background animation
          FancyBackgroundApp(
            child: Container(),
          ),
          //SingleChildScrollView(
          //  child:
          Column(
            children: <Widget>[
              Container(
                height: ScreenSizeConfig.blockSizeVertical * 5,
                alignment: Alignment.centerRight,
                margin: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    print("Close button on tapppp");
                    _goDrawerPage();
                  },
                  child: Icon(
                    Icons.close,
                    color: ColorConstant.ACTIVE_TEXT,
                    size: 45,
                  ),
                ),
              ),
              //Box info
              Container(
                margin: EdgeInsets.only(
                  top: ScreenSizeConfig.blockSizeVertical * 5,
                  left: ScreenSizeConfig.blockSizeVertical * 5,
                  right: ScreenSizeConfig.blockSizeVertical * 5,
                  bottom: ScreenSizeConfig.blockSizeVertical * 2,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 255, 255, 100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BlocBuilder(
                  bloc: _iapBloc,
                  builder: _buildBlocBody,
                ),
              ),

              //
              Expanded(
                child: Center(),
              ),
              //
              //bottom info
              Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  "* Payment will be charged to iTunes Account at confirmation of purchase\n" +
                      "* Subscriotion automatically renews unless auto-renew is turned off at least\n24-hours before the end of the current period\n" +
                      "* Account will be charged for renewal whithin 24-hours prior tho the end of the\ncurrent period and identify the cost of the reneward\n" +
                      "* Subscriptions may be managed by the user and auto-renewal may be\nturned off by going tho the user's Account Settings after purchase\n" +
                      "* Any unused portion of a free trial period, if offered, will be forfeited when\nthe user purchases a subscription to that publication, when applicable",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstant.ACTIVE_TEXT,
                    decoration: TextDecoration.none,
                    height: 1.2,
                    fontSize: ScreenSizeConfig.safeBlockHorizontal * 2.5,
                  ),
                ),
              ),
              //button pravacy
              Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          _goPrivacyPolicy();
                        },
                        child: Text(
                          "Privacy Policy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorConstant.ACTIVE_TEXT,
                            decoration: TextDecoration.none,
                            fontSize:
                                ScreenSizeConfig.safeBlockHorizontal * 2.5,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: ScreenSizeConfig.blockSizeHorizontal * 2,
                        color: ColorConstant.ACTIVE_TEXT,
                      ),
                      FlatButton(
                        onPressed: () {
                          _goEULA();
                        },
                        child: Text(
                          "EULA",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorConstant.ACTIVE_TEXT,
                            decoration: TextDecoration.none,
                            fontSize:
                                ScreenSizeConfig.safeBlockHorizontal * 2.5,
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ), //animation background
        ],
      ),
    );
  }

  ///Body build ....
  ///
  Widget _buildBlocBody(BuildContext context, IapState state) {
    if (state is AvailbleIAPState) {
      _products = state.productDetails;
      return _buildContentIAPPack(state.productDetails, state.percentagePrice);
    }
    if (state is BuyingIAPState) {
      return _buildPurchasePending();
    }
    if (state is BuySuccessIAPState) {
      return _buildSuccessIAP();
    }
    if (state is UnavaibleIAPState) {
      return _buildUnavaibleIAP();
    }

    return Container(
      height: ScreenSizeConfig.blockSizeVertical * 30,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildContentIAPPack(
      List<ProductDetails> products, String percentagePrice) {
    return Column(
      children: <Widget>[
        //title
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            "PREMIUM USER",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.BUTTON_MAIN,
              decoration: TextDecoration.none,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        //description
        Container(
          margin: EdgeInsets.all(5),
          child: Text(
            "Get Unlimited Recognitions\nActive Live Mode, Speech Mode\nRemove all ads",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.BAR_MAIN,
              decoration: TextDecoration.none,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 3,
            ),
          ),
        ),
        //Option
        Container(
          child: _buildRadioSelector(products, percentagePrice),
        ),
        //Button
        AnimatorSet(
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
                _goBuySubScription();
              },
              child: Column(
                children: <Widget>[
                  Text(
                    "GET NOW",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstant.BAR_MAIN,
                      decoration: TextDecoration.none,
                      fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.5,
                    ),
                  ),
                  // Text(
                  //   "3 Days Free Trial, then \$1.99/week",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: ColorConstant.INACTIVE_TEXT,
                  //     decoration: TextDecoration.none,
                  //     fontSize: ScreenSizeConfig.safeBlockHorizontal * 2.5,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          animatorSet: [
            TY(
              from: 0.0,
              to: 5.0,
              duration: 400,
              delay: 0,
              curve: Curves.fastOutSlowIn,
            ),
            TY(
              from: 5.0,
              to: 0.0,
              duration: 400,
              curve: Curves.fastOutSlowIn,
            ),
          ],
        ),

        //Restore btn
        Container(
          margin: EdgeInsets.all(5),
          child: FlatButton(
            onPressed: () {
              _goRestorePurchase();
            },
            child: Text(
              "Restore Purchase",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.BAR_MAIN,
                decoration: TextDecoration.none,
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 2.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildRadioSelector(List<ProductDetails> products, String percentagePrice) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildItemRadio(0, products[0].title, products[0].price,
            isOffer: DefaultValue.OFFER_PRODUCE_IAP == products[0].id),
        _buildItemRadio(1, products[1].title, products[1].price,
            isOffer: DefaultValue.OFFER_PRODUCE_IAP == products[1].id),
        _buildItemRadio(2, products[2].title, products[2].price,
            isOffer: DefaultValue.OFFER_PRODUCE_IAP == products[2].id),
        Container(
          margin: EdgeInsets.only(
            top: 5,
            bottom: ScreenSizeConfig.blockSizeVertical * 2,
          ),
          child: Text(
            "*Percentage of the weekly cost of $percentagePrice",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.BAR_MAIN,
              decoration: TextDecoration.none,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 2.5,
            ),
          ),
        )
      ],
    );
  }

  _buildItemRadio(int packIdx, String namePack, String pirce,
      {bool isOffer: false}) {
    return Container(
      margin: EdgeInsets.only(
          top: ScreenSizeConfig.blockSizeVertical * .5,
          bottom: ScreenSizeConfig.blockSizeVertical * .5),
      decoration: BoxDecoration(
        //color: Colors.pinkAccent,
        border: Border.all(
          width: 1.5,
          color: ColorConstant.FLOATTING_MAIN,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(
        top: 1,
        bottom: 1,
        left: 3,
        right: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isOffer
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "SPECIAL\nOFFER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.lime,
                      decoration: TextDecoration.none,
                      fontSize: ScreenSizeConfig.safeBlockHorizontal * 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Center(),
          Radio(
            activeColor: ColorConstant.BUTTON_MAIN,
            value: packIdx,
            groupValue: this._packSelected,
            onChanged: (idxChange) {
              setState(() {
                _packSelected = idxChange;
              });
            },
          ),
          Container(
            height: ScreenSizeConfig.blockSizeVertical * 3.0,
            width: 1,
            color: ColorConstant.INACTIVE_TEXT,
            margin: EdgeInsets.only(
              left: 5,
              right: 5,
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                namePack,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstant.FLOATTING_MAIN,
                  decoration: TextDecoration.none,
                  fontSize: ScreenSizeConfig.safeBlockHorizontal * 3,
                ),
              ),
              Text(
                pirce,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstant.BAR_MAIN,
                  decoration: TextDecoration.none,
                  fontSize: ScreenSizeConfig.safeBlockHorizontal * 3,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildPurchasePending() {
    return Container(
      height: ScreenSizeConfig.blockSizeVertical * 30,
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "Purchase in progress ...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.BAR_MAIN,
                decoration: TextDecoration.none,
                fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      )),
    );
  }

  _buildSuccessIAP() {
    return Container(
      height: ScreenSizeConfig.blockSizeVertical * 30,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            "You are all set\nYour purchase was succesfull.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.BAR_MAIN,
              decoration: TextDecoration.none,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          RaisedButton(
            color: ColorConstant.FLOATTING_MAIN,
            child: Text(
              "Done",
              style: TextStyle(
                color: ColorConstant.BAR_MAIN,
              ),
            ),
            onPressed: () {
              _goDrawerPage();
            },
          ),
        ],
      ),
    );
  }

  _buildUnavaibleIAP() {
    return Container(
      height: ScreenSizeConfig.blockSizeVertical * 30,
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            "Unavailable IAP package or Purchase cannot be verified,\nPlease retry later",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.BUTTON_MAIN,
              decoration: TextDecoration.none,
              fontSize: ScreenSizeConfig.safeBlockHorizontal * 3.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          RaisedButton(
            color: ColorConstant.BAR_MAIN,
            child: Text(
              "Back",
              style: TextStyle(
                color: ColorConstant.ACTIVE_TEXT,
              ),
            ),
            onPressed: () {
              _iapBloc.add(LoadIAPEvent());
            },
          )
        ],
      ),
    );
  }

  /// callback
  _onPurchaseCallback(bool isSuccessed, String message) {
    if (isSuccessed) {
      //show dialog
    } else {
      //show dialog
    }
    _iapBloc.add(PurchaseResultEvent(isSuccessed));
  }

  // Action direction
  _goRestorePurchase() {
    print("Restore purchase:");
    _iapBloc.add(RestorePurchaseEvent());
  }

  _goBuySubScription() {
    print("Buy purchase:");
    _iapBloc.add(BuysIAPEvent(_products[_packSelected]));
    //_connection.isAvailable();
  }

  _goPrivacyPolicy() {
    _launchURL("http://abc.com/privacy-policy/");
  }

  _goEULA() {
    _launchURL("http://abc.com/terms-of-use/");
  }

  //
  _goDrawerPage() {
    Navigator.pushNamedAndRemoveUntil(context, NavigationConstant.DRAWER_PAGE,
        (Route<dynamic> route) => false);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
