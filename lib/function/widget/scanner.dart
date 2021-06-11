import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_villains/villain.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/constant/navigation_constant.dart';
import 'package:scan_and_translate/common/constant/string_constant.dart';
import 'package:scan_and_translate/common/util/app_orientation.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/action/action_bloc.dart';
import 'package:scan_and_translate/function/bloc/bloc.dart';
import 'package:scan_and_translate/function/bloc/language/language_bloc.dart';
import 'package:scan_and_translate/function/bloc/scanner/scanner_bloc.dart';
import 'package:scan_and_translate/function/common/database/translate_history.dart';
import 'package:scan_and_translate/function/common/model/history_obj.dart';
import 'package:scan_and_translate/function/utils/global_key.dart';
import 'package:scan_and_translate/function/utils/send_mail.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class Scanner extends StatefulWidget {
  final File imageFile;
  final void Function() backCallback;

  Scanner({@required this.imageFile, @required this.backCallback});

  @override
  _ScannerState createState() {
    return _ScannerState(imageFile: imageFile, backCallback: backCallback);
  }
}

class _ScannerState extends State<Scanner> {
  final File imageFile;
  final void Function() backCallback;
  ScannerBloc _scannerBloc;
  _ScannerState({@required this.imageFile, @required this.backCallback});

  List<FloatingActionButton> _listAction;
  FloatingActionButton _actionBack;

  TextEditingController _txtScannedController = TextEditingController();
  TextEditingController _txtTranslatedController = TextEditingController();

  //TTS
  FlutterTts _flutterTts;

  @override
  void initState() {
    _flutterTts = FlutterTts();
    _scannerBloc = ScannerBloc();
    _scannerBloc.add(ScanTextEvent(imageFile));
    _listAction = List<FloatingActionButton>();
    _actionBack = FloatingActionButton(
      heroTag: "Back action",
      backgroundColor: Colors.lightBlueAccent[700],
      mini: true,
      child: Icon(Icons.arrow_back_ios),
      onPressed: () {
        backCallback();
      },
    );
    _listAction.add(_actionBack);
    ActionBloc.actionBloc.setActions(_listAction);
    super.initState();
  }

