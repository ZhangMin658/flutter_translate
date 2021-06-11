import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/constant/navigation_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/action/action_bloc.dart';
import 'package:scan_and_translate/function/bloc/language/language_bloc.dart';
import 'package:scan_and_translate/function/bloc/live_detection/live_detection_bloc.dart';
import 'package:scan_and_translate/function/common/database/translate_history.dart';
import 'package:scan_and_translate/function/common/model/history_obj.dart';
import 'package:scan_and_translate/function/utils/firebase_vision.dart';
import 'package:scan_and_translate/function/utils/global_key.dart';
import 'package:scan_and_translate/function/utils/my_iap.dart';
import 'package:scan_and_translate/function/widget/camera.dart';

class LiveScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LiveScanState();
  }
}

class _LiveScanState extends State<LiveScan> {
  CameraController _cameraController;
  ImageRotation _imageRotation;
  bool _isDetecting = false;
  bool _isCanDetect = true;
  MyFirebaseVision _myFirebaseVision = MyFirebaseVision();
  LiveDetectionBloc _liveDetectionBloc;
  List<FloatingActionButton> _actionButtons;
  FloatingActionButton _actionPause;
  FloatingActionButton _actionResume;
  FloatingActionButton _actionSave;

  @override
  void initState() {
    _liveDetectionBloc = LiveDetectionBloc();
    _actionButtons = List<FloatingActionButton>();
    _actionPause = FloatingActionButton(
      heroTag: "Pause Scan",
      backgroundColor: ColorConstant.BUTTON_MAIN,
      mini: true,
      child: Icon(Icons.pause),
      onPressed: _pauseScanPressed,
    );
    _actionResume = FloatingActionButton(
      heroTag: "Resume Scan",
      backgroundColor: ColorConstant.FLOATTING_MAIN,
      mini: true,
      child: Icon(Icons.play_arrow),
      onPressed: _resumeScanPressed,
    );

    _actionSave = FloatingActionButton(
      heroTag: "Save action",
      backgroundColor: Colors.blueAccent,
      mini: true,
      child: Icon(Icons.favorite),
      onPressed: () {
        String id = HistoryObj.generateId();
        HistoryObj _historyObj = HistoryObj.fromId(
          id: id,
          scanLangCode: LanguageBloc.fromLang.codeForTranslate,
          scanText: _liveDetectionBloc.visionText.text,
          translateLangCode: LanguageBloc.toLang.codeForTranslate,
          translateText: _liveDetectionBloc.translationResponse.translatedText,
          dateTime: DateTime.now().toString(),
        );
        TranslateHistoryDB.translateHistoryDB
            .updateRowByJoin(_historyObj, "id");
        showNotification(textNoti: "Saved to Stogare");
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!MyIAP.iap.isPremiumUserAvalible) {
      return Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children: <Widget>[
            _buildDetectionNotSupport(
                "Upgrade to PREMIUM USER\nto use Live Detect feature!"),
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
    //For Chinese, Japanese, and Korean text (only supported by the cloud-based APIs)
    if (LanguageBloc.fromLang == Language.JA ||
        LanguageBloc.fromLang == Language.ZH_CN ||
        LanguageBloc.fromLang == Language.ZH_TW ||
        LanguageBloc.fromLang == Language.KO) {
      String message =
          "Sorry! Live detect feature not support ${LanguageBloc.fromLang.name} language.\nPlease select other language and try again!";
      return _buildDetectionNotSupport(message);
    }

    _actionButtons.clear();
    _actionButtons.add(_actionPause);
    ActionBloc().setActions(_actionButtons);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        CameraScanner(
          onCameraControlerInited: _onInitedCameraController,
          onImageRotationInited: _onInitedImageRotation,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                color: Color.fromARGB(50, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder(
                        initialData: null,
                        stream: _liveDetectionBloc.liveDetectionStream,
                        builder: (context, snapshoot) {
                          if (snapshoot.hasData && snapshoot.data != null) {
                            return _buildLableScaned(snapshoot.data);
                          } else {
                            return Center();
                          }
                        },
                      ),
                    ),
                    Container(
                      color: ColorConstant.ACTIVE_TEXT,
                      height: 1,
                      margin: EdgeInsets.all(5),
                    ),
                    //button coppy
                    StreamBuilder(
                        initialData: null,
                        stream: _liveDetectionBloc.liveTranslateStream,
                        builder: (context, snapshoot) {
                          if (snapshoot.hasData && snapshoot.data != null) {
                            return _buildBarBtnCopy();
                          } else {
                            return Center();
                          }
                        }),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ],
    );
  }

  _onInitedCameraController(CameraController cameraController) {
    _cameraController = cameraController;
    _setStreamCameraDetect();
  }

  _onInitedImageRotation(ImageRotation imageRotation) {
    _imageRotation = imageRotation;
  }

  _setStreamCameraDetect() async {
    _cameraController?.startImageStream((CameraImage img) async {
      if (!_isDetecting && _isCanDetect) {
        _isDetecting = true;
        print("Detectinggggg");

        VisionText visionText = await _myFirebaseVision.scanImageByImg(
            img, _imageRotation, LanguageBloc.fromLang);
        _liveDetectionBloc?.updateNewVisionText(visionText);
        print("Detected:\n" + visionText.text);
        _isDetecting = false;
      }
    });
  }

  _buildLableScaned(VisionText visionText) {
    return Container(
      width: ScreenSizeConfig.screenWidth,
      margin: EdgeInsets.all(10),
      //color: Colors.deepOrangeAccent,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Text(
                visionText.text,
                style: TextStyle(color: ColorConstant.ACTIVE_TEXT),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            color: ColorConstant.ACTIVE_TEXT,
            width: 1,
            margin: EdgeInsets.all(10),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: StreamBuilder(
                initialData: null,
                stream: _liveDetectionBloc.liveTranslateStream,
                builder: (context, snapshoot) {
                  if (snapshoot.hasData && snapshoot.data != null) {
                    return Text(
                      snapshoot.data.translatedText,
                      style: TextStyle(color: ColorConstant.ACTIVE_TEXT),
                      textAlign: TextAlign.left,
                    );
                  } else {
                    return Text(
                      "Pressing pause scan button to translate the text scanned!",
                      style: TextStyle(color: ColorConstant.ACTIVE_TEXT),
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBarBtnCopy() {
    return Container(
      margin: EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(
                  left: ScreenSizeConfig.blockSizeHorizontal * 2),
              //color: ColorConstant.BUTTON_MAIN,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: ColorConstant.BUTTON_MAIN,
                ),
                color: ColorConstant.BUTTON_MAIN,
                borderRadius: BorderRadius.circular(
                    ScreenSizeConfig.safeBlockVertical * 5),
              ),
              child: SizedBox(
                height: 20,
                width: 80,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(
                        text: _liveDetectionBloc.visionText.text));
                    showNotification(textNoti: "Copied to Clipboard");
                  },
                  child: Text(
                    "Copy scan",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstant.ACTIVE_TEXT,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(
                  left: ScreenSizeConfig.blockSizeHorizontal * 2),
              //color: ColorConstant.BUTTON_MAIN,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: ColorConstant.BUTTON_MAIN,
                ),
                color: ColorConstant.BUTTON_MAIN,
                borderRadius: BorderRadius.circular(
                    ScreenSizeConfig.safeBlockVertical * 5),
              ),
              child: SizedBox(
                height: 20,
                width: 80,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(
                        text: _liveDetectionBloc
                            .translationResponse.translatedText));
                    showNotification(textNoti: "Copied to Clipboard");
                  },
                  child: Text(
                    "Copy translate",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstant.ACTIVE_TEXT,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDetectionNotSupport(String message) {
    _actionButtons.clear();
    ActionBloc.actionBloc.setActions(_actionButtons);
    return Container(
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
              Icons.visibility_off,
              size: ScreenSizeConfig.blockSizeHorizontal * 10,
              color: ColorConstant.BUTTON_MAIN,
            ),
            Container(
              margin: EdgeInsets.all(ScreenSizeConfig.blockSizeHorizontal * 5),
              child: Text(
                message,
                style: TextStyle(
                  color: ColorConstant.BUTTON_MAIN,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _pauseScanPressed() {
    _actionButtons.clear();
    _actionButtons.add(_actionResume);
    _actionButtons.add(_actionSave);
    ActionBloc().setActions(_actionButtons);
    _liveDetectionBloc.updateNewTranslateText(true);
    _isCanDetect = false;
  }

  _resumeScanPressed() {
    _actionButtons.clear();
    _actionButtons.add(_actionPause);
    ActionBloc().setActions(_actionButtons);
    _liveDetectionBloc.updateNewTranslateText(false);
    _isCanDetect = true;
  }
}
