import 'dart:async';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/constant/string_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/components/record_button.dart';
import 'package:scan_and_translate/function/bloc/language/language_bloc.dart';
import 'package:scan_and_translate/function/common/model/translate_respose_obj.dart';
import 'package:scan_and_translate/function/common/server/translate_client_api.dart';
import 'package:scan_and_translate/function/utils/global_key.dart';
import 'package:scan_and_translate/function/widget/language_selector.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  FlutterTts _flutterTts;
  TextEditingController _txtTranslatedController = TextEditingController();
  final _translateApi = TranslateApi();

  GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _flutterTts = FlutterTts();
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mainScaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Column(
            children: [
              LanguageSelector(),
              Text(_text, style: TextStyle(
                fontSize: 20
              ),),
              _buildTranslatedContent(),
            ],
          ),
        ),
      ),
    );
  }
  _buildTranslatedContent() {
    _txtTranslatedController.text = '';
    if (_txtTranslatedController.text.trim() == "") {
      _txtTranslatedController.text = "Not have text input!";
    }

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white
              ),
              padding: EdgeInsets.all(15),

              child:   SizedBox(
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
  void _listen() async {
    if (!_isListening) {
      setState(() {
        _text =  '';
      });
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() async {
            _text = val.recognizedWords;
            TranslationResponse translationResponse =
                await _translateApi.translateText(
                toLang: LanguageBloc.toLang.codeForTranslate,
                text: _text);
            String textTranslated =
            translationResponse.translatedText.replaceAll(". ", ".\n");
            textTranslated = textTranslated.replaceAll(": ", ":\n");
            _txtTranslatedController.text = textTranslated;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
  _speechText(String lang, String text) async {
    await _flutterTts.setLanguage(lang);
    //TTS Speech
    var result = await _flutterTts.speak(text);
    print("Speech:: ${result.toString()}");
  }
  showNotification({String textNoti}) {
    mainScaffoldKey.currentState.showSnackBar(
      new SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColorConstant.INACTIVE_TEXT,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        content: InkWell(
          child: Row(
            children: <Widget>[
              Icon(Icons.info_outline),
              Expanded(
                child: Text(
                  textNoti,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 1,
                width: 10,
              ),
            ],
          ),
          onTap: () {
            mainScaffoldKey.currentState.removeCurrentSnackBar();
          },
        ),
      ),
    );
  }

}