  @override
  void dispose() {
    _scannerBloc?.close();
    AppOrientation.setFullScreenApp();
    super.dispose();
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          AppOrientation.setFullScreenApp();
        },
        child: KeyboardAvoider(
          autoScroll: true,
          child: Container(
            child: BlocBuilder(
              bloc: _scannerBloc,
              builder: _bodyBlocBuild,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyBlocBuild(BuildContext context, ScannerState state) {
    if (state is InitialScannerState || state is ScanningState) {
      return _buildBodyBy(
        topChild: _buildImageForScan(imageFile),
        bottomChild: _buildScaningContent(),
      );
    }

    if (state is ScannedState) {
      ///get % of lang recognized
      Map<String, int> langRecognized = Map<String, int>();
      state.visionTextScanned.blocks.forEach((itemBlock) {
        if (itemBlock.recognizedLanguages.length > 0) {
          RecognizedLanguage langReg = itemBlock.recognizedLanguages[0];
          langRecognized.containsKey(langReg.languageCode)
              ? langRecognized[langReg.languageCode] =
                  langRecognized[langReg.languageCode] + 1
              : langRecognized.addAll({langReg.languageCode: 1});
        }
      });
      int langMaxRecogn = 0;
      int sumLang = 0;
      String keyMaxRecogn = "";
      langRecognized.forEach((k, v) {
        sumLang += v;
        if (langMaxRecogn < v) {
          langMaxRecogn = v;
          keyMaxRecogn = k;
        }
      });
      if (keyMaxRecogn != "" &&
          keyMaxRecogn != LanguageBloc.fromLang.codeForTranslate) {
        if (Language.getLangByCode(keyMaxRecogn) != null) {
          String message =
              "We are recoginze ${(langMaxRecogn / sumLang * 100).floor()}% ${Language.getLangByCode(keyMaxRecogn).name}, Are you want to change source language for translate?";
          _buildBottomSheet(
              message: message,
              actionName: "Change",
              actionPressed: () {
                LanguageBloc.languageBloc
                    .setFromLang(Language.getLangByCode(keyMaxRecogn));
              });
        }
      }
      //build UI
      return _buildBodyBy(
        topChild: _buildImageForScan(imageFile),
        bottomChild: _buildScannedContent(state.visionTextScanned.text),
      );
    }
    if (state is TranslatingStateState) {
      _listAction.clear();
      _listAction.add(_actionBack);
      ActionBloc.actionBloc.setActions(_listAction);
      return _buildBodyBy(
        topChild: _buildScannedContent(state.textScanned),
        bottomChild: _buildTranslatingContent(),
      );
    }

    if (state is TranslatedStateState) {
      return _buildBodyBy(
        topChild: _buildScannedContent(state.textScanned),
        bottomChild:
            _buildTranslatedContent(state.textScanned, state.textTranslated),
      );
    }

    if (state is NeedUpdatePremiumState) {
      return _buildNotSupport();
    }

    return Center();
  }

  _buildBodyBy({Widget topChild, Widget bottomChild}) {
    return Container(
      margin: EdgeInsets.all(ScreenSizeConfig.blockSizeVertical),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Villain(
            villainAnimation: VillainAnimation.scale(
              fromScale: 0.0,
              toScale: 1.0,
              from: Duration(milliseconds: 100),
              to: Duration(milliseconds: 500),
            ),
            animateExit: true,
            secondaryVillainAnimation: VillainAnimation.fade(),
            child: topChild,
          ),
          Divider(
            color: ColorConstant.BAR_MAIN,
            height: 0,
          ),
          Villain(
            villainAnimation: VillainAnimation.scale(
              fromScale: 0.0,
              toScale: 1.0,
              from: Duration(milliseconds: 100),
              to: Duration(milliseconds: 500),
            ),
            animateExit: true,
            secondaryVillainAnimation: VillainAnimation.fade(),
            child: bottomChild,
          ),
        ],
      ),
    );
  }

  _buildScaningContent() {
    _listAction.clear();
    _listAction.add(_actionBack);
    ActionBloc.actionBloc.setActions(_listAction);
    return Container(
      height: ScreenSizeConfig.safeBlockVertical * 35,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _buildTranslatingContent() {
    _listAction.clear();
    _listAction.add(_actionBack);
    ActionBloc.actionBloc.setActions(_listAction);
    return Container(
      height: ScreenSizeConfig.safeBlockVertical * 35,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildImageForScan(File image) {
    return Container(
      alignment: Alignment.center,
      height: ScreenSizeConfig.safeBlockVertical * 35,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  _buildScannedContent(String textScanned) {
    if (textScanned == "") {
      _txtScannedController.text = "Not have text scanned!";
      _buildShowNoti();
    } else {
      _txtScannedController.text = textScanned;
    }
    FloatingActionButton translateAction = FloatingActionButton(
      heroTag: "Translate action",
      backgroundColor: Colors.deepOrange,
      mini: true,
      child: Icon(Icons.g_translate),
      onPressed: () {
        _callTranslateText(_txtScannedController.text.trim());
      },
    );
    _listAction.clear();
    _listAction.add(_actionBack);
    _listAction.add(translateAction);
    ActionBloc.actionBloc.setActions(_listAction);
    return Material(
      elevation: 10,
        borderRadius: BorderRadius.circular(25),
      child: Container(
        height: ScreenSizeConfig.safeBlockVertical * 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[300],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white
              ),
              padding: EdgeInsets.all(15),

              child: SizedBox(
                height: ScreenSizeConfig.safeBlockVertical * 25,
                child: TextFormField(
                  controller: _txtScannedController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    //fontSize: ScreenSizeConfig.safeBlockVertical * 2,
                  ),
                  expands: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: StringConstant.TEXT_SCANNED,
                    labelStyle: TextStyle(
                      color: ColorConstant.FLOATTING_MAIN,
                      //fontSize: ScreenSizeConfig.safeBlockHorizontal * 4,
                      fontWeight: FontWeight.normal,
                    ),

                    // prefixIcon: Icon(
                    //   Icons.verified_user,
                    //   color: ColorConstant.BUTTON_MAIN,
                    // ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          width: 1,
                          color: _txtScannedController.text == ""
                              ? Colors.white
                              : Colors.white),
                    ),
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.all(ScreenSizeConfig.safeBlockHorizontal * 3),
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 15, bottom: 5),
              child: StreamBuilder(
                initialData: LanguageBloc.fromLang,
                stream: LanguageBloc.fromLangSteam,
                builder: (context, AsyncSnapshot<Lang> snapshot) {
                  if (snapshot.hasData) {
                    return _buildBarActionTextResult(
                        snapshot.data, _txtScannedController);
                  } else {
                    return Center();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTranslatedContent(String textScanned, String textTranslated) {
    _txtTranslatedController.text = textTranslated;
    if (textTranslated == "") {
      _txtTranslatedController.text = "Not have text scanned!";
    }
    FloatingActionButton translateAction = FloatingActionButton(
      heroTag: "Translate action",
      backgroundColor: Colors.deepOrange,
      mini: true,
      child: Icon(Icons.g_translate),
      onPressed: () {
        _callTranslateText(_txtScannedController.text.trim());
      },
    );
    //save
    FloatingActionButton saveAction = FloatingActionButton(
      heroTag: "Save action",
      backgroundColor: Colors.blueAccent,
      mini: true,
      child: Icon(Icons.favorite),
      onPressed: () {
        String id = HistoryObj.generateId();
        HistoryObj _historyObj = HistoryObj.fromId(
          id: id,
          scanLangCode: LanguageBloc.fromLang.codeForTranslate,
          scanText: textScanned,
          translateLangCode: LanguageBloc.toLang.codeForTranslate,
          translateText: textTranslated,
          dateTime: DateTime.now().toString(),
        );
        TranslateHistoryDB.translateHistoryDB
            .updateRowByJoin(_historyObj, "id");
        showNotification(textNoti: "Saved to Stogare");
      },
    );
    //share
    FloatingActionButton shareAction = FloatingActionButton(
      heroTag: "Share action",
      backgroundColor: Colors.purple,
      mini: true,
      child: Icon(Icons.save_alt),
      onPressed: () {
        //_callTranslateText(_txtScannedController.text.trim());
        SendMail.showBottomSheetInputMail(
            context: context,
            bodyStr: SendMail.buildBodyEmailByTranslate(
              formLang: LanguageBloc.fromLang.name,
              toLang: LanguageBloc.toLang.name,
              txtFrom: textScanned,
              txtTranslate: textTranslated,
            ));
      },
    );
    _listAction.clear();
    _listAction.add(_actionBack);
    _listAction.add(translateAction);
    _listAction.add(saveAction);
    _listAction.add(shareAction);

    ActionBloc.actionBloc.setActions(_listAction);
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(25),
      child:  Container(
        height: ScreenSizeConfig.safeBlockVertical * 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[300],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white
              ),
              padding: EdgeInsets.all(15),

              child: SizedBox(
                height: ScreenSizeConfig.safeBlockVertical * 25,
                child: TextFormField(
                  controller: _txtTranslatedController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.justify,
                  expands: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: StringConstant.TEXT_TRANSLATED,
                    labelStyle: TextStyle(
                      color: ColorConstant.BUTTON_MAIN,
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          width: 1,
                          color: _txtTranslatedController.text == ""
                              ? Colors.white
                              : Colors.white),
                    ),
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.all(ScreenSizeConfig.safeBlockHorizontal * 3),
                  ),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 15, bottom: 5),
              child: StreamBuilder(
                initialData: LanguageBloc.toLang,
                stream: LanguageBloc.toLangStream,
                builder: (context, AsyncSnapshot<Lang> snapshot) {
                  if (snapshot.hasData) {
                    return _buildBarActionTextResult(
                        snapshot.data, _txtTranslatedController);
                  } else {
                    return Center();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildNotSupport() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(15),
            child: Card(
              //color: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.lock,
                    size: ScreenSizeConfig.blockSizeHorizontal * 10,
                    color: ColorConstant.BUTTON_MAIN,
                  ),
                  Container(
                    margin: EdgeInsets.all(
                        ScreenSizeConfig.blockSizeHorizontal * 5),
                    child: Text(
                      "Upgrade PREMIUM USER to continue!",
                      style: TextStyle(
                        color: ColorConstant.BUTTON_MAIN,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RaisedButton(
            color: ColorConstant.BUTTON_MAIN,
            child: Text(
              "Get Premium",
              style: TextStyle(
                color: ColorConstant.ACTIVE_TEXT,
              ),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  NavigationConstant.SUBSCRIPTION_PAGE,
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  _buildBarActionTextResult(
      Lang lang, TextEditingController textEditingController) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //language
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: ColorConstant.FLOATTING_MAIN,
            ),
            borderRadius:
                BorderRadius.circular(ScreenSizeConfig.safeBlockVertical * 5),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.flag,
                color: ColorConstant.BUTTON_MAIN,
                size: 20,
              ),
              Container(
                width: ScreenSizeConfig.safeBlockHorizontal,
              ),
              Text(
                "${lang.name}",
                style: TextStyle(
                  color: ColorConstant.BUTTON_MAIN,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          margin:
              EdgeInsets.only(left: ScreenSizeConfig.blockSizeHorizontal * 2),
          //color: ColorConstant.BUTTON_MAIN,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: lang.codeForSpeech == ""
                  ? ColorConstant.INACTIVE_TEXT
                  : ColorConstant.BUTTON_MAIN,
            ),
            color: lang.codeForSpeech == ""
                ? ColorConstant.INACTIVE_TEXT
                : ColorConstant.BUTTON_MAIN,
            borderRadius:
                BorderRadius.circular(ScreenSizeConfig.safeBlockVertical * 5),
          ),
          child: SizedBox(
            height: 20,
            width: 20,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                if (lang.codeForSpeech != "") {
                  _speechText(
                      lang.codeForSpeech, textEditingController.text.trim());
                }
              },
              iconSize: 20,
              icon: Icon(
                lang.codeForSpeech == "" ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          margin:
              EdgeInsets.only(left: ScreenSizeConfig.blockSizeHorizontal * 2),
          //color: ColorConstant.BUTTON_MAIN,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: ColorConstant.BUTTON_MAIN,
            ),
            color: ColorConstant.BUTTON_MAIN,
            borderRadius:
                BorderRadius.circular(ScreenSizeConfig.safeBlockVertical * 5),
          ),
          child: SizedBox(
            height: 20,
            width: 50,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                Clipboard.setData(
                    new ClipboardData(text: textEditingController.text.trim()));
                showNotification(textNoti: "Copied to Clipboard");
              },
              child: Text(
                "Copy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorConstant.ACTIVE_TEXT,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildBottomSheet(
      {String message, String actionName, Function actionPressed}) async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: ColorConstant.BAR_MAIN,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: 15,
              top: 15,
              left: 10,
              right: 10,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstant.ACTIVE_TEXT,
                  ),
                ),
                Container(
                  height: 3,
                ),
                SizedBox(
                  height: ScreenSizeConfig.blockSizeHorizontal * 8,
                  child: FlatButton(
                    child: Text(
                      actionName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorConstant.FLOATTING_MAIN,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(bc);
                      mainScaffoldKey.currentState.hideCurrentSnackBar();
                      actionPressed();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Notify
  _buildShowNoti() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
    showNotification(
        textNoti:
            "For Chinese, Japanese, and Korean text please select language-scan for accurate return results");
  }

  ///Call translate text
  _callTranslateText(String text) {
    if (text.trim() != "") {
      _scannerBloc.add(
        TranslateTextEvent(text),
      );
    } else {
      //todo alert text can't translate
      showNotification(textNoti: "The text translate can not empty!");
    }
  }

  ///Call speech text
  _speechText(String lang, String text) async {
    await _flutterTts.setLanguage(lang);
    //TTS Speech
    var result = await _flutterTts.speak(text);
    print("Speech:: ${result.toString()}");
  }
}
